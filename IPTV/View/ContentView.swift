//
//  ContentView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI

class AppSettings: ObservableObject {
    @State var IPTVLink = "http://boxdigital.xyz:8080/get.php?username=portenolatino&password=Irf5g4nXop&type=m3u_plus"
}

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
