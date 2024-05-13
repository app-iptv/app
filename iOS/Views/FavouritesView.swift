//
//  FavouritesView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 19/03/2024.
//

import SwiftUI
import M3UKit

struct FavouritesView: View {
	
	@AppStorage("FAVORITED_CHANNELS") var favourites: [Media] = []
	
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
						NavigationLink(value: media) {
							MediaCellView(media: media, playlistName: "Favortites")
						}.badge(favourites.firstIndex(of: media)!+1)
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.navigationTitle("Favourites")
			.toolbarBackground(.visible, for: .navigationBar)
			.searchable(text: $searchQuery, prompt: "Search Favourites")
			.navigationDestination(for: Media.self) { MediaDetailView(playlistName: "Favourites", media: $0, epgLink: "", xmlTV: .constant(nil)) }
			.toolbarRole(.browser)
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
		}
	}
}

extension FavouritesView {
	private var placement: ToolbarItemPlacement {
		#if targetEnvironment(macCatalyst)
		return .primaryAction
		#else
		return .topBarTrailing
		#endif
	}
	
	private var searchResults: [Media] {
		guard !searchQuery.isEmpty else { return favourites }
		return favourites.filter { media in
			media.title.localizedStandardContains(searchQuery)
		}
	}
	
	private var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes["group-title"] })
		allGroups.insert("All")
		return allGroups.sorted()
	}
	
	private var filteredMediasForGroup: [Media] {
		guard selectedGroup == "All" else { return searchResults.filter { $0.attributes["group-title"] == selectedGroup } }
		return searchResults
	}
}
