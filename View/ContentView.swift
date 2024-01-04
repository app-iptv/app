//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI
import M3UKit

struct ContentView: View {
    
    @Binding var parsedPlaylist: Playlist?
    
    var body: some View {
        TabView {
            TVView(parsedPlaylist: $parsedPlaylist)
                .tabItem {
                    Text("TV")
                    Image(systemName: "tv")
                }

            SettingsView(parsedPlaylist: $parsedPlaylist)
                .tabItem {
                    Text("Settings")
                    #if os(tvOS)
                    #else
                    Image(systemName: "gear")
                    #endif
                }
        }
    }
}
