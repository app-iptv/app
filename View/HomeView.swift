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
import EmojiPicker

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

    @State var searchText = ""
    @State var mediaSearchText = ""
    
    @State var tempPlaylistName: String = ""
    @State var tempPlaylistURL = ""
    @State var tempPlaylist: Playlist = Playlist(medias: [])
    @State var tempPlaylistEmojiSelection: Emoji? = nil
    
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
            
            context.insert(SavedPlaylist(id: UUID(), name: tempPlaylistName, playlist: tempPlaylist, emoji: tempPlaylistEmojiSelection))
            self.tempPlaylistName = ""
            self.tempPlaylistURL = ""
            self.tempPlaylist = Playlist(medias: [])
            self.tempPlaylistEmojiSelection = nil
            self.isPresented.toggle()
        }
    }
    
    struct AVPlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing

        var videoURL: URL

        private var player: AVPlayer {
            return AVPlayer(url: videoURL)
        }

        func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {

            playerController.player = player
            playerController.player?.play()
        }

        func makeUIViewController(context: Context) -> AVPlayerViewController {
            return AVPlayerViewController()
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
            .sheet(isPresented: $isPresented) {
                alertView
            }
        } else {
            NavigationSplitView {
                sidebar
                    .navigationTitle("Playlists")
                    .toolbar { ToolbarItem(id: "addPlaylist") { Button(action: addPlaylist, label: { Image(systemName: "plus") }).controlSize(.large) } }
            } detail: { }
                .sheet(isPresented: $isPresented) {
                    alertView
                }
        }
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
                    
                    var groups: [String] {
                        var allGroups = Set(mediaSearchResults.compactMap { $0.attributes.groupTitle })
                        allGroups.insert("All")
                        return allGroups.sorted()
                    }
                    
                    var _ = self.outerGroups = groups
                    
                    var filteredMedias: [Playlist.Media] {
                        if selectedGroup == "All" {
                            mediaSearchResults
                        } else {
                            mediaSearchResults.filter { $0.attributes.groupTitle == selectedGroup }
                        }
                    }
                    
                    ForEach(filteredMedias, id: \.self) { media in
                        NavigationLink {
                            AVPlayerView(videoURL: media.url)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: media.attributes.logo!)) { phase in
                                    switch phase {
                                    case .empty:
                                        Image(systemName: "photo")
                                            .frame(width: 60, height: 60)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(5)
                                            .frame(maxWidth: 60, maxHeight: 60)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .frame(width: 60, height: 60)
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
                                
                                /*
                                @State var buttonImageFavorite: String {
                                    if media.isFavorited {
                                        return "star.fill"
                                    } else {
                                        return "star"
                                    }
                                }
                                */
                            }
                            .onAppear { self.outerGroups = groups } // This makes shit really slow. but without it, it wont work
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
                .navigationTitle(playlist.name).contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
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
                    ToolbarItem(id: "settings") { NavigationLink { SettingsView() } label: { Image(systemName: "gear") } }
                    #if !targetEnvironment(macCatalyst)
                    ToolbarItem(id: "editButton") { EditButton() }
                    #endif
                }
            } label: {
                HStack {
                    Text(playlist.emoji?.value ?? "")
                    Text(playlist.name)
                }
            }
            .swipeActions(edge: .trailing) { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
            .contextMenu { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) } }
        }
    }
    
    var alertView: some View {
        VStack {
            #if targetEnvironment(macCatalyst)
            VStack {
                Text("Add Playlist")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    VStack {
                        TextField("Playlist Name", text: $tempPlaylistName)
                        Divider()
                        TextField("Playlist URL", text: $tempPlaylistURL)
                    }
                    EmojiPickerView(selectedEmoji: $tempPlaylistEmojiSelection, searchEnabled: true)
                        .frame(maxHeight: 300)
                }
                HStack(alignment: .center) {
                    Button("Add") { addPlaylist() }
                        .disabled(isDisabled)
                    Button("Cancel") {
                        isPresented.toggle()
                        tempPlaylist = Playlist(medias: [])
                        tempPlaylistURL = ""
                        tempPlaylistName = ""
                        tempPlaylistEmojiSelection = nil
                    }
                }
            }.padding()
            #else
            VStack {
                Text("Add Playlist")
                    .font(.largeTitle)
                    .padding()
                VStack {
                    TextField("Playlist Name", text: $tempPlaylistName)
                    Divider()
                    TextField("Playlist URL", text: $tempPlaylistURL)
                }
                EmojiPickerView(selectedEmoji: $tempPlaylistEmojiSelection, searchEnabled: true)
                    .frame(maxHeight: 300)
                    .padding()
                HStack(alignment: .center) {
                    Button("Add") { addPlaylist() }
                        .disabled(isDisabled)
                    Button("Cancel") {
                        isPresented.toggle()
                        tempPlaylist = Playlist(medias: [])
                        tempPlaylistURL = ""
                        tempPlaylistName = ""
                        tempPlaylistEmojiSelection = nil
                    }
                }
            }
            #endif
        }
    }
}

extension Playlist.Media {
    var isFavorited: Bool {
        return false
    }
}
