//
//  ContentView.swift
//  IPTV-tvOS
//
//  Created by Pedro Cordeiro on 22/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	
	@Environment(\.modelContext) var context
	@Query var savedPlaylists: [SavedPlaylist]
	
	@ObservedObject var vm = ViewModel()
	
	@State var isPresented: Bool = false
	@State var isParsing: Bool = false
	
	var body: some View {
		NavigationStack {
			PlaylistGrid()
				.navigationTitle("Playlists")
				.sheet(isPresented: $isPresented) { AddPlaylistView(isPresented: $isPresented, isParsing: $isParsing) }
				.sheet(isPresented: $isParsing) { LoadingView() }
				.toolbar { Button { isPresented.toggle() } label: { Label("Add Playlist", image: "plus").labelStyle(.iconOnly) } }
		}
	}
}
