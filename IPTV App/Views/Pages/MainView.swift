//
//  MainView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 08/11/2024.
//

import SwiftUI
import SwiftData
import Foundation
import M3UKit
import SDWebImageSwiftUI
import TipKit
import XMLTV

struct MainView: View {
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(\.isSearching) private var searchState
	@Environment(AppState.self) private var appState
	@Environment(SceneState.self) private var sceneState
	
	@AppStorage("MEDIA_DISPLAY_MODE") private var mediaDisplayMode: MediaDisplayMode = .list
	
	@Query private var playlists: [Playlist]

	@State private var searchQuery: String = ""
	@State private var favouritesTip: FavouritesTip = FavouritesTip()
	@State private var viewModel: MediasViewModel = MediasViewModel()
	
	var body: some View {
		NavigationStack {
			Group {
				if let playlist = sceneState.selectedPlaylist {
					MediasView(playlist)
				} else {
					ContentUnavailableView {
						Label("No Playlist", systemImage: "list.bullet")
					} description: {
						Text("Select a playlist to view its medias.")
					}
				}
			}
			.navigationTitle(sceneState.selectedPlaylist?.name ?? "IPTV App")
			.toolbarTitleDisplayMode(.inline)
			.toolbarTitleMenu { MainViewTitleMenu() }
			.toolbar(id: "main") { PlaylistsToolbar(main: true) }
		}
	}
}
