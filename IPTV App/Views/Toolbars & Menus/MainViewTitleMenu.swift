//
//  MainViewTitleMenu.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 03/01/2025.
//

import SwiftUI
import SwiftData

struct MainViewTitleMenu: View {
	@Environment(AppState.self) private var appState
	@Environment(SceneState.self) private var sceneState
	
	@Query private var playlists: [Playlist]
	
	var body: some View {
		ForEach(playlists) { playlist in
			Button(playlist.name) {
				sceneState.selectedPlaylist = playlist
			}
		}
		
		Divider()
		
		Button("Add Playlist", systemImage: "plus") {
			appState.isAddingPlaylist = true
		}
	}
}
