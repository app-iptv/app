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
    
    @Binding var searchText: String
    
    var body: some View {
        #if targetEnvironment(macCatalyst)
        TVView(parsedPlaylist: $parsedPlaylist, searchText: $searchText)
        #else
        TabView {
            TVView(parsedPlaylist: $parsedPlaylist, searchText: $searchText)
                .tabItem {
                    Text("TV")
                    Image(systemName: "tv")
                }

            SettingsView(parsedPlaylist: $parsedPlaylist)
                .tabItem {
                    #if os(tvOS)
                    Image(systemName: "gear")
                    #else
                    Text("Settings")
                    Image(systemName: "gear")
                    #endif
                }
        }
        #endif
    }
}
