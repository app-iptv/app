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
	@Environment(\.horizontalSizeClass) var sizeClass
	
	@Query var modelPlaylists: [ModelPlaylist]
	
	@Binding var isPresented: Bool
	
	@StateObject var vm = ViewModel()
	
	@Binding var openedSingleStream: Bool
	@State var path = NavigationPath()
	
	// MARK: BodyNavigationSplitView
	var body: some View {
		NavigationSplitView {
			Group {
				if modelPlaylists.isEmpty {
					ContentUnavailableView {
						Label("No Playlists", systemImage: "list.and.film")
					} description: {
						Text("Playlists that you add will appear here.")
					} actions: {
						Button("Add Playlist", systemImage: "plus") { isPresented.toggle() }
						Button("Open Single Stream", systemImage: "play") { openedSingleStream.toggle() }
					}
				} else {
					PlaylistsListView(selection: $vm.selectedPlaylist, isPresented: $isPresented, openedSingleStream: $openedSingleStream)
				}
			}
			.navigationTitle("Playlists")
			.navigationSplitViewColumnWidth(min: 216, ideal: 216)
		} detail: {
			if let playlist = vm.selectedPlaylist {
				MediaListView(media: playlist.medias, selectedMedia: $vm.selectedMedia, playlistName: playlist.name)
					.navigationTitle(playlist.name)
			} else {
				ContentUnavailableView {
					Label("No Medias", systemImage: "list.and.film")
				} description: {
					Text("The selected playlist's channels will appear here.")
				}
			}
		}
		.sheet(isPresented: $isPresented) { AddPlaylistView(isPresented: $isPresented, isParsing: $isParsing, parserDidFail: $vm.parserDidFail, parserError: $vm.parserError) }
		.sheet(isPresented: $openedSingleStream) { SingleStreamView(openedSingleStream: $openedSingleStream) }
		.sheet(isPresented: $isParsing) { LoadingView() }
		.sheet(isPresented: $vm.parserDidFail) { ErrorView(parserDidFail: $vm.parserDidFail, parserError: $vm.parserError) }
	}
}
