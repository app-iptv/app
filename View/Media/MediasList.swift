//
//  MediasList.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit

struct MediasList: View {
	
	@Binding var selectedMedia: Playlist.Media?
	#if os(macOS)
	@Binding var selectedPlaylist: SavedPlaylist?
	#else
	@State var selectedPlaylist: SavedPlaylist?
	#endif
	
	@Binding var selectedGroup: String
	@Binding var outerGroups: [String]
	
	@Binding var selectedSortingOption: SortingOption
	
	@State var mediaSearchText: String = ""
	
	var body: some View {
		#if os(macOS)
		List(selection: $selectedMedia) {
			content
		}
		.id(mediaSearchText)
		.listStyle(.plain)
		.searchable(text: $mediaSearchText, prompt: "Search Medias")
		#if os(macOS)
		.navigationSubtitle(selectedMedia?.name ?? "")
		#endif
		#else
		List {
			content
		}
		.id(mediaSearchText)
		.listStyle(.plain)
		.searchable(text: $mediaSearchText, prompt: "Search Medias")
		#if os(macOS)
		.navigationSubtitle(selectedMedia?.name ?? "")
		#endif
		#endif
	}
	
	var mediaSearchResults: [Playlist.Media] {
		if mediaSearchText == "" {
			return selectedPlaylist?.playlist?.medias ?? []
		} else {
			return selectedPlaylist?.playlist?.medias.filter { $0.name.lowercased().contains(mediaSearchText.lowercased()) } ?? []
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
	
	var content: some View {
		
		#if os(macOS)
		ForEach(filteredMedias, id: \.self) { media in
			MediaRow(media: media)
				.tag(media)
				.contextMenu { ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? "")) }
				.swipeActions(edge: .leading) { ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? "")) }
		}
		.onDelete { selectedPlaylist?.playlist?.medias.remove(atOffsets: $0) }
		.onMove { selectedPlaylist?.playlist?.medias.move(fromOffsets: $0, toOffset: $1) }
		.onAppear { self.outerGroups = groups }
		#else
		ForEach(filteredMedias, id: \.self) { media in
			NavigationLink(value: media) {
				MediaRow(media: media)
			}
			.contextMenu { ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? "")) }
			.swipeActions(edge: .leading) { ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? "")) }
		}
		.onDelete { selectedPlaylist?.playlist?.medias.remove(atOffsets: $0) }
		.onMove { selectedPlaylist?.playlist?.medias.move(fromOffsets: $0, toOffset: $1) }
		.onAppear { self.outerGroups = groups }
		#endif
	}
}
