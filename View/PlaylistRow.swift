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
	
	@Binding var mediaSearchText: String
	@Binding var selectedGroup: String
	@Binding var outerGroups: [String]
	@Binding var selectedSortingOption: SortingOption
	
	var body: some View {
		NavigationLink(value: playlist) {
			Text(playlist.name)
		}
		.swipeActions(edge: .trailing) { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
		.contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
	}
}
