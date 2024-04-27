//
//  PlaylistsListView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import SwiftData
import M3UKit

struct PlaylistsListView: View {
	
	@Environment(\.horizontalSizeClass) var sizeClass
	@Environment(\.modelContext) var context
	
	@State var vm = ViewModel.shared
	
	@Query var modelPlaylists: [Playlist]
	
	var body: some View {
		Group {
			if modelPlaylists.isEmpty {
				ContentUnavailableView {
					Label("No Playlists", systemImage: "list.and.film")
				} description: {
					Text("Playlists that you add will appear here.")
				}
			} else {
				List(modelPlaylists, selection: $vm.selectedPlaylist) { playlist in
					PlaylistCellView(playlist)
						.badge(playlist.medias.count)
				}
			}
		}
		.navigationTitle("Playlists")
		.navigationSplitViewColumnWidth(min: 216, ideal: 216)
		#if !targetEnvironment(macCatalyst)
		.toolbar(id: "playlistsToolbar") {
			ToolbarItem(id: "addPlaylist", placement: .topBarTrailing) {
				Button("Add Playlist", systemImage: "plus") { vm.isPresented.toggle() }
			}
			ToolbarItem(id: "openSingleStream", placement: .topBarLeading) {
				Button("Open Stream", systemImage: "play") { vm.openedSingleStream.toggle() }
			}
		}
		#endif
	}
}
