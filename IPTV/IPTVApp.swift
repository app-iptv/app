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
	
	@State var isPresented: Bool = false
	
	@State var openedSingleStream: Bool = false
	
	@AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
	
	var newPlaylistAndOpenSingleStreamCommands: some Commands {
		CommandGroup(replacing: .newItem) {
			Button("New Playlist") {
				isPresented.toggle()
			}.keyboardShortcut("N", modifiers: [.command])
			Button("Open Single Stream") {
				openedSingleStream.toggle()
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
			ContentView(isPresented: $isPresented, openedSingleStream: $openedSingleStream)
				.sheet(isPresented: $isFirstLaunch) { FirstLaunchView(isFirstLaunch: $isFirstLaunch) }
		}
		.modelContainer(for: [ModelPlaylist.self], isAutosaveEnabled: true, isUndoEnabled: true)
		.commands {
			newPlaylistAndOpenSingleStreamCommands
			showTipsAgainCommands
		}
	}
}
