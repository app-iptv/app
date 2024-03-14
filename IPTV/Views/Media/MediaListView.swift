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
	
	@ObservedObject var vm = ViewModel()
	
	@Environment(\.horizontalSizeClass) var sizeClass
	
	@State var isBeingOrganisedByGroups: Bool = false
	
	@State var mediaSearchText: String = ""
	
	var media: [Playlist.Media]
	
	@Binding var selectedMedia: Playlist.Media?
	
	var playlistName: String
	
	var searchResults: [Playlist.Media] {
		guard !mediaSearchText.isEmpty else { return media }
		return media.filter { $0.name.localizedCaseInsensitiveContains(mediaSearchText) }
	}
	
	var groups: [String] {
		var allGroups = Set(searchResults.compactMap { $0.attributes.groupTitle })
		allGroups.insert("All")
		return allGroups.sorted()
	}
	
	var body: some View {
		NavigationStack {
			list
				.toolbar(id: "mediasToolbar") {
					ToolbarItem(id: "groupPicker", placement: .primaryAction) {
						Picker("Select Group", selection: $vm.selectedGroup) {
							ForEach(groups, id: \.self) { group in
								Label(group, systemImage: group == "All" ? "tray.2" : "tray").tag(group)
							}
						}
						.pickerStyle(.menu)
					}
				}
				.toolbarRole(.browser)
				.searchable(text: $mediaSearchText, prompt: "Search Medias")
		}
	}
	
	var grid: some View {
		ScrollView {
			LazyVStack {
				Grid {
					ForEach(filteredMediasForGroup(vm.selectedGroup)) { media in
						NavigationLink {
							MediaDetailView(playlistName: playlistName, media: media)
						} label: {
							MediaCellView(media: media)
								.contextMenu { contextMenu(for: media) }
						}
					}
				}
			}
		}
	}
	
	var list: some View {
		List {
			Section(vm.selectedGroup) {
				ForEach(filteredMediasForGroup(vm.selectedGroup), id: \.self) { media in
					NavigationLink {
						MediaDetailView(playlistName: playlistName, media: media)
					} label: {
						MediaCellView(media: media)
							.swipeActions(edge: .leading) { ShareLink(item: media.url, preview: SharePreview(media.name)) }
							.contextMenu { contextMenu(for: media) }
					}
				}
			}
		}
		.id(UUID())
		.listStyle(.plain)
	}
	
	private func filteredMediasForGroup(_ group: String) -> [Playlist.Media] {
		guard group == "All" else { return searchResults.filter { $0.attributes.groupTitle == group } }
		return searchResults
	}
	
	private func contextMenu(for media: Playlist.Media) -> some View {
		ShareLink(item: media.url, preview: SharePreview(media.name))
	}
}
