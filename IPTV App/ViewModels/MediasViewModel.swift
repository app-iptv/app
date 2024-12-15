//
//  MediasViewModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 17/11/2024.
//

import Foundation

@Observable
final class MediasViewModel {
	var searchQuery: String = ""
	var favouritesTip: FavouritesTip = .init()
	
	func searchResults(_ playlist: Playlist) -> [Media] {
		guard !searchQuery.isEmpty else { return playlist.medias }
		let results = playlist.medias.filter { media in
			media.title.localizedStandardContains(searchQuery)
		}

		return results
	}

	func groups(for playlist: Playlist) -> [String] {
		let searchResults = self.searchResults(playlist)
		
		let allGroups = Set(
			searchResults.compactMap {
				$0.attributes["group-title"] ?? "Undefined"
			}
		)
		
		return allGroups.sorted()
	}

	func filteredMediasForGroup(_ group: String, playlist: Playlist) -> [Media] {
		let searchResults = self.searchResults(playlist)
		
		guard group == "All" else {
			return searchResults.filter {
				($0.attributes["group-title"] ?? "Undefined") == group
			}
		}
		return searchResults
	}
}
