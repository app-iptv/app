//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {

	@Query private var modelPlaylists: [Playlist]

	@Environment(\.modelContext) private var context
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(ViewModel.self) private var vm

	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_mediaS") private var favourites: [Media] = []

	@Binding private var isRemovingAll: Bool

	@State private var selectedTab: Tab = .home

	internal init(isRemovingAll: Binding<Bool>) {
		self._isRemovingAll = isRemovingAll
	}

	var body: some View {
		TabView(selectedTab: $selectedTab, isRemovingAll: $isRemovingAll)
			.sheet(isPresented: Bindable(vm).isPresented) {
				AddPlaylistView().modelContext(context)
			}
			.sheet(isPresented: Bindable(vm).openedSingleStream) {
				SingleStreamView()
			}
			.sheet(isPresented: Bindable(vm).parserDidFail) { ErrorView() }
			.alert("Delete All Favorited Medias?", isPresented: $isRemovingAll)
		{
			Button("Cancel", systemImage: "xmark.circle", role: .cancel) {
				isRemovingAll.toggle()
			}
			Button("DELETE ALL", systemImage: "trash", role: .destructive) {
				favourites.removeAll()
			}
		} message: {
			Text(
				"WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it."
			)
		}
			#if os(tvOS)
				.onAppear { vm.selectedPlaylist = modelPlaylists.first }
			#endif
			#if os(macOS)
				.sheet(isPresented: $isFirstLaunch) {
					FirstLaunchView(isFirstLaunch: $isFirstLaunch)
				}
			#elseif os(iOS)
				.fullScreenCover(isPresented: $isFirstLaunch) {
					OnboardingView().ignoresSafeArea()
				}
			#endif
	}
}
