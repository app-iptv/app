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
	
	@Bindable var vm: ViewModel
	
	var tabs: some View {
		TabView(selection: $selectedTab) {
			#if targetEnvironment(macCatalyst)
			HomeView(vm).tag(Tab.home)
				.tabForView(selection: $selectedTab, for: .home)
			FavoritesView().tag(Tab.favorites)
				.tabForView(selection: $selectedTab, for: .favorites)
			#else
			FavoritesView().tag(Tab.favorites)
				.tabForView(selection: $selectedTab, for: .favorites)
			HomeView(vm).tag(Tab.home)
				.tabForView(selection: $selectedTab, for: .home)
			SettingsView(vm: vm, isRemovingAll: $isRemovingAll).tag(Tab.settings)
				.tabForView(selection: $selectedTab, for: .settings)
			#endif
		}
	}
	
	var body: some View {
		tabs
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

#Preview("Content View") {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: Playlist.self, configurations: config)
	
	return ContentView(isRemovingAll: .constant(false), vm: ViewModel())
		.modelContainer(container)
}

extension View {
	func tabForView(selection: Binding<Tab>, for view: Tab) -> some View {
		self.tabItem { Label(view.name, systemImage: selection.wrappedValue == view ? view.fillImage : view.nonFillImage) }
	}
}
