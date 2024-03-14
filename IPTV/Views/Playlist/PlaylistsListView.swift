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

	@Query var modelPlaylists: [ModelPlaylist]
	
	@Binding var selection: ModelPlaylist?
	@State var isEditing: Bool = false
	
	@ObservedObject var vm = ViewModel()
	@Binding var isPresented: Bool
	
	@Binding var openedSingleStream: Bool
	
	var body: some View {
		List(modelPlaylists, selection: $selection) { playlist in
			NavigationLink(playlist.name, value: playlist)
				.contextMenu { contextMenu(playlist) }
				.swipeActions(edge: .trailing) { contextMenu(playlist) }
		}
		.listStyle(.sidebar)
		#if !targetEnvironment(macCatalyst)
		.toolbar(id: "playlistsToolbar") {
			ToolbarItem(id: "addPlaylist", placement: .topBarTrailing) { Button("Add Playlist", systemImage: "plus") { isPresented.toggle() } }
			ToolbarItem(id: "openSingleStream", placement: .topBarLeading) { Button("Open Stream", systemImage: "play") { openedSingleStream.toggle() } }
		}
		#endif
	}
	
	private func contextMenu(_ playlist: ModelPlaylist) -> some View {
		Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
	}
}
