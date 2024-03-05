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

	@Query var savedPlaylists: [SavedPlaylist]
	
	@Binding var selection: SavedPlaylist?
	@State var isEditing: Bool = false
	
	@ObservedObject var vm = ViewModel()
	@Binding var isPresented: Bool
	
	@Binding var openedSingleStream: Bool
	
	var body: some View {
		List(savedPlaylists, selection: $selection) { playlist in
			Section("Playlists") {
				NavigationLink(value: playlist) {
					PlaylistCellView(isEditing: $isEditing, playlist: playlist)
				}
				.swipeActions(edge: .leading) { Button("Edit", systemImage: "pencil") { isEditing.toggle() } }
				.sheet(isPresented: $isEditing) { EditPlaylistView(playlist: playlist, isEditing: $isEditing) }
			}
		}
		.listStyle(.sidebar)
		.navigationSplitViewColumnWidth(min: 216, ideal: 216)
		.navigationTitle("Playlists")
		.toolbar(id: "playlistsToolbar") {
			ToolbarItem(id: "addPlaylist") { Button("Add Playlist", systemImage: "plus") { isPresented.toggle() } }
			ToolbarItem(id: "openSingleStream") { Button("Open Stream", systemImage: "play.fill") { openedSingleStream.toggle() } }
		}
		.sheet(isPresented: $openedSingleStream) { SingleStreamView() }
    }
}
