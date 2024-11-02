//
//  DetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 23/03/2024.
//

import M3UKit
import SwiftData
import SwiftUI
import XMLTV

struct DetailView: View {

	@Query var modelPlaylists: [Playlist]

	@Environment(ViewModel.self) private var vm

	var body: some View {
		if let playlist = vm.selectedPlaylist {
			MediaListView(
				medias: playlist.medias, playlistName: playlist.name,
				epgLink: playlist.epgLink,
				index: modelPlaylists.firstIndex(of: playlist)!)
		} else {
			ContentUnavailableView {
				Label("No Medias", systemImage: "list.and.film")
			} description: {
				Text("The selected playlist's medias will appear here.")
			}
		}
	}
}
