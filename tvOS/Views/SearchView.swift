//
//  SearchView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 20/05/2024.
//

import SwiftData
import SwiftUI

struct SearchView: View {
	@Query private var modelPlaylists: [Playlist]

	@State private var searchQuery: String = ""

	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0

	var body: some View {
		List(filteredMedias) { media in
			MediaItemView(
				media: media,
				playlistName: modelPlaylists.safelyAccessElement(
					at: selectedPlaylist)?.name ?? "Untitled")
		}
		.searchable(text: $searchQuery, prompt: "Search")
	}
}

extension SearchView {
	private var filteredMedias: [Media] {
		guard !searchQuery.isEmpty else { return allMedias }
		return allMedias.filter {
			$0.title.localizedCaseInsensitiveContains(searchQuery)
		}
	}

	private var allMedias: [Media] {
		return modelPlaylists.flatMap { $0.medias }
	}
}
