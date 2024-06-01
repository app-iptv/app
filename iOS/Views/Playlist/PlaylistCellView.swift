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
	
	@Environment(\.modelContext) private var context
	
	@Bindable private var playlist: Playlist
	
	init(_ playlist: Playlist) { self.playlist = playlist }
	
	@State private var isEditing: Bool = false
	
	var body: some View {
		NavigationLink(playlist.name, value: playlist)
			.contextMenu { deleteButton; editButton }
		#if !os(tvOS)
			.swipeActions(edge: .trailing) { deleteButton }
			.swipeActions(edge: .leading) { editButton }
			.popover(isPresented: $isEditing) { EditPlaylistView(playlist) }
		#endif
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
