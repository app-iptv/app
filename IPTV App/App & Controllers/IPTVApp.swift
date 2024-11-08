//
//  IPTVApp.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import AVKit
import M3UKit
import SwiftData
import SwiftUI
import TipKit

@main
struct IPTVApp: App {

	#if os(iOS)
		@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	#endif

	@Environment(\.openWindow) private var openWindow

	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []
	@AppStorage("VIEWING_MODE") private var viewingMode: ViewingMode = .regular

	@Query private var playlists: [Playlist]
	
	@State private var appState = AppState()
	@State private var isRemovingAll: Bool = false
	@State private var epgFetchingController: EPGFetchingController = EPGFetchingController()

	private var commands: some Commands {
		Group {
			CommandGroup(replacing: .newItem) {
				Button("New Playlist", systemImage: "plus") {
					appState.isAddingPlaylist.toggle()
				}.keyboardShortcut("N", modifiers: [.command])
				
				Button("Open Single Stream", systemImage: "play") {
					appState.openedSingleStream.toggle()
				}.keyboardShortcut("O", modifiers: [.command])
				
				#if os(macOS)
					Divider()
				
					Button("New Window") {
						openWindow(id: "MAIN_WINDOW")
					}.keyboardShortcut("N", modifiers: [.command, .shift])
				#endif
			}
			
			#if os(macOS)
				CommandGroup(replacing: .appInfo) {
					Button("About IPTV App", systemImage: "info.circle") {
						openWindow(id: "ABOUT_WINDOW")
					}.keyboardShortcut("A", modifiers: [.command])
				}
			#endif
		}
	}

	var body: some Scene {
		WindowGroup(id: "MAIN_WINDOW") {
			ContentView(isRemovingAll: $isRemovingAll)
				.task { try? Tips.configure() }
		}
		.modelContainer(SwiftDataController.shared.persistenceContainer)
		.environment(epgFetchingController)
		.environment(appState)
		.commands { commands }
		.onChange(of: appState.selectedPlaylist) { epgFetchingController = EPGFetchingController(epg: appState.selectedPlaylist?.epgLink, appState: appState) }

		#if os(macOS)
			Window("About IPTV App", id: "ABOUT_WINDOW") {
				AboutView()
					.padding()
			}
			.windowResizability(.contentSize)
			.windowStyle(.hiddenTitleBar)

			Settings {
				SettingsView(isRemovingAll: $isRemovingAll)
					.frame(width: 500, height: 300)
			}
            .environment(epgFetchingController)
			.environment(appState)
			.windowStyle(.hiddenTitleBar)
		#endif
	}
}
