//
//  ContentView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) var context
	@Environment(\.horizontalSizeClass) var sizeClass
	@Environment(AppState.self) var appState
	
	@AppStorage("FIRST_LAUNCH") var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_MEDIAS") var favourites: [Media] = []
	
	@Query var playlists: [Playlist]
	
	@State var epgFetchingController: EPGFetchingController = EPGFetchingController()
	@State var sceneState: SceneState = SceneState()
    
	var body: some View {
		@Bindable var appState = self.appState
		
		TabView(selection: $sceneState.selectedTab) {
			Tab(MediaTab.search.title, systemImage: MediaTab.search.systemImage, value: .search, role: .search) {
				SearchView()
			}
			
			Tab(MediaTab.favourites.title, systemImage: MediaTab.favourites.systemImage, value: .favourites) {
				MediasView(Playlist(MediaTab.favourites.title, medias: favourites))
			}
						
			Tab(MediaTab.settings.title, systemImage: MediaTab.settings.systemImage, value: .settings) {
				SettingsView()
			}
			
			TabSection("Playlists") {
				ForEach(playlists) { playlist in
					Tab(playlist.name, systemImage: MediaTab.playlist(playlist).systemImage, value: MediaTab.playlist(playlist)) {
						NavigationStack {
							MediasView(playlist)
						}
					}
				}
			}
			.sectionActions {
				Button("Add Playlist", systemImage: "plus") {
					appState.isAddingPlaylist.toggle()
				}
			}
			.hidden(sizeClass == .compact)
			
			Tab(MediaTab.playlists.title, systemImage: MediaTab.playlists.systemImage, value: .playlists) {
				PlaylistsView()
			}
			.hidden(sizeClass != .compact)
		}
		.tabViewStyle(.sidebarAdaptable)
		.onChange(of: sceneState.selectedTab, resetEPG)
		.environment(sceneState)
		.environment(epgFetchingController)
		.sheet(isPresented: $appState.isAddingPlaylist) { AddPlaylistView() }
		.sheet(isPresented: $appState.openedSingleStream) { SingleStreamView() }
		.onboardingView(isFirstLaunch: $isFirstLaunch)
		.alert("Delete All Favorited Medias?", isPresented: $appState.isRemovingAll) {
			deleteMediasAlert
		} message: {
			deleteMediasMessage
		}
	}
}

#Preview {
	@Previewable @State var appState: AppState = AppState()
	
	ContentView()
		.environment(appState)
}

extension ContentView {
	func resetEPG() {
		Task {
			switch sceneState.selectedTab {
				case .favourites:
					return
				case .settings:
					return
				case .search:
					return
				case .playlists:
					return
				case .playlist(let playlist):
					await epgFetchingController.load(epg: playlist.epgLink, appState: appState)
			}
		}
	}
	
	var deleteMediasAlert: some View {
		Group {
			Button("Cancel", systemImage: "xmark.circle", role: .cancel) {
				appState.isRemovingAll.toggle()
			}
			Button("DELETE ALL", systemImage: "trash", role: .destructive) {
				favourites.removeAll()
			}
		}
	}
	
	var deleteMediasMessage: Text {
		Text("WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it.")
	}
	
	var visibility: Visibility {
		switch sizeClass {
			case .compact:
				return .automatic
			case .regular:
				return .visible
			default:
				return .automatic
		}
	}

	#if os(iOS)
		var placement: ToolbarPlacement {
			switch sizeClass {
			case .compact:
				return .automatic
			case .regular:
				return .tabBar
			default:
				return .automatic
			}
		}
	#endif
}
