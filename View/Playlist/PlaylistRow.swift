//
//  PlaylistRow.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 10/02/2024.
//

import SwiftUI
import M3UKit

struct PlaylistRow: View {
	
	@Environment(\.modelContext) var context
	
	let playlist: SavedPlaylist
	
	var body: some View {
		Text(playlist.name)
		#if !os(tvOS)
		.swipeActions(edge: .trailing) { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
		#endif
		.contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
	}
}
