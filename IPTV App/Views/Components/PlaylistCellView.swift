//
//  PlaylistCellView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 17/03/2024.
//

import Foundation
import M3UKit
import SwiftUI

struct PlaylistCellView: View {
	@Environment(\.modelContext) var context
	@Environment(AppState.self) var appState

	@Bindable var playlist: Playlist

	@State var isEditing: Bool = false

	init(_ playlist: Playlist) { self.playlist = playlist }

	var body: some View {
		NavigationLink(value: playlist) {
			Text(playlist.name)
				#if os(macOS)
					.badge(playlist.medias.count)
				#endif
		}
		.contextMenu {
			deleteButton
			editButton
		}
		.swipeActions(edge: .trailing) { deleteButton }
		.swipeActions(edge: .leading) { editButton }
		.popover(isPresented: $isEditing) { EditPlaylistView(playlist) }
	}
}

extension PlaylistCellView {
	var deleteButton: some View {
		Button("Delete", systemImage: "trash", role: .destructive) {
			context.delete(playlist)
		}
	}

	var editButton: some View {
		Button("Edit Playlist", systemImage: "pencil") { isEditing.toggle() }
			.tint(.accentColor)
	}
}
