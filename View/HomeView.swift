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
    
    @Query var savedPlaylists: [SavedPlaylist]
    
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
            return savedPlaylists
        } else {
            return savedPlaylists.filter { $0.name.contains(searchText) }
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
            VStack {
                if savedPlaylists.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Playlists", systemImage: "list.and.film")
                    }, description: {
                        Text("Playlists that you add will appear here.")
                    }, actions: {
                        Button { isPresented.toggle() } label: { Label("Add Playlist", systemImage: "plus") }
                    })
                } else {
                    sidebar
                }
            }
            .toolbar {
                ToolbarItem {
                    Button { isPresented.toggle() } label: { Image(systemName: "plus") }
                }
                ToolbarItem {
                    NavigationLink { SettingsView() } label: { Image(systemName: "gear") }
                }
            }
        } detail: { }
            .alert("Add Playlist", isPresented: $isPresented) {
                TextField("Playlist Name", text: $tempPlaylistName)
                TextField("Playlist URL", text: $tempPlaylistURL)
                
                Button("Add") { addPlaylist() }
                    .disabled(isDisabled)
                
                Button("Cancel", role: .cancel) { }
                
            } message: { Text("Add your playlist details.") }
    }
    
    var sidebar: some View {
        List(searchResults) { playlist in
            NavigationLink {
                List {
                    var mediaSearchResults: [Playlist.Media] {
                        if mediaSearchText == "" {
                            return playlist.playlist?.medias ?? []
                        } else {
                            return playlist.playlist?.medias.filter { $0.name.contains(mediaSearchText) } ?? []
                        }
                    }
                    ForEach(mediaSearchResults, id: \.self) { media in
                        NavigationLink {
                            TVListItem(mediaURL: media.url)
                        } label: {
                            TVListItem(mediaURL: media.url, mediaName: media.name, mediaLogo: media.attributes.logo, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)).buttonCover
                        }
                        .buttonStyle(.plain)
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
            } label: {
                HStack {
                    Text(playlist.name)
                }
            }
            .swipeActions(edge: .trailing) {
                Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
            }
        }
        .navigationTitle("Playlists")
    }
}
