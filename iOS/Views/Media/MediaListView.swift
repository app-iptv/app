//
//  mediaListView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit
import Foundation

struct MediaListView: View {
	
	@Environment(\.horizontalSizeClass) var sizeClass
	@Environment(\.isSearching) var searchState
	
	@Bindable var vm: ViewModel
	
	let medias: [Media]
	let playlistName: String
	
	@State private var searchQuery: String = ""
	
	var body: some View {
		NavigationStack {
			Group {
				if filteredmediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredmediasForGroup) { media in
						NavigationLink {
							MediaDetailView(playlistName: playlistName, media: media)
						} label: {
							MediaCellView(media: media, playlistName: playlistName)
						}.badge(medias.firstIndex(of: media)!+1)
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.searchable(text: $searchQuery, prompt: "Search")
			.toolbar(id: "mediasToolbar") {
				ToolbarItem(id: "groupPicker", placement: placement) {
					Picker("Select Group", selection: $vm.selectedGroup) {
						ForEach(groups, id: \.self) { group in
							Label(LocalizedStringKey(group), systemImage: group == "All" ? "tray.2" : "tray")
								.tag(group)
						}
					}
					.pickerStyle(.menu)
				}
			}
			.toolbarRole(sizeClass!.toolbarRole)
			.toolbarTitleDisplayMode(.inline)
		}
	}
}

extension MediaListView {
	private var placement: ToolbarItemPlacement {
		#if targetEnvironment(macCatalyst)
		return .primaryAction
		#else
		return .topBarTrailing
		#endif
	}
	
	private var searchResults: [Media] {
		guard !searchQuery.isEmpty else { return medias }
		return medias.filter { media in
			media.title.localizedStandardContains(searchQuery) ||
			(media.attributes["group-title"] ?? "Undefined").localizedCaseInsensitiveContains(searchQuery)
		}
	}
	
	private var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes["group-title"] ?? "Undefined" })
		allGroups.insert("All")
		return allGroups.sorted()
	}
	
	private var filteredmediasForGroup: [Media] {
		guard vm.selectedGroup == "All" else { return searchResults.filter { ($0.attributes["group-title"] ?? "Undefined") == vm.selectedGroup } }
		return searchResults
	}
}
