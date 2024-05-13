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
	
	@State private var searchQuery: String = ""
	@State private var isUnsupported: Bool = false
	@State private var currentProgram: TVProgram? = nil
	@State private var vm = ViewModel.shared
	@State private var hasFinishedLoading: Bool = false
	
	let playlistName: String
	let media: Media
	let epgLink: String
	
	@State var programs: [TVProgram]?
	@Binding var xmlTV: XMLTV?
	
	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 10) {
				PlayerView(media: media, playlistName: playlistName)
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
				.ignoresSafeArea(.all)s8
			#if !targetEnvironment(macCatalyst)
				.shadow(color: .primary, radius: 0.2, x: 0, y: 0.1)
			#endif
			
			if vm.isLoadingEPG {
				VStack {
					Spacer()
					ProgressView()
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
								.id(EPGFetchingModel.shared.isNowBetweenDates(program: program))
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
				.refreshable { await fetchData(); await refresh() }
			} else if (filteredPrograms?.isEmpty ?? true) && !(programs?.isEmpty ?? true) {
				ContentUnavailableView.search(text: searchQuery)
			} else if let _ = xmlTV, (programs?.isEmpty ?? true), hasFinishedLoading {
				VStack {
					Spacer()
					ContentUnavailableView("TV Guide is empty", systemImage: "tv.slash", description: Text("The EPG link provided does not include any programs for this channel."))
					Spacer()
				}
			} else {
				Spacer()
			}
		}
		.searchable(text: $searchQuery)
		.navigationTitle(media.title)
		.toolbarTitleDisplayMode(.inline)
		.toolbarBackground(.visible, for: .navigationBar, .tabBar)
		.task { await refresh() }
		.onChange(of: xmlTV) { Task { await refresh() } }
	}
}

extension MediaDetailView {
	
	private var filteredPrograms: [TVProgram]? {
		guard !searchQuery.isEmpty else { return programs }
		return programs?.filter { ($0.title ?? String(localized: "Untitled")).localizedCaseInsensitiveContains(searchQuery) }
	}
	
	private func refresh() async {
		DispatchQueue.global(qos: .userInteractive).async {
			if let xmlTV,
			   let channel = xmlTV.getChannels().first(where: { $0.id == media.attributes["tvg-id"] })
			{
				programs = xmlTV.getPrograms(channel: channel)
			}
			hasFinishedLoading = true
		}
	}
	
	private func fetchData() async {
		do {
			xmlTV = try await EPGFetchingModel.shared.getPrograms(with: epgLink)
			vm.isLoadingEPG = false
		} catch {
			vm.epgModelDidFail = true
			vm.isLoadingEPG = false
		}
	}
}
