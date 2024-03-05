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
	
	@State var isBeingOrganisedByGroups: Bool = false
	
	@State var mediaSearchText: String = ""
	
	@State var media: [Playlist.Media]
	
	@Binding var selectedMedia: Playlist.Media?
	
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
		
		List(filteredMediasForGroup(vm.selectedGroup), id: \.self, selection: $selectedMedia) { media in
			NavigationLink(value: media) {
				MediaCellView(media: media)
					#if !os(tvOS)
					.swipeActions(edge: .leading) { contextMenu(for: media) }
					.contextMenu { contextMenu(for: media) }
					#endif
			}
		}
		.id(UUID())
		.searchable(text: $mediaSearchText, prompt: "Search Medias")
		#if os(iOS)
		.toolbarRole(.browser)
		#endif
		.toolbar(id: "mediasToolbar") {
			ToolbarItem(id: "groupPicker") {
				Picker("Select Groups", systemImage: "line.3.horizontal.decrease.circle", selection: $vm.selectedGroup) {
					ForEach(groups, id: \.self) { group in
						if group == "All" {
							Label(group, systemImage: "tray.full").tag(group)
						} else {
							Text(group).tag(group)
						}
					}
				}.pickerStyle(.menu)
			}
		}
		#if os(macOS)
		.navigationSubtitle(vm.selectedMedia?.name ?? "")
		#endif
	}
	
	private func filteredMediasForGroup(_ group: String) -> [Playlist.Media] {
		guard group != "All" else { return searchResults }
		return searchResults.filter { $0.attributes.groupTitle == group }
	}
	
	#if !os(tvOS)
	private func contextMenu(for media: Playlist.Media) -> some View {
		ShareLink(item: media.url, preview: SharePreview(media.name))
	}
	#endif
}
