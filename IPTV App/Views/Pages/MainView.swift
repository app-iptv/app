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
	@Environment(SceneState.self) private var sceneState
	
	@AppStorage("MEDIA_DISPLAY_MODE") private var mediaDisplayMode: MediaDisplayMode = .list
	
	@Query private var playlists: [Playlist]

	@State private var searchQuery: String = ""
	@State private var favouritesTip: FavouritesTip = FavouritesTip()
	@State private var viewModel: MediasViewModel = MediasViewModel()
	
	var body: some View {
		NavigationStack {
			Group {
				if let playlist = sceneState.selectedPlaylist {
					mediaListView(for: playlist)
						.navigationTitle(playlist.name)
						.toolbar(id: "mediasToolbar") { MediasToolbar(groups: viewModel.groups(for: playlist)) }
						.searchable(text: $searchQuery, prompt: "Search")
				} else {
					ContentUnavailableView {
						Label("No Playlist", systemImage: "list.bullet")
					} description: {
						Text("Select a playlist to view its medias.")
					}
				}
			}
			.navigationTitle(sceneState.selectedPlaylist?.name ?? "IPTV App")
			.toolbarTitleDisplayMode(.inline)
			.toolbarTitleMenu {
				ForEach(playlists) { playlist in
					Button(playlist.name) {
						sceneState.selectedPlaylist = playlist
					}
				}
				
				Divider()
				
				Button("Add Playlist", systemImage: "plus") {
					appState.isAddingPlaylist = true
				}
			}
			.navigationDestination(for: Media.self) { media in
				MediaDetailView(
					playlistName: sceneState.selectedPlaylist!.name, media: media,
					epgLink: sceneState.selectedPlaylist!.epgLink
				)
			}
			.navigationDestination(for: TVProgram.self) { EPGProgramDetailView(for: $0) }
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
			if viewModel.filteredMediasForGroup(sceneState.selectedGroup, playlist: playlist).isEmpty {
				ContentUnavailableView.search(text: searchQuery)
			} else /*if mediaDisplayMode == .grid*/ {
//				List {
//					TipView(favouritesTip)
//						.task { await FavouritesTip.showTipEvent.donate() }
//					
//					ForEach(filteredMediasForGroup(for: playlist)) { media in
//						NavigationLink(value: media) {
//							MediaCellView(media: media)
//						}
//						.badge(playlist.medias.firstIndex(of: media)! + 1)
//					}
//					.onDelete { indexSet in
//						playlist.medias.remove(atOffsets: indexSet)
//					}
//					.onMove { source, destination in
//						playlist.medias.move(fromOffsets: source, toOffset: destination)
//					}
//				}
//				.listStyle(.plain)
				
//				MediasGridView(vm: viewModel, playlist: playlist)
//			} else {
				MediasListView(vm: viewModel, playlist: playlist)
			}
		}
	}
}
