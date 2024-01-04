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
        NavigationView {
            List {
                Section {
                    TextField("M3U Playlist", text: $playlistToParse)
                    HStack {
                        Button {
                            parsePlaylist()
                        } label: {
                            Label {
                                Text("Parse Playlist")
                            } icon: {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                        .buttonStyle(.bordered)
                        #if DEBUG
                        Spacer()
                        Button {
                            print(parsedPlaylist)
                        } label: {
                            Label {
                                Text("Print Playlist")
                            } icon: {
                                Image(systemName: "printer")
                            }
                        }
                        .buttonStyle(.bordered)
                        #endif
                    }
                } header: {
                     Text("M3U Settings")
                }
            }
        }
    }
}
