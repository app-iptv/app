//
//  TVView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import AZVideoPlayer

struct TVView: View {
    
    enum SidebarItem: String, CaseIterable {
        case live, series, movies, unknown
        
        var name: String {
            switch self {
            case .live: return "Live TV"
            case .series: return "TV Shows"
            case .movies: return "Movies"
            case .unknown: return "Unknown"
            }
        }
        
        var iconName: String {
            switch self {
            case .live: return "tv"
            case .series: return "play.rectangle"
            case .movies: return "movieclapper"
            case .unknown: return "questionmark"
            }
        }
    }
    
    @State var sidebarSelection: SidebarItem?
    
    @Binding var parsedPlaylist: Playlist?
    
    @Binding var searchText: String
    
    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, id: \.self, selection: $sidebarSelection) { item in
                Label(
                    title: { Text(item.name) },
                    icon: { Image(systemName: item.iconName) }
                )
            }
            .listStyle(.sidebar)
            .navigationTitle("Stream Kind")
            #if targetEnvironment(macCatalyst)
            HStack {
                NavigationLink {
                    SettingsView(parsedPlaylist: $parsedPlaylist)
                } label: {
                    Image(systemName: "gear")
                }
                .buttonStyle(.borderless)
                .padding()
                Spacer()
            }
            #endif
        } detail: {
            switch sidebarSelection {
            case .live:
                TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).live
                    .searchable(text: $searchText, prompt: "Search Streams")
            case .series:
                TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).series
                    .searchable(text: $searchText, prompt: "Search Streams")
            case .movies:
                TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).movies
                    .searchable(text: $searchText, prompt: "Search Streams")
            case .unknown:
                TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).unknown
                    .searchable(text: $searchText, prompt: "Search Streams")
            case nil:
                ContentUnavailableView {
                    Label("Select Media Type", systemImage: "tv")
                } description: {
                    Text("Once you select the media type, you can enjoy your selected content.")
                }
            }
        }
    }
}
