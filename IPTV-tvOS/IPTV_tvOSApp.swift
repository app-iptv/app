//
//  IPTV_tvOSApp.swift
//  IPTV-tvOS
//
//  Created by Pedro Cordeiro on 22/02/2024.
//

import SwiftUI
import SwiftData

@main
struct IPTV_tvOSApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modelContainer(for: [SavedPlaylist.self])
		}
	}
}
