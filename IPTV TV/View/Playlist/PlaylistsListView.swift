//
//  PlaylistsListView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 12/03/2024.
//

import SwiftUI
import M3UKit
import SwiftData
import AVKit

struct PlaylistsListView: View {
	
	@Query var modelPlaylists: [ModelPlaylist]
	
	@Bindable var vm: ViewModel
	
	@State var openedSingleStream: Bool = false
	@Binding var isParsing: Bool
	
    var body: some View {
		NavigationStack {
			Group {
				if modelPlaylists.isEmpty {
					ContentUnavailableView {
						Label("No Playlists", systemImage: "list.and.film")
					} description: {
						Text("Playlists that you add will appear here.")
					} actions: {
						Button("Add Playlist", systemImage: "plus") { vm.isPresented.toggle() }
						Button("Open Single Stream", systemImage: "play") { openedSingleStream.toggle() }
					}
				} else {
					List(modelPlaylists) { playlist in
						NavigationLink(playlist.name, value: playlist)
					}
				}
			}
			.navigationDestination(for: ModelPlaylist.self) { playlist in
				MediasListView(medias: playlist.medias, playlistName: playlist.name)
			}
		}
    }
}
