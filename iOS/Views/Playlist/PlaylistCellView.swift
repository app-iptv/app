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
	
	init(_ playlist: ModelPlaylist) { self.playlist = playlist }
	
	@Environment(\.modelContext) var context
	
	@State private var isEditing: Bool = false
	
	var body: some View {
		NavigationLink(playlist.name, value: playlist)
			.contextMenu { deleteButton; editButton }
			.swipeActions(edge: .trailing) { deleteButton }
			.swipeActions(edge: .leading) { editButton }
			.popover(isPresented: $isEditing) { EditPlaylistView(playlist) }
	}
}

extension PlaylistCellView {
	private var deleteButton: some View {
		Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
	}
	
	private var editButton: some View {
		Button("Edit Playlist", systemImage: "pencil") { isEditing.toggle() }
			.tint(.accentColor)
	}
}
