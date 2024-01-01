//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TVView()
                .tabItem { Label(
                    title: { Text("TV") },
                    icon: { Image(systemName: "play.tv") }
                ) }
            FavoritesView()
                .tabItem { Label(
                    title: { Text("Favorites") },
                    icon: { Image(systemName: "star") }
                ) }
            SettingsView()
                .tabItem { Image(systemName: "gear") }
        }
    }
}

#Preview {
    ContentView()
}
