//
//  FavoritesView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 19/03/2024.
//

import SwiftUI
import M3UKit

struct FavoritesView: View {
	
	@AppStorage("FAVORITED_MEDIAS") var favorites: [Media] = []
	
	@State private var isDeletingAll: Bool = false
	
	@State private var searchQuery: String = ""
	
	@State private var selectedGroup: String = "All"
	
	var body: some View {
		NavigationStack {
			Group {
				if favorites.isEmpty {
					ContentUnavailableView {
						Label("No Favorited Medias", systemImage: "star.slash")
					} description: {
						Text("The medias you favorite will appear here. To add some favorites, click on the star symbol next to a media.")
					}
				} else if filteredMediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredMediasForGroup) { media in
						NavigationLink(value: media) {
							MediaCellView(media: media, playlistName: "Favorites")
						}.badge(favorites.firstIndex(of: media)!+1)
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.navigationTitle("Favorites")
			.searchable(text: $searchQuery, prompt: "Search Favorites")
			.navigationDestination(for: Media.self) { media in
				MediaDetailView(playlistName: "Favorites", media: media)
			}
			.toolbarRole(.browser)
			.toolbar(id: "favoritesToolbar") {
				ToolbarItem(id: "groupPicker", placement: placement) {
					Picker("Select Group", selection: $selectedGroup) {
						ForEach(groups, id: \.self) { group in
							Label(LocalizedStringKey(group), systemImage: group == "All" ? "tray.2" : "tray").tag(group)
						}
					}
					.pickerStyle(.menu)
				}
			}
		}
	}
}

extension FavoritesView {
	private var placement: ToolbarItemPlacement {
		#if targetEnvironment(macCatalyst)
		return .primaryAction
		#else
		return .topBarTrailing
		#endif
	}
	
	private var searchResults: [Media] {
		guard !searchQuery.isEmpty else { return favorites }
		return favorites.filter { media in
			media.name.localizedCaseInsensitiveContains(searchQuery) ||
			(media.attributes.groupTitle ?? "").localizedStandardContains(searchQuery)
		}
	}
	
	private var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes.groupTitle })
		allGroups.insert("All")
		return allGroups.sorted()
	}
	
	private var filteredMediasForGroup: [Media] {
		guard selectedGroup == "All" else { return searchResults.filter { $0.attributes.groupTitle == selectedGroup } }
		return searchResults
	}
}
