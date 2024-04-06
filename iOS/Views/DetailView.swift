//
//  DetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 23/03/2024.
//

import SwiftUI
import M3UKit

struct DetailView: View {
	
	@Bindable var vm: ViewModel
	
	init(_ vm: ViewModel) { self.vm = vm }
	
	var body: some View {
		if let playlist = vm.selectedPlaylist {
			MediaListView(vm: vm, medias: playlist.medias, playlistName: playlist.name)
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
