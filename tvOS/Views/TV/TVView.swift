//
//  TVView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI
import SwiftData

struct TVView: View {
	@State private var vm = ViewModel.shared
	@FocusState private var isFocused: Bool
	
	@AppStorage("RECENTLY_WATCHED_CHANNELS") private var recents: [Media] = []
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
	
	@Query private var modelPlaylists: [Playlist]
	
	var body: some View {
		VStack {
			ScrollView {
				InfinitePagingScrollView(items: recents) { media in
					TVMediaItemView(media: media, isTV: true, size: .large)
				}
				.safeAreaPadding(40)
				.frame(width: 1760, height: 452)
				
				if let medias, !medias.isEmpty {
					Grid {
						ForEach(groups, id: \.self) { group in
							MediaGroupView(medias: medias, group: group, isTV: true)
						}
					}
				}
			}
		}
		.onAppear {
			if recents.isEmpty {
				if let first = vm.selectedPlaylist?.medias.first {
					recents.append(first)
				}
				if let second = vm.selectedPlaylist?.medias[1] {
					recents.append(second)
				}
				if let third = vm.selectedPlaylist?.medias[2] {
					recents.append(third)
				}
			}
		}
	}
}

private extension TVView {
	var medias: [Media]? { modelPlaylists.safelyAccessElement(at: selectedPlaylist)?.medias }
	
	var groups: [String] {
		var seen = Set<String>()
		let groups = medias?.compactMap { $0.attributes["group-title"] ?? "Undefined" } ?? []
		let uniqueGroups = groups.filter { seen.insert($0).inserted }
		
		return uniqueGroups
	}
}
