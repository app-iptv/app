//
//  SidebarList.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 08/02/2024.
//

import Foundation
import SwiftUI
import M3UKit
import SwiftData

struct SidebarList: View {
	
	@Environment(\.modelContext) var context
	@Query var savedPlaylists: [SavedPlaylist]
	
	var searchResults: [SavedPlaylist]
	
	@State var mediaSearchText: String
	@State var selectedGroup: String
	@State var outerGroups: [String]
	@State var selectedSortingOption: SortingOption
	@State var selectedViewingOption: ViewingOption
	
	var body: some View {
		List(searchResults) { playlist in
			// MARK: PlaylistItem
			NavigationLink {
				List {
					var mediaSearchResults: [Playlist.Media] {
						if mediaSearchText == "" {
							return playlist.playlist?.medias ?? []
						} else {
							return playlist.playlist?.medias.filter { $0.name.contains(mediaSearchText) } ?? []
						}
					}
					
					var groups: [String] {
						var allGroups = Set(mediaSearchResults.compactMap { $0.attributes.groupTitle })
						allGroups.insert("All")
						return allGroups.sorted()
					}
					
					var sortedMedias: [Playlist.Media] {
						switch selectedSortingOption {
						case .country:
							return mediaSearchResults.sorted { $0.attributes.country ?? "Z" < $1.attributes.country ?? "Z" }
						case .alphabetical:
							return mediaSearchResults.sorted { $0.name < $1.name }
						case .language:
							return mediaSearchResults.sorted { $0.attributes.language ?? "Z" < $1.attributes.language ?? "Z" }
						case .kind:
							return mediaSearchResults.sorted { $0.attributes.groupTitle ?? "Z" < $1.attributes.groupTitle ?? "Z" }
						case .normal:
							return mediaSearchResults
						}
					}
					
					var filteredMedias: [Playlist.Media] {
						if selectedGroup == "All" {
							sortedMedias
						} else {
							sortedMedias.filter { $0.attributes.groupTitle == selectedGroup }
						}
					}
					
					// MARK: MediaItem
					ForEach(filteredMedias, id: \.self) { media in
						MediaRow(media: media)
							.buttonStyle(.plain)
							.contextMenu {
								ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? ""))
							}
							.swipeActions(edge: .leading) {
								ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? ""))
							}
					}
					.onDelete { playlist.playlist?.medias.remove(atOffsets: $0) }
					.onMove { playlist.playlist?.medias.move(fromOffsets: $0, toOffset: $1) }
					.onAppear { self.outerGroups = groups }
				}
				.listStyle(.plain)
				.searchable(text: $mediaSearchText, prompt: "Search Streams")
				.navigationTitle(playlist.name)
				.toolbarRole(.editor)
				.toolbar(id: "playlistToolbar") {
					ToolbarItem(id: "groupPicker") {
						Picker("Select Groups", selection: $selectedGroup) {
							ForEach(outerGroups, id: \.self) { group in
								if group == "All" {
									Label(group, systemImage: "tray.full").tag(group)
								} else {
									Text(group).tag(group)
								}
							}
						}.pickerStyle(.menu)
					}
					ToolbarItem(id: "viewingOptionsPicker") {
						
					}
					ToolbarItem(id: "sortingOptionsPicker") {
						Picker("Sort", selection: $selectedSortingOption) {
							ForEach(SortingOption.allCases) { option in
								option.label
									.tag(option)
							}
						}.pickerStyle(.segmented)
					}
#if !os(macOS)
					ToolbarItem(id: "editButton") { EditButton() }
#endif
				}
			} label: {
				Text(playlist.name)
			}
			.swipeActions(edge: .trailing) { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
			.contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
		}
		.listStyle(.sidebar)
	}
}
