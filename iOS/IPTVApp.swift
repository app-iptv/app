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
	
	@State var vm = ViewModel.shared
	
	@AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_CHANNELS") var favorites: [Media] = []
	@AppStorage("VIEWING_MODE") var viewingMode: ViewingMode = .regular
	@AppStorage("SELECTED_TAB") var selectedTab: Tab = .home
	
	@Environment(\.openWindow) var openWindow
	
	@State var isRemovingAll: Bool = false
	
	var commands: some Commands {
		Group {
			CommandGroup(replacing: .newItem) {
				Button("New Playlist", systemImage: "plus") {
					vm.isPresented.toggle()
				}.keyboardShortcut("N", modifiers: [.command])
				
				Button("Open Single Stream", systemImage: "play") {
					vm.openedSingleStream.toggle()
				}.keyboardShortcut("O", modifiers: [.command])
			}
			
			#if targetEnvironment(macCatalyst)
			CommandGroup(replacing: .appInfo) {
				Button("About IPTV App", systemImage: "info.circle") {
					openWindow(id: "ABOUT_WINDOW")
				}.keyboardShortcut("A", modifiers: [.command])
			}
			#endif
			
			CommandGroup(replacing: .appSettings) {
				Menu("Settings", systemImage: "gear") {
					Button("Show Tips Again") {
						isFirstLaunch.toggle()
					}.keyboardShortcut("T", modifiers: [.command])
					
					Picker("Viewing Mode", systemImage: "list.triangle", selection: $viewingMode) {
						ForEach(ViewingMode.allCases) { mode in
							mode.label.tag(mode)
						}
					}
					
					Button("Reset Favorites", systemImage: "trash", role: .destructive) {
						isRemovingAll.toggle()
					}.keyboardShortcut(.delete, modifiers: .all)
					
					#if targetEnvironment(macCatalyst)
					Button("Tip Jar", systemImage: "hands.clap") {
						openWindow(id: "TIP_JAR_WINDOW")
					}.keyboardShortcut("T", modifiers: [.command, .shift])
					
					Button("Open Legacy Settings", systemImage: "gear") {
						openWindow(id: "SETTINGS_WINDOW")
					}
					#endif
				}
			}
		}
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView(isRemovingAll: $isRemovingAll)
		}
		.modelContainer(for: Playlist.self, inMemory: false, isAutosaveEnabled: true, isUndoEnabled: true)
		.commands { commands }
		
		#if targetEnvironment(macCatalyst)
		WindowGroup(id: "ABOUT_WINDOW") { AboutView() }
		
		WindowGroup("Settings", id: "SETTINGS_WINDOW") { SettingsView(isRemovingAll: $isRemovingAll) }
		#endif
	}
}
