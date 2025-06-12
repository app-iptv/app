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
	
	func searchResults(_ medias: [Media]) -> [Media] {
		guard !searchQuery.isEmpty else { return medias }
		
		return medias.filter { $0.title.localizedStandardContains(searchQuery) }
	}

	func groups(for medias: [Media]) -> [String] {
		let searchResults = self.searchResults(medias)
		
		let allGroups = Set(
			searchResults.compactMap {
				$0.attributes["group-title"] ?? "Undefined"
			}
		)
		
		return allGroups.sorted()
	}

	func filteredMediasForGroup(_ group: String, medias: [Media]) -> [Media] {
		let searchResults = self.searchResults(medias)
		
		guard group == "All" else {
			return searchResults.filter {
				($0.attributes["group-title"] ?? "Undefined") == group
			}
		}
		return searchResults
	}
}
