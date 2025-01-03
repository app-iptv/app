//
//  FavouritesView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 19/03/2024.
//

import M3UKit
import SwiftUI
import SwiftData

struct FavouritesView: View {
	@Environment(EPGFetchingController.self) private var epgFetchingController
	@Environment(AppState.self) private var appState
	
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []

	@Query private var playlists: [Playlist]
	
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
							MediaCellView(media: media)
						}
						.badge(favourites.firstIndex(of: media)! + 1)
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.searchable(text: $searchQuery, prompt: "Search Favourites")
			.navigationDestination(for: Media.self) { MediaDetailView(media: $0) }
			.navigationTitle("Favourites")
			.toolbar(id: "favouritesToolbar") {
				if !groups.isEmpty {
					ToolbarItem(id: "groupPicker", placement: placement) {
						Picker("Select Group", selection: $selectedGroup) {
							ForEach(groups, id: \.self) { group in
								Label("All", systemImage: "tray.2")
									.labelStyle(.titleAndIcon)
									.tag("All")
								
								Divider()
								
								ForEach(groups, id: \.self) { group in
									Label(group, systemImage: "tray")
										.labelStyle(.titleAndIcon)
										.tag(group)
								}
							}
						}
						.pickerStyle(.menu)
					}
				}
				
				if !playlists.isEmpty {
					ToolbarItem(id: "epgPicker", placement: placement) {
						Menu("Select EPG") {
							ForEach(playlists) { playlist in
								AsyncButton {
									await epgFetchingController.load(epg: playlist.epgLink, appState: appState)
								} label: { _ in
									Text("From \(playlist.name)")
								}
							}
						}
						.task {
							await epgFetchingController.load(epg: playlists.first?.epgLink, appState: appState)
						}
					}
				}
			}
		}
	}
}

extension FavouritesView {
	private var placement: ToolbarItemPlacement {
		#if os(macOS)
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
		let allGroups = Set(
			searchResults.compactMap { $0.attributes["group-title"] })
		return allGroups.sorted()
	}

	private var filteredMediasForGroup: [Media] {
		guard selectedGroup == "All" else {
			return searchResults.filter {
				$0.attributes["group-title"] == selectedGroup
			}
		}
		return searchResults
	}
}
