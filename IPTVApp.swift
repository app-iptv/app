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
    
    var body: some Scene {
        
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: SavedPlaylist.self)
    }
}
