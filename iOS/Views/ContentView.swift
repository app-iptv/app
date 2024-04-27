//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	
	@Environment(\.modelContext) var context
	
	@AppStorage("SELECTED_TAB") var selectedTab: Tab = .home
	@AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_mediaS") var favorites: [Media] = []
	
	@Binding var isRemovingAll: Bool
	
	@State var vm = ViewModel.shared
	
	var tabs: some View {
		TabView(selection: $selectedTab) {
			#if targetEnvironment(macCatalyst)
			HomeView()
				.tabForView(selection: $selectedTab, for: .home)
			FavoritesView()
				.tabForView(selection: $selectedTab, for: .favorites)
			#else
			FavoritesView()
				.tabForView(selection: $selectedTab, for: .favorites)
			HomeView()
				.tabForView(selection: $selectedTab, for: .home)
			SettingsView(isRemovingAll: $isRemovingAll)
				.tabForView(selection: $selectedTab, for: .settings)
			#endif
		}
	}
	
	var body: some View {
		tabs
			.sheet(isPresented: $isFirstLaunch) { FirstLaunchView(isFirstLaunch: $isFirstLaunch) }
			.sheet(isPresented: $vm.isPresented) { AddPlaylistView().modelContext(context) }
			.sheet(isPresented: $vm.openedSingleStream) { SingleStreamView() }
			.sheet(isPresented: $vm.parserDidFail) { ErrorView() }
			.alert("Delete All Favorited Medias?", isPresented: $isRemovingAll) {
				Button("Cancel", systemImage: "xmark.circle", role: .cancel) { isRemovingAll.toggle() }
				Button("DELETE ALL", systemImage: "trash", role: .destructive) { favorites.removeAll() }
			} message: {
				Text("WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it.")
			}
	}
}
