//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import SwiftUI

struct ContentView: View {
	
	@Environment(\.modelContext) var context
	
	@AppStorage("SELECTED_TAB") var selectedTab: Tab = .home
	@AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_mediaS") var favorites: [Media] = []
	
	@Binding var isRemovingAll: Bool
	
	@Bindable var vm: ViewModel
	
	var body: some View {
		TabView(selection: $selectedTab) {
			#if targetEnvironment(macCatalyst)
			HomeView(vm).tag(Tab.home)
				.tabItem { Label("Home", systemImage: "play.house.fill") }
			FavoritesView().tag(Tab.favorites)
				.tabItem { Label("Favorites", systemImage: "star.fill") }
			#else
			FavoritesView().tag(Tab.favorites)
				.tabItem { Label("Favorites", systemImage: "star.fill") }
			HomeView(vm).tag(Tab.home)
				.tabItem { Label("Home", systemImage: "play.house.fill") }
			SettingsView(vm: vm, isRemovingAll: $isRemovingAll).tag(Tab.settings)
				.tabItem { Label("Settings", systemImage: "gear") }
			#endif
		}
		.sheet(isPresented: $isFirstLaunch) { FirstLaunchView(isFirstLaunch: $isFirstLaunch) }
		.sheet(isPresented: $vm.isPresented) { AddPlaylistView(vm).modelContext(context) }
		.sheet(isPresented: $vm.openedSingleStream) { SingleStreamView(vm) }
		.sheet(isPresented: $vm.parserDidFail) { ErrorView(vm) }
		.alert("Delete All Favorited Medias?", isPresented: $isRemovingAll) {
			Button("Cancel", systemImage: "xmark.circle", role: .cancel) { isRemovingAll.toggle() }
			Button("DELETE ALL", systemImage: "trash", role: .destructive) { favorites.removeAll() }
		} message: {
			Text("WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it.")
		}
	}
}
