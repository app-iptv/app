//
//  ContentView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 12/03/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	
	@State var vm: ViewModel = ViewModel()
	
	@State var isParsing: Bool = false
	
	var body: some View {
		TabView {
			PlaylistsListView(vm: vm, isParsing: $isParsing)
				.tabItem { Label("Playlists", systemImage: "tv") }
			SettingsView(vm: vm)
				.tabItem { Label("Settings", systemImage: "gear") }
			SearchView()
				.tabItem { Image(systemName: "magnifyingglass") }
		}
		.sheet(isPresented: $vm.isPresented) {
			AddPlaylistView(vm)
		}
		.sheet(isPresented: $isParsing) { ProgressView() }
	}
}

#Preview {
	ContentView()
}
