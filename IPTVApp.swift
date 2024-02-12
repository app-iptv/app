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
		
		#if os(macOS)
		Window("IPTV", id: "main") {
			HomeView(isPresented: $isPresented)
		}
		.modelContainer(for: [SavedPlaylist.self])
		.commands {
			CommandGroup(replacing: .newItem) {
				Button("New Playlist") {
					isPresented.toggle()
				}.keyboardShortcut("N", modifiers: [.command])
			}
		}
		#else
		WindowGroup(id: "main") {
			HomeView(isPresented: $isPresented)
		}
		.modelContainer(for: [SavedPlaylist.self])
		#if !os(tvOS)
		.commands {
			CommandGroup(replacing: .newItem) {
				Button("New Playlist") {
					isPresented.toggle()
				}.keyboardShortcut("N", modifiers: [.command])
			}
		}
		#endif
		#endif
		
		#if os(macOS)
		Settings {
			SettingsView()
				.modelContainer(for: [SavedPlaylist.self])
		}
		#endif
	}
}
