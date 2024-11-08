//
//  ContentView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {

	@Query private var playlists: [Playlist]

	@Environment(\.modelContext) private var context
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(AppState.self) private var appState

	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_mediaS") private var favourites: [Media] = []

	@Binding private var isRemovingAll: Bool

	@State private var selectedTab: Tab = .home

	internal init(isRemovingAll: Binding<Bool>) {
		self._isRemovingAll = isRemovingAll
	}

	var body: some View {
		TabView(selectedTab: $selectedTab, isRemovingAll: $isRemovingAll)
			.sheet(isPresented: Bindable(appState).isAddingPlaylist) {
				AddPlaylistView().modelContext(context)
			}
			.sheet(isPresented: Bindable(appState).openedSingleStream) { SingleStreamView() }
			.alert("Delete All Favorited Medias?", isPresented: $isRemovingAll) {
				Button("Cancel", systemImage: "xmark.circle", role: .cancel) {
					isRemovingAll.toggle()
				}
				Button("DELETE ALL", systemImage: "trash", role: .destructive) {
					favourites.removeAll()
				}
			} message: {
				Text("WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it.")
			}
		#if os(macOS)
			.sheet(isPresented: $isFirstLaunch) {
				FirstLaunchView(isFirstLaunch: $isFirstLaunch)
			}
		#else
			.fullScreenCover(isPresented: $isFirstLaunch) {
				OnboardingView().ignoresSafeArea()
			}
		#endif
	}
}
