//
//  MediaDetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import AVKit
import M3UKit
import SWCompression
import SwiftUI
import XMLTV

struct MediaDetailView: View {

	@Environment(EPGFetchingController.self) var fetchingModel
	@Environment(ViewModel.self) private var vm

	@State private var isUnsupported: Bool = false
	@State private var currentProgram: TVProgram? = nil
	@State private var hasFinishedLoading: Bool = false
	@State private var programs: [TVProgram]? = nil

	private let playlistName: String
	private let media: Media
	private let epgLink: String

	internal init(playlistName: String, media: Media, epgLink: String) {
		self.playlistName = playlistName
		self.media = media
		self.epgLink = epgLink
	}

	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 10) {
				PlayerViewControllerRepresentable(
					media: media, playlistName: playlistName
				)
				.aspectRatio(16 / 9, contentMode: .fit)
				.cornerRadius(10)
				#if !os(macOS)
					.frame(maxWidth: 400)
				#endif

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

			if epgLink.isEmpty {
				Spacer()
			} else if vm.isLoadingEPG {
				VStack {
					Spacer()
					ProgressView("Loading EPG...")
					Spacer()
				}
			} else if let programs, !programs.isEmpty {
				epgListView(programs)
			} else if programs == nil {
				Spacer()
			} else {
				noProgramsForChannelView
			}
		}
		.navigationTitle(media.title)
		.onAppear(perform: fetchPrograms)
		.onChange(of: fetchingModel.xmlTV, fetchPrograms)
		.toolbarTitleDisplayMode(.inline)
        #if !os(macOS)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        #endif
	}
}

extension MediaDetailView {
    private func fetchPrograms() {
        guard let xmlTV = fetchingModel.xmlTV else { return abortFetching() }
        guard let channelID = media.attributes["tvg-id"] else { return abortFetching() }
        
        let channels = xmlTV.getChannels()
        
        guard !channels.isEmpty else { return abortFetching() }
        guard let channel = channels.first(where: { $0.id == channelID }) else { return abortFetching() }
        
        let programs = xmlTV.getPrograms(channel: channel)
        
        guard !programs.isEmpty else { return abortFetching() }
        
        self.programs = programs
        
        abortFetching()
    }
    
    private func abortFetching() {
        vm.isLoadingEPG = false
    }

	private var noProgramsForChannelView: some View {
		VStack {
			Spacer()
			ContentUnavailableView(
				"TV Guide is empty", systemImage: "tv.slash",
				description: Text(
					"The EPG link provided does not include any programs for this channel."
				))
			Spacer()
		}
	}

	private func epgListView(_ programs: [TVProgram]) -> some View {
		ScrollView {
			ScrollViewReader { reader in
				VStack(alignment: .leading, spacing: 0) {
					ForEach(programs, id: \.self) { program in
						NavigationLink(value: program) {
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
            #if !os(macOS)
                .safeAreaPadding(.horizontal, 5)
            #endif
		}
	}
}
