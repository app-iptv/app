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
    
    var isDisabled: Bool {
        if tempPlaylistName == "" {
            return true
        } else if tempPlaylistURL == "" {
            return true
        } else {
            return false
        }
    }

    var searchResults: [SavedPlaylist] {
        if searchText == "" {
            return parsedPlaylists
        } else {
            return parsedPlaylists.filter { $0.name.contains(searchText) }
        }
    }

    let parser = PlaylistParser()
    
    @State var isPresented: Bool = false
    
    @State var searchText = ""
    @State var mediaSearchText = ""
    
    @State var tempPlaylistName: String = ""
    @State var tempPlaylistURL = ""
    @State var tempPlaylist: Playlist = Playlist(medias: [])
    
    func parsePlaylist() async {
        print("Parsing Playlist...")
        await withCheckedContinuation { continuation in
            parser.parse(URL(string: tempPlaylistURL)!) { result in
                switch result {
                case .success(let playlist):
                    print("Success")
                    self.tempPlaylist = playlist
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
            context.insert(SavedPlaylist(id: UUID(), name: tempPlaylistName, playlist: tempPlaylist))
            self.tempPlaylistName = ""
            self.tempPlaylistURL = ""
            self.tempPlaylist = Playlist(medias: [])
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
        List(searchResults) { playlist in
            NavigationLink(playlist.name) {
                List {
                    var mediaSearchResults: [Playlist.Media] {
                        if mediaSearchText == "" {
                            return playlist.playlist?.medias ?? []
                        } else {
                            return playlist.playlist?.medias.filter { $0.name.contains(mediaSearchText) } ?? []
                        }
                    }
                    ForEach(mediaSearchResults, id: \.self) { media in
                        TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                            .contextMenu { ShareLink(item: media.url) }
                            .swipeActions(edge: .leading) { ShareLink(item: media.url) }
                    }
                    .onDelete { playlist.playlist?.medias.remove(atOffsets: $0) }
                    .onMove { playlist.playlist?.medias.move(fromOffsets: $0, toOffset: $1) }
                }
                .listStyle(.plain)
                .searchable(text: $mediaSearchText, prompt: "Search Streams")
                .navigationTitle(playlist.name)
                .toolbar { EditButton() }
            }
            .swipeActions {
                Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
            }
        }
        .navigationTitle("Playlists")
        .alert("Add Playlist", isPresented: $isPresented) {
            TextField("Playlist Name", text: $tempPlaylistName)
            TextField("Playlist URL", text: $tempPlaylistURL)
            
            Button("Add") { addPlaylist() }
                .disabled(isDisabled)
            
            Button("Cancel", role: .cancel) { }
            
        } message: { Text("Add your playlist details.") }
        .toolbar { ToolbarItem(id: "ADD_BUTTON", placement: .primaryAction) { Button { isPresented.toggle() } label: { Image(systemName: "plus") } } }
    }
}
