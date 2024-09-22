//
//  mediaListView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import Foundation
import M3UKit
import SDWebImageSwiftUI
import SwiftUI
import TipKit
import XMLTV

struct MediaListView: View {

	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(\.isSearching) private var searchState
	@Environment(ViewModel.self) private var vm

	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0

	@State private var searchQuery: String = ""
	@State private var favouritesTip: FavouritesTip = .init()

	private let medias: [Media]
	private let playlistName: String
	private let epgLink: String
	private let index: Int

	internal init(
		medias: [Media], playlistName: String, epgLink: String, index: Int
	) {
		self.medias = medias
		self.playlistName = playlistName
		self.epgLink = epgLink
		self.index = index
	}

	var body: some View {
		NavigationStack {
			Group {
				if filteredMediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					listView
				}
			}
			.searchable(text: $searchQuery, prompt: "Search")
			.navigationDestination(for: Media.self) { media in
				MediaDetailView(
					playlistName: vm.selectedPlaylist!.name, media: media,
					epgLink: vm.selectedPlaylist!.epgLink)
			}
			.onAppear { selectedPlaylist = index }
			#if !os(tvOS)
				.navigationTitle(playlistName)
					#if os(iOS)
						.toolbarRole(sizeClass!.toolbarRole)
					#endif
				.toolbar(id: "mediasToolbar") {
					ToolbarItem(id: "groupPicker", placement: placement) {
						Picker(
							"Select Group",
							selection: Bindable(vm).selectedGroup
						) {
							Label("All", systemImage: "tray.2")
								#if os(macOS)
									.labelStyle(.titleAndIcon)
								#endif
							.tag("All")

							ForEach(groups, id: \.self) { group in
								Label(group, systemImage: "tray")
									#if os(macOS)
										.labelStyle(.titleAndIcon)
									#endif
								.tag(group)
							}
						}
						.pickerStyle(.menu)
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

	private var listView: some View {
		List {
			TipView(favouritesTip)
				.task { await FavouritesTip.showTipEvent.donate() }

			ForEach(filteredMediasForGroup) { media in
				#if os(tvOS)
					MediaItemView(media: media, playlistName: playlistName)
				#else
					NavigationLink(value: media) {
						MediaCellView(media: media)
					}
					.badge(medias.firstIndex(of: media)! + 1)
				#endif
			}
		}
		.listStyle(.plain)
	}

	private var searchResults: [Media] {
		guard !searchQuery.isEmpty else { return medias }
		let results = medias.filter { media in
			media.title.localizedStandardContains(searchQuery)
		}

		return results
	}

	private var groups: [String] {
		let allGroups = Set(
			searchResults.compactMap {
				$0.attributes["group-title"] ?? "Undefined"
			})
		return allGroups.sorted()
	}

	private var filteredMediasForGroup: [Media] {
		guard vm.selectedGroup == "All" else {
			return searchResults.filter {
				($0.attributes["group-title"] ?? "Undefined")
					== vm.selectedGroup
			}
		}
		return searchResults
	}
}
