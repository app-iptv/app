//
//  MainView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 08/11/2024.
//

import SwiftUI
import SwiftData
import Foundation
import M3UKit
import SDWebImageSwiftUI
import TipKit
import XMLTV

struct MainView: View {
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(\.isSearching) private var searchState
	@Environment(AppState.self) private var appState
	
	@Query private var playlists: [Playlist]

	@State private var searchQuery: String = ""
	@State private var favouritesTip: FavouritesTip = .init()
	
	var body: some View {
		NavigationStack {
			Group {
				if let playlist = appState.selectedPlaylist {
					mediaListView(for: playlist)
						.navigationTitle(playlist.name)
						.searchable(text: $searchQuery, prompt: "Search")
						.toolbar(id: "mediasToolbar") {
							ToolbarItem(id: "groupPicker") {
								Picker(
									"Select Group",
									selection: Bindable(appState).selectedGroup
								) {
									Label("All", systemImage: "tray.2")
										.labelStyle(.iconOnly)
										.tag("All")
									
									ForEach(groups(for: playlist), id: \.self) { group in
										Label(group, systemImage: "tray")
											.tag(group)
									}
								}
								.pickerStyle(.menu)
							}
							
							ToolbarItem(id: "edit") { EditButton() }
						}
				} else {
					ContentUnavailableView {
						Label("No Playlist", systemImage: "list.bullet")
					} description: {
						Text("Select a playlist to view its medias.")
					}
				}
			}
			.navigationTitle(appState.selectedPlaylist?.name ?? "IPTV App")
			.toolbarTitleDisplayMode(.inline)
			.toolbarTitleMenu {
				ForEach(playlists) { playlist in
					Button(playlist.name) {
						appState.selectedPlaylist = playlist
					}
				}
				
				Divider()
				
				Button("Add Playlist", systemImage: "plus") {
					appState.isAddingPlaylist = true
				}
			}
			.navigationDestination(for: Media.self) { media in
				MediaDetailView(
					playlistName: appState.selectedPlaylist!.name, media: media,
					epgLink: appState.selectedPlaylist!.epgLink)
			}
			.toolbar(id: "main") {
				ToolbarItem(id: "openSingleStream", placement: .topBarLeading) {
					Button("Open Stream", systemImage: "play") {
						appState.openedSingleStream.toggle()
					}
				}
			}
		}
	}
}

extension MainView {
	private func mediaListView(for playlist: Playlist) -> some View {
		Group {
			if filteredMediasForGroup(for: playlist).isEmpty {
				ContentUnavailableView.search(text: searchQuery)
			} else {
				List {
					TipView(favouritesTip)
						.task { await FavouritesTip.showTipEvent.donate() }
					
					ForEach(filteredMediasForGroup(for: playlist)) { media in
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
	}
	
	private func searchResults(for playlist: Playlist) -> [Media] {
		guard !searchQuery.isEmpty else { return playlist.medias }
		let results = playlist.medias.filter { media in
			media.title.localizedStandardContains(searchQuery)
		}

		return results
	}

	private func groups(for playlist: Playlist) -> [String] {
		let allGroups = Set(
			searchResults(for: playlist).compactMap {
				$0.attributes["group-title"] ?? "Undefined"
			}
		)
		
		return allGroups.sorted()
	}

	private func filteredMediasForGroup(for playlist: Playlist) -> [Media] {
		guard appState.selectedGroup == "All" else {
			return searchResults(for: playlist).filter {
				($0.attributes["group-title"] ?? "Undefined")
					== appState.selectedGroup
			}
		}
		
		return searchResults(for: playlist)
	}
}
