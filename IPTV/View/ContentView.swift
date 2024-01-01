//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appSettings = AppSettings()
    
    var body: some View {
        TabView {
            TVView()
                .tabItem {
                    Text("TV")
                    Image(systemName: "tv")
                }

            SettingsView()
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear")
                }
        }
        .environmentObject(appSettings)
    }
}

#Preview {
    ContentView()
}
