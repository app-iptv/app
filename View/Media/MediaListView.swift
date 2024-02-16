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
	
	#if os(macOS)
	@Binding var selectedMedia: Playlist.Media?
	#endif
	
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
		listContent
			.searchable(text: $mediaSearchText, prompt: "Search Medias")
			#if os(macOS)
			.navigationSubtitle(vm.selectedMedia?.name ?? "")
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
			#else
			.toolbar(id: "mediasToolbar") {
				ToolbarItem(id: "groupSelection", placement: .topBarTrailing) {
					Picker("Select Groups", systemImage: "line.3.horizontal.decrease.circle", selection: $vm.selectedGroup) {
						ForEach(groups, id: \.self) { group in
							if group == "All" {
								Label(group, systemImage: "tray.2")
									.tag(group)
							} else {
								Label(group, systemImage: "tray")
									.tag(group)
							}
						}
					}.pickerStyle(.menu)
				}
			}
			#endif
	}
	
	private var listContent: some View {
		ScrollView {
			LazyVStack {
				Divider()
				ForEach(filteredMediasForGroup(vm.selectedGroup), id: \.self) { media in
					mediaRow(for: media)
						.padding(.horizontal)
					Divider()
				}
			}
		}
	}
	
	private func filteredMediasForGroup(_ group: String) -> [Playlist.Media] {
		guard group != "All" else { return searchResults }
		return searchResults.filter { $0.attributes.groupTitle == group }
	}
	
	private func mediaRow(for media: Playlist.Media) -> some View {
		#if os(macOS)
		Button {
			selectedMedia = media
		} label: {
			MediaRowView(media: media)
		}
		.buttonStyle(.borderless)
		.foregroundStyle(.primary)
		#else
		NavigationLink(value: media) {
			MediaRowView(media: media)
		}
		.foregroundStyle(.primary)
		#if !os(tvOS)
		.swipeActions(edge: .leading) { contextMenu(for: media) }
		.contextMenu { contextMenu(for: media) }
		#endif
		#endif
	}
	
	#if !os(tvOS)
	private func contextMenu(for media: Playlist.Media) -> some View {
		ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? ""))
	}
	#endif
}
