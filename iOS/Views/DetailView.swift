//
//  DetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 23/03/2024.
//

import SwiftUI
import M3UKit
import XMLTV

struct DetailView: View {
	
	@State var vm = ViewModel.shared
	
	var body: some View {
		if let playlist = vm.selectedPlaylist {
			MediaListView(medias: playlist.medias, playlistName: playlist.name, epgLink: playlist.epgLink)
		} else {
			ContentUnavailableView {
				Label("No Medias", systemImage: "list.and.film")
			} description: {
				Text("The selected playlist's medias will appear here.")
			}
		}
	}
}
