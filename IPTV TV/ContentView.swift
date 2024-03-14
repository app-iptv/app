//
//  ContentView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 12/03/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	
	@Query var modelPlaylists: [ModelPlaylist]
	
	@StateObject var vm: ViewModel = ViewModel()
	
	@State var isParsing: Bool = false
	
	var body: some View {
		TabView {
			PlaylistsListView(vm: vm, isParsing: $isParsing)
				.tabItem { Label("Playlists", systemImage: "tv") }
			SettingsView(vm: vm)
				.tabItem { Image(systemName: "gear") }
		}
		.sheet(isPresented: $vm.isPresented) { AddPlaylistView(isPresented: $vm.isPresented, isParsing: $isParsing, parserDidFail: $vm.parserDidFail, parserError: $vm.parserError) }
		.sheet(isPresented: $isParsing) { ProgressView() }
	}
}

#Preview {
	ContentView()
}
