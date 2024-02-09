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
	
	var body: some Scene {
		
		WindowGroup(id: "main") {
			HomeView(isPresented: $isPresented)
				.modelContainer(for: [SavedPlaylist.self])
		}.commands {
			CommandGroup(replacing: .newItem) {
				Button("New Playlist") {
					isPresented.toggle()
				}.keyboardShortcut("N", modifiers: [.command, .shift])
			}
		}
		
#if os(macOS)
		Settings {
			SettingsView()
				.modelContainer(for: [SavedPlaylist.self])
		}
#endif
	}
}
