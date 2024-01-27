//
//  HomeView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import AZVideoPlayer
import SwiftData

struct HomeView: View {

    @Environment(\.modelContext) var context
    
    @Query var parsedPlaylists: [SavedPlaylist]
    
    let parser = PlaylistParser()
    
    @State var isPresented: Bool = false
    
    @State var playlistToParse = ""
    
    @State var searchText = ""
    
    @State var tempParsedPlaylist: Playlist = Playlist(medias: [])
    @State var tempPlaylistName: String = ""
    
    func parsePlaylist() async {
        print("Parsing Playlist...")
        await withCheckedContinuation { continuation in
            parser.parse(URL(string: playlistToParse)!) { result in
                switch result {
                case .success(let playlist):
                    print("Success")
                    self.tempParsedPlaylist = playlist
                    continuation.resume()
                case .failure(let error):
                    print("Error: \(error)")
                    continuation.resume()
                }
            }
        }
    }

    func addPlaylist() {
        Task {
            await parsePlaylist()
            // This code runs after parsePlaylist is complete
            
            context.insert(SavedPlaylist(id: UUID(), name: tempPlaylistName, playlist: tempParsedPlaylist))
            self.tempPlaylistName = ""
            self.tempParsedPlaylist = Playlist(medias: [])
            isPresented.toggle()
        }
    }
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            ContentUnavailableView("Select Playlist", systemImage: "tv")
        } detail: {
            ContentUnavailableView("Select Media", systemImage: "movieclapper")
        }
    }
    
    var sidebar: some View {
        List {
            ForEach(parsedPlaylists) { playlist in
                NavigationLink(playlist.name) {
                    List {
                        
                        var searchResults: [Playlist.Media] {
                            if searchText == "" {
                                return playlist.playlist?.medias ?? []
                            } else {
                                return playlist.playlist?.medias.filter { $0.name.contains(searchText) } ?? []
                            }
                        }
                        
                        ForEach(searchResults, id: \.self) { media in
                            TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        }
                        .onDelete { playlist.playlist?.medias.remove(atOffsets: $0) }
                        .onMove { playlist.playlist?.medias.move(fromOffsets: $0, toOffset: $1) }
                    }
                    .searchable(text: $searchText, prompt: "Search Streams")
                    .navigationTitle("Streams")
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        context.delete(playlist)
                    }
                }
            }
        }
        .navigationTitle("Playlists")
        .sheet(isPresented: $isPresented) {
            Form {
                TextField("Playlist Name", text: $tempPlaylistName)
                TextField("Playlist URL", text: $playlistToParse)
                
                Button {
                    addPlaylist()
                } label: {
                    Label("Add Playlist", systemImage: "plus")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
