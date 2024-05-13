//
//  mediaListView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit
import Foundation
import XMLTV

struct MediaListView: View {
	
	@Environment(\.horizontalSizeClass) var sizeClass
	@Environment(\.isSearching) var searchState
	
	@State var vm = ViewModel.shared
	
	let medias: [Media]
	let playlistName: String
	let epgLink: String
	
	@State private var searchQuery: String = ""
	
	@State var xmlTV: XMLTV? = nil
	
	var body: some View {
		NavigationStack {
			Group {
				if filteredMediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredMediasForGroup) { media in
						MediaItemView(media: media, playlistName: playlistName, epgLink: epgLink, medias: medias, xmlTV: $xmlTV)
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.navigationTitle(playlistName)
			.searchable(text: $searchQuery, prompt: "Search")
			.toolbarRole(sizeClass!.toolbarRole)
			.task { if xmlTV == nil { await fetchData() } }
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
			media.title.localizedStandardContains(searchQuery)
		}
	}
	
	private var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes["group-title"] ?? "Undefined" })
		allGroups.insert("All")
		return allGroups.sorted()
	}
	
	private var filteredMediasForGroup: [Media] {
		guard vm.selectedGroup == "All" else { return searchResults.filter { ($0.attributes["group-title"] ?? "Undefined") == vm.selectedGroup } }
		return searchResults
	}
	
	private func fetchData() async {
		do {
			xmlTV = try await EPGFetchingModel.shared.getPrograms(with: epgLink)
			vm.isLoadingEPG = false
		} catch {
			vm.epgModelDidFail = true
			vm.isLoadingEPG = false
		}
	}
}
