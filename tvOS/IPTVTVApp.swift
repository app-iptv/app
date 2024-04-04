//
//  IPTV_TVApp.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 12/03/2024.
//

import SwiftUI
import SwiftData

@main
struct IPTVTVApp: App {
	
	@AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(for: ModelPlaylist.self)
				.sheet(isPresented: $isFirstLaunch) { FirstLaunchView(isFirstLaunch: $isFirstLaunch) }
		}
	}
}
