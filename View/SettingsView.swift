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
    
    @Query var parsedPlaylists: [SavedPlaylist]
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        List(parsedPlaylists) { playlist in
            DisclosureGroup(playlist.name, isExpanded: $isExpanded) {
                
            }
        }
    }
}
