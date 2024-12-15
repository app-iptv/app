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
	
	@Query var playlists: [Playlist]

	var body: some View {
		if let playlist = appState.selectedPlaylist {
			MediasView(playlist)
		} else {
			ContentUnavailableView {
				Label("No Medias", systemImage: "list.and.film")
			} description: {
				Text("The selected playlist's medias will appear here.")
			}
		}
	}
}
