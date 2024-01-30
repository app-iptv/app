//
//  SettingsView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 28/01/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @Environment(\.modelContext) var context
    
    @Query var savedPlaylists: [SavedPlaylist]
    
    var body: some View {
        List(savedPlaylists) { playlist in
            DisclosureGroup(" \(playlist.name)") {
                
            }
        }
    }
}
