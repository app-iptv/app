//
//  MediaDetailView.swift
//  IPTV App
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
	@Environment(AppState.self) var appState
	@Environment(SceneState.self) var sceneState

	@State var viewModel: MediaDetailViewModel = MediaDetailViewModel()

	let media: Media

	internal init(media: Media) {
		self.media = media
	}

	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 10) {
				PlayerViewControllerRepresentable(media: media, playlistName: playlistName)
					.aspectRatio(16 / 9, contentMode: .fit)
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

			if epgLink.isEmpty {
				Spacer()
			} else if appState.isLoadingEPG {
				VStack {
					Spacer()
					ProgressView("Loading EPG...")
					Spacer()
				}
			} else if let programs = viewModel.programs, !programs.isEmpty {
				viewModel.epgListView
			} else if viewModel.programs == nil {
				viewModel.noProgramsForChannelView
			}
		}
		.navigationTitle(media.title)
		.task(id: fetchingModel.xmlTV, fetchPrograms)
		.toolbarTitleDisplayMode(.inline)
		#if !os(macOS)
		.toolbarBackground(.visible, for: .navigationBar, .tabBar)
		#endif
	}
}

extension MediaDetailView {
	@Sendable func fetchPrograms() async {
		await viewModel.fetchPrograms(for: media, with: fetchingModel, and: appState)
	}
	
	var playlistName: String {
		switch sceneState.selectedTab {
			case .playlist(let playlist): return playlist.name
			default: return "Unknown Playlist Name"
		}
	}
	
	var epgLink: String {
		switch sceneState.selectedTab {
			case .playlist(let playlist): return playlist.epgLink
			default: return ""
		}
	}
}
