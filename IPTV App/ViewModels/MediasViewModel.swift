//
//  MediasViewModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 17/11/2024.
//

import Foundation

@Observable
final class MediasViewModel {
	var favouritesTip: FavouritesTip = .init()

	func groups(for medias: [Media]) -> [String] {
		let allGroups = Set(
			medias.compactMap {
				$0.attributes["group-title"] ?? "Undefined"
			}
		)
		
		return allGroups.sorted()
	}

	func filteredMediasForGroup(_ group: String, medias: [Media]) -> [Media] {
		guard group == "All" else {
			return medias.filter {
				($0.attributes["group-title"] ?? "Undefined") == group
			}
		}
		return medias
	}
}
