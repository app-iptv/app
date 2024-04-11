//
//  FavoritesView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 19/03/2024.
//

import SwiftUI
import M3UKit

struct FavoritesView: View {
	
	@AppStorage("FAVORITED_CHANNELS") var favorites: [media] = []
	
	@State private var isDeletingAll: Bool = false
	
	@State private var searchQuery: String = ""
	
	@State private var selectedGroup: String = "All"
	
	var body: some View {
		NavigationStack {
			Group {
				if favorites.isEmpty {
					ContentUnavailableView {
						Label("No Favorited medias", systemImage: "star.slash")
					} description: {
						Text("The medias you favorite will appear here. To add some favorites, click on the star symbol next to a media.")
					}
				} else if filteredmediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredmediasForGroup) { media in
						NavigationLink(value: media) {
							mediaCellView(media: media, playlistName: "Favorites")
						}.badge(favorites.firstIndex(of: media)!+1)
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.navigationTitle("Favorites")
			.searchable(text: $searchQuery, prompt: "Search Favorites")
			.navigationDestination(for: media.self) { media in
				mediaDetailView(playlistName: "Favorites", media: media)
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
	
	private var searchResults: [media] {
		guard !searchQuery.isEmpty else { return favorites }
		return favorites.filter { media in
			media.title.localizedStandardContains(searchQuery) ||
			(media.attributes["group-title"] ?? "Undefined").localizedCaseInsensitiveContains(searchQuery)
		}
	}
	
	private var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes["group-title"] })
		allGroups.insert("All")
		return allGroups.sorted()
	}
	
	private var filteredmediasForGroup: [media] {
		guard selectedGroup == "All" else { return searchResults.filter { $0.attributes["group-title"] == selectedGroup } }
		return searchResults
	}
}
