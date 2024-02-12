//
//  PlaylistsList.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import SwiftData
import M3UKit

struct PlaylistsList: View {

	@Query var savedPlaylists: [SavedPlaylist]
	
	@Binding var selectedPlaylist: SavedPlaylist?

	@Binding var isPresented: Bool
	
	@Binding var selectedMedia: Playlist.Media?
	@Binding var selectedGroup: String
	@Binding var outerGroups: [String]
	@Binding var selectedSortingOption: SortingOption
	
	var body: some View {
		#if !os(macOS)
		List(savedPlaylists) { playlist in
			NavigationLink(value: playlist) {
				PlaylistRow(playlist: playlist)
			}
		}
		.toolbar {
			ToolbarItem {
				Button("Add Playlist", systemImage: "plus") { isPresented.toggle() }
			}
		}
		#else
		List(savedPlaylists, selection: $selectedPlaylist) { playlist in
			PlaylistRow(playlist: playlist).tag(playlist)
		}
		.toolbar {
			ToolbarItem {
				Button("Add Playlist", systemImage: "plus") { isPresented.toggle() }
			}
		}
		#endif
    }
}
