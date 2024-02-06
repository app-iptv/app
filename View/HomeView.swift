//
//  HomeView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import SwiftData

// MARK: HomeView
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
    
    @State var outerGroups: [String] = []
    @State var selectedGroup: String = "All"

    @State var searchText: String = ""
    @State var mediaSearchText: String = ""
    
    @State var tempPlaylistName: String = ""
    @State var tempPlaylistURL: String = ""
    @State var tempPlaylist: Playlist = Playlist(medias: [])
    
    @State var playerPresented: Bool = false
    
    @State var parserDidFail: Bool = false
    @State var parserError: String = ""

    // MARK: NavigationSplitView
    var body: some View {
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
                NavigationSplitView {
                    sidebar
                        .navigationTitle("Playlists")
                        .toolbar {
                            ToolbarItem(id: "addPlaylist") { Button(action: {isPresented.toggle()}, label: { Image(systemName: "plus") }) }
                            #if os(iOS)
                            ToolbarItem(placement: .navigation) { NavigationLink { SettingsView() } label: { Label("Settings", systemImage: "gear") } }
                            #endif
                        }
                } detail: { }
                
            }
        }
        .sheet(isPresented: $isPresented) {
            addPlaylistView
        }
        .sheet(isPresented: $parserDidFail) {
            errorSheetView
        }
    }
    
    // MARK: Sidebar
    var sidebar: some View {
        List(searchResults) { playlist in
            
            // MARK: PlaylistItem
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
                    
                    // MARK: MediaItem
                    ForEach(filteredMedias, id: \.self) { media in
                        NavigationLink {
                            PlayerView(videoURL: media.url)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(5)
                                            .frame(maxWidth: 60, maxHeight: 60)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .frame(width: 60, height: 60)
                                    }
                                }
                                .frame(width: 60, height: 60)
                                Text(media.name)
                                    .font(.headline)
                                Spacer()
                                Text(media.attributes.groupTitle ?? "")
                                Text(media.attributes.channelNumber ?? "")
                            }
                            .onAppear { self.outerGroups = groups } // This makes shit really slow. but without it, it wont work
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            ShareLink(item: media.url)
                        }
                        .swipeActions(edge: .leading) { ShareLink(item: media.url) }
                    }
                    .onDelete { playlist.playlist?.medias.remove(atOffsets: $0) }
                    .onMove { playlist.playlist?.medias.move(fromOffsets: $0, toOffset: $1) }
                }
                .listStyle(.plain)
                .searchable(text: $mediaSearchText, prompt: "Search Streams")
                .navigationTitle(playlist.name)
                .toolbarRole(.editor)
                .toolbar(id: "playlistToolbar") {
                    ToolbarItem(id: "groupPicker") {
                        Picker("Select Groups", selection: $selectedGroup) {
                            ForEach(outerGroups, id: \.self) { group in
                                if group == "All" {
                                    Label(group, systemImage: "tray.full").tag(group)
                                } else {
                                    Text(group).tag(group)
                                }
                            }
                        }.pickerStyle(.menu)
                    }
                    #if !os(macOS)
                    ToolbarItem(id: "editButton") { EditButton() }
                    #endif
                }
            } label: {
                Text(playlist.name)
            }
            .swipeActions(edge: .trailing) { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
            .contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
        }
    }
    
    public func parsePlaylist() async {
        print("Parsing Playlist...")
        await withCheckedContinuation { continuation in
            parser.parse(URL(string: tempPlaylistURL)!) { result in
                switch result {
                case .success(let playlist):
                    print("Success")
                    self.tempPlaylist = playlist
                    self.parserDidFail = false
                    continuation.resume()
                case .failure(let error):
                    print("Error: \(error)")
                    self.parserError = "\(error)"
                    self.parserDidFail = true
                    continuation.resume()
                }
            }
        }
    }
    
    public func addPlaylist() {
        Task {
            await parsePlaylist()
            
            if parserDidFail {
                self.tempPlaylistName = ""
                self.tempPlaylistURL = ""
                self.tempPlaylist = Playlist(medias: [])
                self.isPresented.toggle()
            } else {
                context.insert(SavedPlaylist(id: UUID(), name: tempPlaylistName, playlist: tempPlaylist))
                self.tempPlaylistName = ""
                self.tempPlaylistURL = ""
                self.tempPlaylist = Playlist(medias: [])
                self.isPresented.toggle()
            }
        }
    }
    
    // MARK: AlertSheetView
    var addPlaylistView: some View {
        VStack {
            Text("Add Playlist")
                .font(.largeTitle)
                .bold()
                .padding()
            
            VStack {
                TextField("Playlist Name", text: $tempPlaylistName)
                Divider()
                TextField("Playlist URL", text: $tempPlaylistURL)
            }
            
            HStack(alignment: .center) {
                Button("Add") {
                    addPlaylist()
                }.disabled(isDisabled).buttonStyle(.borderedProminent)
                
                Spacer().frame(width: 20)
                
                Button("Cancel") {
                    isPresented.toggle()
                    tempPlaylist = Playlist(medias: [])
                    tempPlaylistURL = ""
                    tempPlaylistName = ""
                }
            }.padding()
        }.padding().presentationDetents([.medium, .large])
    }
    
    // MARK: ErrorSheetView
    var errorSheetView: some View {
        ContentUnavailableView {
            Label("Error Parsing Playlist", systemImage: "exclamationmark.circle.fill")
        } description: {
            Text(parserError)
        } actions: {
            Button("Close") { parserDidFail.toggle() }
        } .padding()
    }
}
