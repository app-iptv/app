//
//  GuideForMediaView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI
import SwiftData
import XMLTV
import SDWebImageSwiftUI

struct GuideForMediaView: View {
	@Query private var modelPlaylists: [Playlist]
	
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
	
	@State private var epgFetchingModel = EPGFetchingModel.shared
	private var media: Media
	
	@State private var isWatching: Bool = false
	@State private var programs: [TVProgram]? = nil
	@State private var vm = ViewModel.shared
	@State private var currentProgram: TVProgram? = nil
	
	internal init(media: Media) {
		self.media = media
	}
	
	var body: some View {
		HStack(spacing: 240) {
			VStack(alignment: .center, spacing: 40) {
				HStack {
					VStack(alignment: .leading, spacing: 0) {
						Text(media.title)
							.font(.headline)
							.fontWeight(.semibold)
						Text(media.attributes["group-title"] ?? "Untitled")
					}
					
					Spacer()
				}
				
				if epgFetchingModel.xmlTV == nil {
					VStack(alignment: .center) {
						Spacer()
						ProgressView()
						Spacer()
					}
				} else {
					ScrollView {
						ScrollViewReader { reader in
							if let programs {
								ForEach(programs) { program in
									GuideProgramItemView(program: program)
										.id(EPGFetchingModel.shared.isNowBetweenDates(program: program))
										.focusable()
								}
								.onAppear {
									withAnimation {
										reader.scrollTo(true, anchor: .center)
									}
								}
							} else if let programs, programs.isEmpty {
								ContentUnavailableView("TV Guide is empty", systemImage: "tv.slash", description: Text("The EPG link provided does not include any program for this channel."))
							}
						}
					}
				}
			}
			.frame(width: 800)
			VStack(spacing: 60) {
				WebImage(url: URL(string: media.attributes["tvg-logo"] ?? "")) { image in
					image
						.resizable()
						.scaledToFit()
						.padding()
				} placeholder: {
					Image(systemName: "photo.tv")
						.imageScale(.large)
				}
				.frame(width: 640, height: 640)
				.background(.ultraThinMaterial)
				.clipShape(.rect(cornerRadius: 10))
				
				Button("Watch", systemImage: "play") { isWatching.toggle() }
					.labelStyle(.iconOnly)
			}
			.frame(width: 640)
		}
		.task { await refresh(); fetchCurrentProgram() }
		.onChange(of: epgFetchingModel.xmlTV) { Task { await refresh(); fetchCurrentProgram() } }
		.fullScreenCover(isPresented: $isWatching) {
			PlayerViewControllerRepresentable(media: media, playlistName: modelPlaylists.safelyAccessElement(at: selectedPlaylist)?.name ?? "Untitled", currentProgram: $currentProgram).ignoresSafeArea()
		}
	}
}

extension GuideForMediaView {
	private func refresh() async {
		DispatchQueue.main.async {
			if let xmlTV = epgFetchingModel.xmlTV,
			   let channel = xmlTV.getChannels().first(where: { $0.id == media.attributes["tvg-id"] })
			{
				programs = xmlTV.getPrograms(channel: channel)
			}
		}
	}
	
	private func fetchCurrentProgram() {
		currentProgram = programs?.first(where: EPGFetchingModel.shared.isNowBetweenDates)

	}
}
