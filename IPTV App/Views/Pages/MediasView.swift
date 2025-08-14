//
//  MediasView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import Foundation
import M3UKit
import SDWebImageSwiftUI
import SwiftUI
import TipKit
import XMLTV

struct MediasView: View {
	@AppStorage("MEDIA_DISPLAY_MODE") var mediaDisplayMode: MediaDisplayMode = .list
	
	@Environment(\.horizontalSizeClass) var sizeClass
	@Environment(\.isSearching) var searchState
	@Environment(AppState.self) var appState
	@Environment(SceneState.self) var sceneState
	@Environment(EPGFetchingController.self) var controller
	
	@State var viewModel: MediasViewModel = MediasViewModel()
	
	@Bindable var playlist: Playlist
	
	internal init(_ playlist: Playlist) {
		self.playlist = playlist
	}
	
	var body: some View {
		Group {
			if mediasForGroup.isEmpty {
				ContentUnavailableView {
					Text("No Medias")
				} description: {
					Text("This playlist does not have any medias.")
				}
			} else {
				List {
					TipView(viewModel.favouritesTip)
						.task { await FavouritesTip.showTipEvent.donate() }

					ForEach(mediasForGroup) { media in
						NavigationLink(value: media) {
							MediaCellView(media: media)
						}
						.badge(playlist.medias.firstIndex(of: media)! + 1)
					}
					.onDelete { playlist.medias.remove(atOffsets: $0) }
					.onMove { playlist.medias.move(fromOffsets: $0, toOffset: $1) }
				}
				.listStyle(.plain)
				.navigationDestination(for: Media.self) { MediaDetailView(media: $0) }
				.navigationDestination(for: TVProgram.self) { EPGProgramDetailView(for: $0) }
			}
		}
		.navigationTitle(playlist.name)
		.task { }
		.toolbar(id: "mediasToolbar") { MediasToolbar(groups: groups) }
		#if os(iOS)
		.toolbarRole(sizeClass!.toolbarRole)
		#endif
	}
}

extension MediasView {
	var groups: [String] { viewModel.groups(for: medias) }
	var selectedGroup: String { sceneState.selectedGroup }
	var mediasForGroup: [Media] { viewModel.filteredMediasForGroup(selectedGroup, medias: medias) }
	
	var medias: [Media] { playlist.medias }
}
