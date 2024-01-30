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
    
    @State var selectedGroup: String = ""
    
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
            
            context.insert(SavedPlaylist(id: UUID(), name: tempPlaylistName, playlist: tempPlaylist))
            self.tempPlaylistName = ""
            self.tempPlaylistURL = ""
            self.tempPlaylist = Playlist(medias: [])
        }
    }
    
    var body: some View {
        if savedPlaylists.isEmpty {
            ContentUnavailableView(label: {
                Label("No Playlists", systemImage: "list.and.film")
            }, description: {
                Text("Playlists that you add will appear here.")
            }, actions: {
                Button { isPresented.toggle() } label: { Label("Add Playlist", systemImage: "plus") }
            })
            .alert("Add Playlist", isPresented: $isPresented) {
                TextField("Playlist Name", text: $tempPlaylistName)
                TextField("Playlist URL", text: $tempPlaylistURL)
                
                Button("Add") { addPlaylist() }
                    .disabled(isDisabled)
                
                Button("Cancel", role: .cancel) {
                    tempPlaylist = Playlist(medias: [])
                    tempPlaylistURL = ""
                    tempPlaylistName = ""
                }
            } message: { Text("Add your playlist details.") }
        } else {
            NavigationSplitView {
                sidebar
                    .navigationTitle("Playlists")
            } detail: { }
                .alert("Add Playlist", isPresented: $isPresented) {
                    TextField("Playlist Name", text: $tempPlaylistName)
                    TextField("Playlist URL", text: $tempPlaylistURL)
                    
                    Button("Add") { addPlaylist() }
                        .disabled(isDisabled)
                    
                    Button("Cancel", role: .cancel) {
                        tempPlaylist = Playlist(medias: [])
                        tempPlaylistURL = ""
                        tempPlaylistName = ""
                    }
                } message: { Text("Add your playlist details.") }
        }
        
        // Deprecated:
        
        /*
        NavigationSplitView {
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
                    .navigationTitle("Playlists")
                    .toolbarRole(.editor)
                    .toolbar {
                        ToolbarItem {
                            Button { isPresented.toggle() } label: { Image(systemName: "plus") }
                        }
                        ToolbarItem {
                            NavigationLink { SettingsView() } label: { Image(systemName: "gear") }
                        }
                    }
            }
        } detail: { }
            .alert("Add Playlist", isPresented: $isPresented) {
                TextField("Playlist Name", text: $tempPlaylistName)
                TextField("Playlist URL", text: $tempPlaylistURL)
                
                Button("Add") { addPlaylist() }
                    .disabled(isDisabled)
                
                Button("Cancel", role: .cancel) {
                    tempPlaylist = Playlist(medias: [])
                    tempPlaylistURL = ""
                    tempPlaylistName = ""
                }
                
            } message: { Text("Add your playlist details.") }
        */
    }
    
    @State var outerGroups: [String] = [""]
    
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
                    
                    var groups: [String] {
                        var allGroups = Set(mediaSearchResults.compactMap { $0.attributes.groupTitle })
                        allGroups.insert("All")
                        return allGroups.sorted()
                    }
                    
                    var filteredMedias: [Playlist.Media] {
                        if selectedGroup == "All" {
                            mediaSearchResults
                        } else {
                            mediaSearchResults.filter { $0.attributes.groupTitle == selectedGroup }
                        }
                    }
                    
                    let _ = outerGroups = groups
                    
                    ForEach(filteredMedias, id: \.self) { media in
                        let tvListItem = TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        NavigationLink { tvListItem } label: { tvListItem.buttonCover }
                            .buttonStyle(.plain)
                            .contextMenu { ShareLink(item: media.url) }
                            .swipeActions(edge: .leading) { ShareLink(item: media.url) }
                    }
                    .onDelete { playlist.playlist?.medias.remove(atOffsets: $0) }
                    .onMove { playlist.playlist?.medias.move(fromOffsets: $0, toOffset: $1) }
                }
                .listStyle(.plain)
                .searchable(text: $mediaSearchText, prompt: "Search Streams")
                .navigationTitle(playlist.name).contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
                .toolbarRole(.editor)
                .toolbar(id: "playlistToolbar") {
                    ToolbarItem(id: "Picker") {
                        Picker("Select Group", selection: $selectedGroup) {
                            ForEach(outerGroups, id: \.self) { group in
                                if group == "All" {
                                    Label {
                                        Text(group)
                                    } icon: {
                                        Image(systemName: "tray.full")
                                    }
                                    .labelStyle(.titleAndIcon)
                                    .tag(group)
                                } else {
                                    Text(group).tag(group)
                                }
                            }
                        }
                    }
                    ToolbarItem(id: "addPlaylist") { Button { isPresented.toggle() } label: { Image(systemName: "plus") } }
                    ToolbarItem(id: "settings") { NavigationLink { SettingsView() } label: { Image(systemName: "gear") } }
                    #if targetEnvironment(macCatalyst)
                    #else
                    ToolbarItem(id: "editButton") { EditButton() }
                    #endif
                }
            } label: {
                HStack {
                    Text(playlist.name)
                }
            }
            .swipeActions(edge: .trailing) { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
            .contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
        }
    }
}
