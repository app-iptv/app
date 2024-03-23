//
//  PlaylistsListView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import SwiftData
import M3UKit

struct PlaylistsListView: View {
	
	@Environment(\.horizontalSizeClass) var sizeClass
	@Environment(\.modelContext) var context
	
	@Bindable var vm: ViewModel
	
	init(_ vm: ViewModel) {
		self.vm = vm
	}
	
	@Query var modelPlaylists: [ModelPlaylist]
	
	var body: some View {
		List(modelPlaylists, selection: $vm.selectedPlaylist) { playlist in
			PlaylistCellView(playlist)
				.badge(playlist.medias.count)
		}
		.id(UUID())
		.listStyle(.sidebar)
	}
}
