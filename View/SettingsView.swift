//
//  SettingsView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 28/01/2024.
//

import SwiftUI
import SwiftData
import M3UKit

struct SettingsView: View {
    
    @Environment(\.modelContext) var context
    
    @Query var savedPlaylists: [SavedPlaylist]
    
    @State var isPresented: Bool = false
    
    var isDisabled: Bool {
        if tempPlaylistName == "" {
            return true
        } else if tempPlaylistURL == "" {
            return true
        } else {
            return false
        }
    }
    
    let parser = PlaylistParser()
    
    @State var tempPlaylistName: String = ""
    @State var tempPlaylistURL: String = ""
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
        VStack {
            List(savedPlaylists) { playlist in
                #if targetEnvironment(macCatalyst)
                DisclosureGroup(" \(playlist.name)") {
                    
                }
                #else
                DisclosureGroup(playlist.name) {
                    
                }
                #endif
            }
            .listStyle(.plain)
            HStack {
                Button {
                    isPresented.toggle()
                } label: {
                    Label(
                        title: { Text("Add Playlist") },
                        icon: { Image(systemName: "plus.circle") }
                    )
                }
                .buttonStyle(.borderless)
                Spacer()
            }
            .padding()
        }
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
}

#Preview("Settings View") {
    SettingsView()
}
