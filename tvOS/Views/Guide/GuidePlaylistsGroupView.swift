//
//  GuidePlaylistsGroupView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI

struct GuidePlaylistsGroupView: View {
	private var playlist: Playlist

	internal init(playlist: Playlist) {
		self.playlist = playlist
	}

	var body: some View {
		Section(playlist.name) {
			ForEach(groups, id: \.self) { group in
				NavigationLink {
					GuideGroupDetailView(medias: mediasInGroup(for: group))
				} label: {
					HStack {
						Text(group)
						Spacer()
						Text(String(mediasInGroup(for: group).count))
							.foregroundStyle(.secondary)
					}
				}
				.tag(group)
			}
		}
	}
}

extension GuidePlaylistsGroupView {
	private var medias: [Media] { playlist.medias }

	private var groups: [String] {
		var seen = Set<String>()
		let groups = medias.compactMap {
			$0.attributes["group-title"] ?? "Undefined"
		}
		let uniqueGroups = groups.filter { seen.insert($0).inserted }

		return uniqueGroups
	}

	private func mediasInGroup(for group: String) -> [Media] {
		playlist.medias.filter {
			($0.attributes["group-title"] ?? "Untitled") == group
		}
	}
}
