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
		#if !os(macOS)
		List(savedPlaylists) { playlist in
			NavigationLink(value: playlist) {
				PlaylistRowView(isEditing: $isEditing, playlist: playlist)
			}
			// .sheet(isPresented: $isEditing) { EditPlaylistView(playlist: playlist, isEditing: $isEditing) }
		}
		.listStyle(.inset)
		.navigationTitle("Playlists")
		.navigationDestination(for: SavedPlaylist.self) { playlist in
			MediaListView(media: playlist.playlist?.medias ?? [])
				.navigationTitle(playlist.name)
				.toolbarRole(.browser)
				.navigationDestination(for: Playlist.Media.self) { media in
					MediaDetailView(playlistName: playlist.name, selectedMedia: media)
				}
		}
		.toolbar(id: "playlistsToolbar") {
			ToolbarItem(id: "addPlaylist", placement: .topBarTrailing) {
				Button("Add Playlist", systemImage: "plus") { isPresented.toggle() }
			}
			ToolbarItem(id: "openSingleStream", placement: .topBarLeading) {
				Button("Open Stream", systemImage: "tv") { openedSingleStream.toggle() }
			}
		}
		.sheet(isPresented: $openedSingleStream) {
			SingleStreamView()
		}
		#else
		List(savedPlaylists, selection: $selection) { playlist in
			PlaylistRowView(isEditing: $isEditing, playlist: playlist)
				.tag(playlist)
				// .sheet(isPresented: $isEditing) { EditPlaylistView(playlist: playlist, isEditing: $isEditing) }
		}
		.listStyle(.sidebar)
		.navigationSplitViewColumnWidth(min: 250, ideal: 250)
		.navigationTitle("Playlists")
		.toolbar(id: "playlistsToolbar") {
			ToolbarItem(id: "addPlaylist") {
				Button("Add Playlist", systemImage: "plus") { isPresented.toggle() }
			}
			ToolbarItem(id: "openSingleStream") {
				Button("Open Stream", systemImage: "tv") { openedSingleStream.toggle() }
			}
		}
		#endif
    }
}
