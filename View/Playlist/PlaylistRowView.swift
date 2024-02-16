//
//  PlaylistRow.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 10/02/2024.
//

import SwiftUI
import M3UKit

struct PlaylistRowView: View {
	
	@Environment(\.modelContext) var context
	
	@Binding var isEditing: Bool
	
	let playlist: SavedPlaylist
	
	var body: some View {
		Text(playlist.name)
			#if !os(tvOS)
			.swipeActions(edge: .trailing) {
				Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
			}
			// .swipeActions(edge: .leading) { Button("Edit", systemImage: "pencil") { isEditing.toggle() } }
			.contextMenu {
				Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
				// Button("Edit", systemImage: "pencil") { isEditing.toggle() }
			}
			#endif
	}
}
