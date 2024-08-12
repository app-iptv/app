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
	
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(\.modelContext) private var context
	@Environment(ViewModel.self) private var vm
	
	@Query private var modelPlaylists: [Playlist]
	
	var body: some View {
		@Bindable var vm = vm
		
		VStack {
			if modelPlaylists.isEmpty {
				ContentUnavailableView {
					Label("No Playlists", systemImage: "list.and.film")
				} description: {
					Text("Playlists that you add will appear here.")
				} actions: {
					Button("Add Playlist") {
						vm.isPresented.toggle()
					}
				}
			} else {
				List(modelPlaylists, selection: $vm.selectedPlaylist) { playlist in
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
			ToolbarItem(id: "addPlaylist", placement: placement1) {
				Button("Add Playlist", systemImage: "plus") { vm.isPresented.toggle() }
			}
			ToolbarItem(id: "openSingleStream", placement: placement2) {
				Button("Open Stream", systemImage: "play") { vm.openedSingleStream.toggle() }
			}
		}
	}
}

extension PlaylistsListView {
	private var placement1: ToolbarItemPlacement {
		#if os(macOS)
		.automatic
		#else
		.topBarTrailing
		#endif
	}
	
	private var placement2: ToolbarItemPlacement {
		#if os(macOS)
		.automatic
		#else
		.topBarLeading
		#endif
	}
}
