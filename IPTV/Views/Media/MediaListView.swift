//
//  MediaListView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit
import Foundation

struct MediaListView: View {
	
	@Bindable var vm: ViewModel
	@Binding var favorites: [Playlist.Media]
	
	let playlist: ModelPlaylist
	
	@Environment(\.horizontalSizeClass) var sizeClass
	@Environment(\.isSearching) var searchState
	
	@State private var searchQuery: String = ""
	
	@State private var searchResults: [Playlist.Media] = []
	
	private var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes.groupTitle })
		allGroups.insert(String(localized: "All"))
		return allGroups.sorted()
	}
	
	var body: some View {
		NavigationStack {
			Group {
				if filteredMediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredMediasForGroup) { media in
						NavigationLink(value: media) {
							MediaCellView(media: media, playlistName: playlist.name, favorites: $favorites)
						}
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.searchable(text: $searchQuery, prompt: "Search")
			.onAppear { updateSearchResultsAsync() }
			.onChange(of: searchQuery) { updateSearchResultsAsync() }
			.toolbar(id: "mediasToolbar") {
				ToolbarItem(id: "groupPicker", placement: .primaryAction) {
					Picker("Select Group", selection: $vm.selectedGroup) {
						ForEach(groups, id: \.self) { group in
							Label(group, systemImage: group == String(localized: "All") ? "tray.2" : "tray").tag(group)
						}
					}
					.pickerStyle(.menu)
				}
			}
			.toolbarRole(.browser)
			.navigationDestination(for: Playlist.Media.self) { media in
				MediaDetailView(playlistName: playlist.name, media: media)
			}
		}
	}
	
	private var filteredMediasForGroup: [Playlist.Media] {
		guard vm.selectedGroup == "All" else { return searchResults.filter { $0.attributes.groupTitle == vm.selectedGroup } }
		return searchResults
	}
	
	private func updateSearchResults() {
		guard !searchQuery.isEmpty else { searchResults = playlist.medias; return }
		searchResults = playlist.medias.filter { $0.name.localizedStandardContains(searchQuery) }
	}
	
	private func updateSearchResultsAsync() {
		DispatchQueue.global(qos: .utility).async {
			updateSearchResults()
		}
	}
}
