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
	
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(\.isSearching) private var searchState
	@Environment(ViewModel.self) private var vm
	
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
	
	@State private var searchQuery: String = ""
	@State private var groupsTip = GroupsTip()
	
	private let medias: [Media]
	private let playlistName: String
	private let epgLink: String
	private let index: Int
	
	internal init(medias: [Media], playlistName: String, epgLink: String, index: Int) {
		self.medias = medias
		self.playlistName = playlistName
		self.epgLink = epgLink
		self.index = index
	}
	
	var body: some View {
		@Bindable var vm = vm
		
		NavigationStack {
			Group {
				if filteredMediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredMediasForGroup) { media in
						#if os(tvOS)
						MediaItemView(media: media, playlistName: playlistName)
						#else
						MediaItemView(media: media, playlistName: playlistName, epgLink: epgLink, medias: medias)
							
						#endif
					}
					.listStyle(.plain)
					.id(UUID())
				}
			}
			.searchable(text: $searchQuery, prompt: "Search")
			.onAppear {				
				selectedPlaylist = index
				
				#if DEBUG
				print("New Selected Playlist: \(index)")
				#endif
			}
			#if !os(tvOS)
			.navigationTitle(playlistName)
			#if os(iOS)
			.toolbarRole(sizeClass!.toolbarRole)
			#endif
			.toolbar(id: "mediasToolbar") {
				ToolbarItem(id: "groupPicker", placement: placement) {
					Picker("Select Group", selection: $vm.selectedGroup) {
						ForEach(groups, id: \.self) { group in
							Label(LocalizedStringKey(group), systemImage: group == "All" ? "tray.2" : "tray")
								.tag(group)
						}
						.onAppear { groupsTip.invalidate(reason: .actionPerformed) }
					}
					.pickerStyle(.menu)
					.popoverTip(groupsTip)
				}
			}
			#endif
		}
	}
}

extension MediaListView {
	private var placement: ToolbarItemPlacement {
		#if os(macOS)
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
}
