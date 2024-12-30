//
//  ContentView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) private var context
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(AppState.self) private var appState
	
	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_mediaS") private var favourites: [Media] = []
	
	@Query private var playlists: [Playlist]
	
	@Binding private var isRemovingAll: Bool
	
	@State private var epgFetchingController: EPGFetchingController = EPGFetchingController()
	@State private var sceneState: SceneState = SceneState()
	
	@State private var selectedTab: Tab = .home

	internal init(isRemovingAll: Binding<Bool>) {
		self._isRemovingAll = isRemovingAll
	}

	var body: some View {
		TabView(selectedTab: $selectedTab, isRemovingAll: $isRemovingAll)
			.onChange(of: sceneState.selectedPlaylist, resetEPG)
			.environment(sceneState)
			.environment(epgFetchingController)
			.sheet(isPresented: Bindable(appState).isAddingPlaylist) { AddPlaylistView() }
			.sheet(isPresented: Bindable(appState).openedSingleStream) { SingleStreamView() }
			.alert("Delete All Favorited Medias?", isPresented: $isRemovingAll) { deleteMediasAlert } message: { deleteMediasMessage }
			.withOnboardingView(isFirstLaunch: $isFirstLaunch)
	}
}

extension ContentView {
	private func resetEPG() {
		Task { await epgFetchingController.load(epg: sceneState.selectedPlaylist?.epgLink, appState: appState) }
	}
	
	private var deleteMediasAlert: some View {
		Group {
			Button("Cancel", systemImage: "xmark.circle", role: .cancel) {
				isRemovingAll.toggle()
			}
			Button("DELETE ALL", systemImage: "trash", role: .destructive) {
				favourites.removeAll()
			}
		}
	}
	
	private var deleteMediasMessage: Text {
		Text("WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it.")
	}
}
