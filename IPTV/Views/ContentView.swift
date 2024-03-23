//
//  HomeView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import SwiftData

// MARK: ContentView
struct ContentView: View {
	
	@Environment(\.modelContext) var context
	@Environment(\.horizontalSizeClass) var sizeClass
	@Bindable var vm: ViewModel
	
	@Query var modelPlaylists: [ModelPlaylist]
	@Binding var favorites: [Playlist.Media]
	
	// MARK: BodyNavigationSplitView
	var body: some View {
		NavigationSplitView {
			Group {
				if modelPlaylists.isEmpty {
					ContentUnavailableView {
						Label("No Playlists", systemImage: "list.and.film")
					} description: {
						Text("Playlists that you add will appear here.")
					}
				} else {
					PlaylistsListView(vm)
				}
			}
			.navigationTitle("Playlists")
			.navigationSplitViewColumnWidth(min: 216, ideal: 216)
			#if !targetEnvironment(macCatalyst)
			.toolbar(id: "playlistsToolbar") {
				ToolbarItem(id: "addPlaylist", placement: .topBarTrailing) { Button("Add Playlist", systemImage: "plus") { vm.isPresented.toggle() } }
				ToolbarItem(id: "openSingleStream", placement: .topBarLeading) { Button("Open Stream", systemImage: "play") { vm.openedSingleStream.toggle() } }
			}
			#endif
		} detail: {
			if let playlist = vm.selectedPlaylist {
				MediaListView(vm: vm, favorites: $favorites, playlist: playlist)
					.navigationTitle(playlist.name)
			} else {
				ContentUnavailableView {
					Label("No Medias", systemImage: "list.and.film")
				} description: {
					Text("The selected playlist's channels will appear here.")
				}
			}
		}
	}
}
