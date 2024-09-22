//
//  TVView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftData
import SwiftUI

struct TVView: View {
	@State private var vm = ViewModel.shared
	@FocusState private var isFocused: Bool

	@AppStorage("RECENTLY_WATCHED_CHANNELS") private var recents: [Media] = []
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0

	@Query private var modelPlaylists: [Playlist]

	var body: some View {
		ScrollView(.vertical) {
			LazyVStack(alignment: .leading, spacing: 26) {
				InfinitePagingScrollView(items: recents) { media in
					TVMediaItemView(media: media, isTV: true)
				}
				.safeAreaPadding(40)
				.frame(width: 1760, height: 452)

				ForEach(groups, id: \.self) { group in
					Section(LocalizedStringKey(group)) {
						MediaGroupView(medias: medias, group: group, isTV: true)
					}
				}
			}
			.scrollTargetLayout()
		}
		.scrollClipDisabled()
		.scrollTargetBehavior(.viewAligned)
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

extension TVView {
	private var medias: [Media]? {
		modelPlaylists.safelyAccessElement(at: selectedPlaylist)?.medias
	}

	private var groups: [String] {
		var seen = Set<String>()
		let groups =
			medias?.compactMap { $0.attributes["group-title"] ?? "Undefined" }
			?? []
		let uniqueGroups = groups.filter { seen.insert($0).inserted }

		return uniqueGroups
	}
}
