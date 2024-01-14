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
    
    @State var parsedPlaylist: Playlist? = nil
    
    @State var searchText: String = ""
    
    var body: some Scene {
        WindowGroup {
            ContentView(parsedPlaylist: $parsedPlaylist, searchText: $searchText)
        }
    }
}
