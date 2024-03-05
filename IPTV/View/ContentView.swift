//
//  HomeView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import SwiftData

// MARK: ContentView
struct ContentView: View {
	
	@State var isParsing: Bool = false
	
	@Environment(\.modelContext) var context
	
	@Query var savedPlaylists: [SavedPlaylist]
	
	@Binding var isPresented: Bool
	
	@State var isBeingOrganisedByGroups: Bool = false
	
	@ObservedObject var vm = ViewModel()
	
	@State var openedSingleStream: Bool = false
	
	// MARK: BodyNavigationSplitView
	var body: some View {
		if isParsing {
			LoadingView()
		} else if vm.parserDidFail {
			ErrorView()
		} else if savedPlaylists.isEmpty {
			ContentUnavailableView {
				Label("No Playlists", systemImage: "list.and.film")
			} description: {
				Text("Playlists that you add will appear here.")
			} actions: {
				Button { isPresented.toggle() } label: { Label("Add Playlist", systemImage: "plus") }
			}
			.sheet(isPresented: $isPresented) {
				AddPlaylistView(isPresented: $isPresented, isParsing: $isParsing)
			}
		} else {
			navigationView
				.sheet(isPresented: $isPresented) {
					AddPlaylistView(isPresented: $isPresented, isParsing: $isParsing)
				}
		}
	}
}

extension ContentView {
	
	var navigationView: some View {
		NavigationSplitView {
			PlaylistsListView(selection: $vm.selectedPlaylist, isPresented: $isPresented, openedSingleStream: $openedSingleStream)
		} content: {
			if let playlist = vm.selectedPlaylist {
				MediaListView(media: playlist.playlist?.medias ?? [], selectedMedia: $vm.selectedMedia)
					.navigationTitle(playlist.name)
					#if os(macOS)
					.navigationSubtitle(vm.selectedMedia?.name ?? "")
					#endif
					.navigationSplitViewColumnWidth(ideal: 300)
			} else {
				ContentUnavailableView {
					Label("No Medias", systemImage: "list.and.film")
				} description: {
					Text("The selected playlist's channels will appear here.")
				}
			}
		} detail: {
			if let media = vm.selectedMedia {
				MediaDetailView(playlistName: vm.selectedPlaylist?.name ?? "", selectedMedia: media)
			} else {
				ContentUnavailableView {
					Label("No Content", systemImage: "play")
				} description: {
					Text("The selected channel's content will appear here")
				}
			}
		}
	}
}
