//
//  DetailView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 23/03/2024.
//

import M3UKit
import SwiftData
import SwiftUI
import XMLTV

struct DetailView: View {
	@Environment(AppState.self) private var appState
	@Environment(SceneState.self) private var sceneState
	
	@Query var playlists: [Playlist]

	var body: some View {
		Group {
			if let playlist = sceneState.selectedPlaylist {
				MediasView(playlist)
			} else {
				ContentUnavailableView {
					Label("No Medias", systemImage: "list.and.film")
				} description: {
					Text("The selected playlist's medias will appear here.")
				}
			}
		}
		#if os(iOS)
		.toolbarBackground(.visible, for: .navigationBar)
		#endif
	}
}
