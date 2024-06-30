//
//  FavouritesView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 19/03/2024.
//

import SwiftUI
import M3UKit

struct FavouritesView: View {
	
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []
	
	@State private var isDeletingAll: Bool = false
	
	@State private var searchQuery: String = ""
	
	@State private var selectedGroup: String = "All"
	
	var body: some View {
		NavigationStack {
			Group {
				if favourites.isEmpty {
					ContentUnavailableView {
						Label("No Favourited Medias", systemImage: "star.slash")
					} description: {
						Text("The medias you favourites will appear here. To add some favourites, click on the star symbol next to a media.")
					}
				} else if filteredMediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredMediasForGroup) { media in
						#if !os(tvOS)
						NavigationLink(value: media) {
							MediaCellView(media: media)
						}
						.badge(favourites.firstIndex(of: media)!+1)
						#else
						MediaItemView(media: media, playlistName: "Favourites")
						#endif
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			#if os(iOS)
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbarRole(.browser)
			#endif
			.searchable(text: $searchQuery, prompt: "Search Favourites")
			#if !os(tvOS)
			.navigationDestination(for: Media.self) { MediaDetailView(playlistName: "Favourites", media: $0, epgLink: "") }
			.navigationTitle("Favourites")
			.toolbar(id: "favouritesToolbar") {
				ToolbarItem(id: "groupPicker", placement: placement) {
					Picker("Select Group", selection: $selectedGroup) {
						ForEach(groups, id: \.self) { group in
							Label(LocalizedStringKey(group), systemImage: group == "All" ? "tray.2" : "tray").tag(group)
						}
					}
					.pickerStyle(.menu)
				}
			}
			#endif
		}
	}
}

private extension FavouritesView {
	var placement: ToolbarItemPlacement {
		#if os(macOS)
		return .primaryAction
		#else
		return .topBarTrailing
		#endif
	}
	
	var searchResults: [Media] {
		guard !searchQuery.isEmpty else { return favourites }
		return favourites.filter { media in
			media.title.localizedStandardContains(searchQuery)
		}
	}
	
	var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes["group-title"] })
		allGroups.insert("All")
		return allGroups.sorted()
	}
	
	var filteredMediasForGroup: [Media] {
		guard selectedGroup == "All" else { return searchResults.filter { $0.attributes["group-title"] == selectedGroup } }
		return searchResults
	}
}
