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
	@Environment(\.openWindow) private var openWindow

	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []
	@AppStorage("VIEWING_MODE") private var viewingMode: ViewingMode = .regular
	@AppStorage("MEDIA_DISPLAY_MODE") private var mediaDisplayMode: MediaDisplayMode = .list
	@AppStorage("RESET_FAVORITES") private var isResetingFavourites: Bool = false

	@Query private var playlists: [Playlist]
	
	@State private var appState = AppState()
	@State private var isRemovingAll: Bool = false
	
	#if !os(macOS)
	init() {
		let session = AVAudioSession.sharedInstance()
		
		do {
			try session.setCategory(.playback, mode: .moviePlayback)
		} catch {
			print(error.localizedDescription)
		}
	}
	#endif

	var body: some Scene {
		WindowGroup("IPTV App", id: "MAIN_WINDOW") {
			ContentView(isRemovingAll: $isRemovingAll)
				.task { try? Tips.configure() }
				.task(id: isResetingFavourites) { resetFavourites() }
		}
		.modelContainer(SwiftDataController.main.persistenceContainer)
		.environment(appState)
		.environment(EPGFetchingController())
		.commands { commands }

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
			.environment(appState)
			.windowStyle(.hiddenTitleBar)
		#endif
	}
}

extension IPTVApp {
	private func resetFavourites() {
		guard isResetingFavourites else {
			print("didnt reset favourites")
			return
		}
		
		print("reset favourites")
	}
	
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
}
