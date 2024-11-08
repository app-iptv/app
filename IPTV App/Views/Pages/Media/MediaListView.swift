//
//  mediaListView.swift
//  IPTV App
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
	@Environment(AppState.self) private var appState

	@State private var searchQuery: String = ""
	@State private var favouritesTip: FavouritesTip = .init()
	
	@Bindable private var playlist: Playlist
	
	internal init(_ playlist: Playlist) {
		self.playlist = playlist
	}
	
	var body: some View {
		NavigationStack {
			Group {
				if filteredMediasForGroup.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List {
						TipView(favouritesTip)
							.task { await FavouritesTip.showTipEvent.donate() }

						ForEach(filteredMediasForGroup) { media in
							NavigationLink(value: media) {
								MediaCellView(media: media)
							}
							.badge(playlist.medias.firstIndex(of: media)! + 1)
						}
						.onDelete { indexSet in
							playlist.medias.remove(atOffsets: indexSet)
						}
						.onMove { source, destination in
							playlist.medias.move(fromOffsets: source, toOffset: destination)
						}
					}
					.listStyle(.plain)
				}
			}
			.searchable(text: $searchQuery, prompt: "Search")
			.navigationDestination(for: Media.self) { media in
				MediaDetailView(
					playlistName: appState.selectedPlaylist!.name, media: media,
					epgLink: appState.selectedPlaylist!.epgLink
				)
			}
			.navigationTitle(playlist.name)
			#if os(iOS)
			.toolbarRole(sizeClass!.toolbarRole)
			.toolbar {
				ToolbarItem {
					Picker(
						"Select Group",
						selection: Bindable(appState).selectedGroup
					) {
						Label("All", systemImage: "tray.2")
							.labelStyle(.iconOnly)
						.tag("All")
						ForEach(groups, id: \.self) { group in
							Label(group, systemImage: "tray")
								.tag(group)
						}
					}
					.pickerStyle(.menu)
				}
				ToolbarItem { EditButton() }
			}
			#else
			.toolbar(id: "mediasToolbar") {
				ToolbarItem(id: "groupPicker") {
					Picker(
						"Select Group",
						selection: Bindable(appState).selectedGroup
					) {
						Label("All", systemImage: "tray.2")
							.labelStyle(.titleAndIcon)
							.tag("All")
						ForEach(groups, id: \.self) { group in
							Label(group, systemImage: "tray")
								.labelStyle(.titleAndIcon)
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
	private var searchResults: [Media] {
		guard !searchQuery.isEmpty else { return playlist.medias }
		let results = playlist.medias.filter { media in
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
		guard appState.selectedGroup == "All" else {
			return searchResults.filter {
				($0.attributes["group-title"] ?? "Undefined")
					== appState.selectedGroup
			}
		}
		return searchResults
	}
}
