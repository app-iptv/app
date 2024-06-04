//
//  MoviesAndTVShowsView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 18/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftData

struct MoviesAndTVShowsView: View {
	@State private var vm = ViewModel.shared
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
	@Query private var modelPlaylists: [Playlist]
	
	var body: some View {
		VStack {
			if (filteredMovies?.isEmpty ?? true) {
				ContentUnavailableView("No Movies", systemImage: "film.stack", description: Text("Either your playlist doesn't include movies, or you haven't yet added a playlist. You can do so in Settings."))
					.padding()
			} else {
				ScrollView {
					Grid {
						ForEach(groups, id: \.self) { group in
							MediaGroupView(medias: filteredMovies, group: group, isTV: false)
						}
					}
				}
			}
		}
	}
}

extension MoviesAndTVShowsView {
	private var filteredMovies: [Media]? { modelPlaylists.safelyAccessElement(at: selectedPlaylist)?.medias.filter { $0.attributes["media"] == "true" } }
	
	private var groups: [String] {
		var seen = Set<String>()
		let groups = filteredMovies?.compactMap { $0.attributes["group-title"] ?? "Undefined" } ?? []
		let uniqueGroups = groups.filter { seen.insert($0).inserted }
		
		return uniqueGroups
	}
}
