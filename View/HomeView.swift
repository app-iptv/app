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

// MARK: HomeView
struct HomeView: View {
	
	@State var isParsing: Bool = false
	
	@Environment(\.modelContext) var context
	
	@Query var savedPlaylists: [SavedPlaylist]
	
	@Binding var isPresented: Bool
	
	@State var isBeingOrganisedByGroups: Bool = false
	
	@ObservedObject var vm = ViewModel()
	
	@State var openedSingleStream: Bool = false
	
	let parser = PlaylistParser()
	
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

extension HomeView {
	
	var navigationView: some View {
		#if !os(macOS)
		NavigationStack {
			PlaylistsListView(selection: $vm.selectedPlaylist, isPresented: $isPresented, openedSingleStream: $openedSingleStream)
		}
		#else
		NavigationSplitView {
			PlaylistsListView(selection: $vm.selectedPlaylist, isPresented: $isPresented, openedSingleStream: $openedSingleStream)
		} content: {
			if let playlist = vm.selectedPlaylist {
				MediaListView(media: playlist.playlist?.medias ?? [], selectedMedia: $vm.selectedMedia)
					.navigationTitle(playlist.name)
					.navigationSubtitle(vm.selectedMedia?.name ?? "")
			}
		} detail: {
			if vm.selectedMedia != nil {
				MediaDetailView(playlistName: vm.selectedPlaylist?.name ?? "", selectedMedia: $vm.selectedMedia)
			}
		}
		#endif
	}
}
