//
//  SettingsView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import M3UKit
import Foundation

struct SettingsView: View {
    
    let parser = PlaylistParser()
    
    @State var playlistToParse = ""

    @Binding var parsedPlaylist: Playlist?
    
    func parsePlaylist() {
        print("Parsing Playlist...")
        parser.parse(URL(string: playlistToParse)!) { result in
            switch result {
            case .success(let playlist):
                print("Success")
                self.parsedPlaylist = playlist
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("M3U Settings")) {
                HStack {
                    TextField("M3U Playlist", text: $playlistToParse)
                    Button {
                        parsePlaylist()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Setttings")
    }
}
