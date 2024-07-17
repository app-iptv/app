//
//  mediaDetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit
import AVKit
import XMLTV
import SWCompression

struct MediaDetailView: View {
	
	@Environment(EPGFetchingModel.self) var fetchingModel
	@Environment(ViewModel.self) private var vm
	
	@State private var searchQuery: String = ""
	@State private var isUnsupported: Bool = false
	@State private var currentProgram: TVProgram? = nil
	@State private var hasFinishedLoading: Bool = false
	
	private let playlistName: String
	private let media: Media
	private let epgLink: String
	
	internal init(playlistName: String, media: Media, epgLink: String) {
		self.playlistName = playlistName
		self.media = media
		self.epgLink = epgLink
	}
	
	var body: some View {
		@Bindable var vm = vm
		
		VStack(spacing: 0) {
			VStack(spacing: 10) {
				PlayerViewControllerRepresentable(media: media, playlistName: playlistName)
					.aspectRatio(16/9, contentMode: .fit)
					.cornerRadius(10)
					.frame(maxWidth: 400)
				HStack {
					VStack(alignment: .leading, spacing: 2.5) {
						if let groupTitle = media.attributes["group-title"] {
							Text(groupTitle)
								.font(.footnote)
						}
						
						Text(media.title)
							.font(.headline)
					}
					Spacer()
				}
				.padding(.bottom, 10)
				.frame(maxWidth: 400)
			}
			.safeAreaPadding([.horizontal, .top])
			
			Divider()
				.ignoresSafeArea(.all)
			#if !os(macOS)
				.shadow(color: .primary, radius: 0.2, x: 0, y: 0.1)
			#endif
			
			if vm.isLoadingEPG {
				VStack {
					Spacer()
					ProgressView("Loading EPG...")
					Spacer()
				}
			} else if let filteredPrograms {
				ScrollView {
					ScrollViewReader { reader in
						VStack(alignment: .leading, spacing: 0) {
							ForEach(filteredPrograms, id: \.self) { program in
								NavigationLink {
									EPGProgramDetailView(for: program)
								} label: {
									EPGProgramView(for: program)
								}
								.buttonStyle(.borderless)
								.foregroundStyle(.primary)
								.id(program.isCurrent())
							}
							.onAppear {
								withAnimation {
									reader.scrollTo(true, anchor: .center)
								}
							}
						}
					}
					.safeAreaPadding(.horizontal, 5)
				}
			} else if (filteredPrograms?.isEmpty ?? true) && !(programs?.isEmpty ?? true) {
				ContentUnavailableView.search(text: searchQuery)
			} else if let _ = fetchingModel.xmlTV, (programs?.isEmpty ?? true) {
				VStack {
					Spacer()
					ContentUnavailableView("TV Guide is empty", systemImage: "tv.slash", description: Text("The EPG link provided does not include any programs for this channel."))
					Spacer()
				}
			} else {
				Spacer()
			}
		}
		#if !os(tvOS)
		.navigationTitle(media.title)
		#endif
		#if os(iOS)
		.toolbarBackground(.visible, for: .navigationBar, .tabBar)
		#endif
		.searchable(text: $searchQuery)
		.toolbarTitleDisplayMode(.inline)
	}
}

extension MediaDetailView {
	private var filteredPrograms: [TVProgram]? {
		guard !searchQuery.isEmpty else { return programs }
		return programs?.filter { ($0.title ?? String(localized: "Untitled")).localizedCaseInsensitiveContains(searchQuery) }
	}
	
	private var programs: [TVProgram]? {
		guard let channel = fetchingModel.xmlTV?.getChannels().first(where: { $0.id == media.attributes["tvg-id"] }),
			  let programs = fetchingModel.xmlTV?.getPrograms(channel: channel) else { return nil }
		
		return programs
	}
}
