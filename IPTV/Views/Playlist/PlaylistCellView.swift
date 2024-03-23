//
//  PlaylistListItem.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 17/03/2024.
//

import Foundation
import SwiftUI
import M3UKit

struct PlaylistCellView: View {
	
	@Bindable var playlist: ModelPlaylist
	
	init(_ playlist: ModelPlaylist) {
		self.playlist = playlist
	}
	
	@Environment(\.modelContext) var context
	
	@State private var isEditing: Bool = false
	
	var body: some View {
		NavigationLink(playlist.name, value: playlist)
			.contextMenu { contextMenu(playlist) }
			.swipeActions(edge: .trailing) { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
			.swipeActions(edge: .leading) { Button("Edit Playlist", systemImage: "pencil") { isEditing.toggle() }.foregroundStyle(.foreground) }
			.popover(isPresented: $isEditing) { EditPlaylistView(playlist) }
	}
	
	private func contextMenu(_ playlist: ModelPlaylist) -> some View {
		VStack {
			Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
			Button("Edit Playlist", systemImage: "pencil") { isEditing.toggle() }.foregroundStyle(.foreground)
		}
	}
}
