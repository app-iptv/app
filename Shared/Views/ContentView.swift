//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	
	@Query private var modelPlaylists: [Playlist]
	
	@Environment(\.modelContext) private var context
	@Environment(\.horizontalSizeClass) private var sizeClass
	
	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_mediaS") private var favourites: [Media] = []
	
	@Binding private var isRemovingAll: Bool
	
	@State private var selectedTab: Tab = .home
	@State private var vm = ViewModel.shared
	
	internal init(isRemovingAll: Binding<Bool>) {
		self._isRemovingAll = isRemovingAll
	}
	
	var body: some View {
		TabView(selectedTab: $selectedTab, isRemovingAll: $isRemovingAll)
			.sheet(isPresented: $vm.isPresented) { AddPlaylistView().modelContext(context) }
			.sheet(isPresented: $vm.openedSingleStream) { SingleStreamView() }
			.sheet(isPresented: $vm.parserDidFail) { ErrorView() }
			.alert("Delete All Favorited Medias?", isPresented: $isRemovingAll) {
				Button("Cancel", systemImage: "xmark.circle", role: .cancel) { isRemovingAll.toggle() }
				Button("DELETE ALL", systemImage: "trash", role: .destructive) { favourites.removeAll() }
			} message: {
				Text("WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it.")
			}
			#if os(tvOS)
			.onAppear { vm.selectedPlaylist = modelPlaylists.first }
			#elseif os(macOS)
			.sheet(isPresented: $isFirstLaunch) { FirstLaunchView(isFirstLaunch: $isFirstLaunch) }
			#else
			.fullScreenCover(isPresented: $isFirstLaunch) { OnboardingView().ignoresSafeArea() }
			#endif
	}
}
