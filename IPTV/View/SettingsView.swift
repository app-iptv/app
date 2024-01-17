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
    
    @State var playlistToParse = "https://iptv-org.github.io/iptv/countries/pt.m3u"
    
    let parser = PlaylistParser()

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
            Section {
                HStack {
                    TextField("M3U Playlist", text: $playlistToParse)
                    Button {
                        parsePlaylist()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered
                    )
                }
            } header: {
                Text("M3U Settings")
            }
        }
        .listStyle(.plain)
        .navigationTitle("Setttings")
    }
}
