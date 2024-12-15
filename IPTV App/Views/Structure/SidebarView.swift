//
//  SidebarView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import M3UKit
import SwiftData
import SwiftUI

struct SidebarView: View {

	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(\.modelContext) private var context
	@Environment(AppState.self) private var appState

	@Query private var modelPlaylists: [Playlist]

	var body: some View {
		VStack {
			if modelPlaylists.isEmpty {
				ContentUnavailableView {
					Label("No Playlists", systemImage: "list.and.film")
				} description: {
					Text("Playlists that you add will appear here.")
				} actions: {
					Button("Add Playlist") {
						appState.isAddingPlaylist.toggle()
					}
				}
			} else {
				List(modelPlaylists, selection: Bindable(appState).selectedPlaylist) { playlist in
					PlaylistCellView(playlist)
						.tag(playlist)
						#if !os(macOS)
							.badge(playlist.medias.count)
						#endif
				}
			}
		}
		.navigationTitle("Playlists")
		.navigationSplitViewColumnWidth(min: 216, ideal: 216)
		.toolbar(id: "playlistsToolbar") {
			ToolbarItem(id: "addPlaylist") {
				Button("Add Playlist", systemImage: "plus") {
					appState.isAddingPlaylist.toggle()
				}
			}

			ToolbarItem(id: "openSingleStream") {
				Button("Open Stream", systemImage: "play") {
					appState.openedSingleStream.toggle()
				}
			}
		}
	}
}
