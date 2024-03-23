//
//  IPTVApp.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI
import Foundation
import M3UKit
import SwiftData

@main
struct IPTVApp: App {
	
	@State var vm = ViewModel()
	
	@AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_MEDIAS") var favorites: [Playlist.Media] = []
	
	var newPlaylistAndOpenSingleStreamCommands: some Commands {
		CommandGroup(replacing: .newItem) {
			Button("New Playlist") {
				vm.isPresented.toggle()
			}.keyboardShortcut("N", modifiers: [.command])
			Button("Open Single Stream") {
				vm.openedSingleStream.toggle()
			}.keyboardShortcut("N", modifiers: [.command, .shift])
		}
	}
	
	var showTipsAgainCommands: some Commands {
		CommandGroup(replacing: .appSettings) {
			Menu("Settings") {
				Button("Show Tips Again") {
					isFirstLaunch.toggle()
				}.keyboardShortcut("T", modifiers: [.command])
			}
		}
	}
	
	var body: some Scene {
		WindowGroup {
			TabView {
				ContentView(vm: vm, favorites: $favorites)
					.tabItem { Label("Home", systemImage: "play.house.fill") }
				FavoritesView(favorites: $favorites)
					.tabItem { Label("Favorites", systemImage: "star.fill") }
			}
			.sheet(isPresented: $isFirstLaunch) { FirstLaunchView(isFirstLaunch: $isFirstLaunch) }
			.sheet(isPresented: $vm.isPresented) { AddPlaylistView(vm) }
			.sheet(isPresented: $vm.openedSingleStream) { SingleStreamView(vm) }
			.sheet(isPresented: $vm.isParsing) { LoadingView() }
			.sheet(isPresented: $vm.parserDidFail) { ErrorView(vm) }
		}
		.modelContainer(for: ModelPlaylist.self, inMemory: false, isAutosaveEnabled: true, isUndoEnabled: true)
		.commands { newPlaylistAndOpenSingleStreamCommands ; showTipsAgainCommands }
	}
}
