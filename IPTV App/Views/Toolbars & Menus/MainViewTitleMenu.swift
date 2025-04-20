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
	
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []
	
	@Query private var playlists: [Playlist]
	
	var body: some View {
		ForEach(playlists) { playlist in
			Button(playlist.name) {
				sceneState.selectedPlaylist = playlist
			}
			.badge(playlist.medias.count)
		}
		
		Divider()
		
		Button("Favourites", systemImage: "star") {
			sceneState.selectedPlaylist = Playlist(String(localized: "Favourites"), medias: favourites)
		}
		
		Divider()
		
		Button("Add Playlist", systemImage: "plus") {
			appState.isAddingPlaylist = true
		}
	}
}
