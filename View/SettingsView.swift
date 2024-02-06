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
    
    @State var parserDidFail: Bool = false
    @State var parserError: String = ""
    
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
    
    var body: some View {
        Form {
            ForEach(savedPlaylists) { playlist in
                NavigationLink {
                    Text(playlist.name)
                } label: {
                    Text(playlist.name)
                }
                
            }
        }
        .frame(width: 500)
        .padding()
        .toolbar {
            ToolbarItem(id: "addPlaylist") { Button(action: {isPresented.toggle()}, label: { Image(systemName: "plus") }) }
        }
        .sheet(isPresented: $isPresented) {
            addPlaylistView
        }
        .sheet(isPresented: $isPresented) {
            errorSheetView
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
        }.padding().presentationDetents([.height(200)])
    }
    
    // MARK: ErrorSheetView
    var errorSheetView: some View {
        ContentUnavailableView {
            Label("Error Parsing Playlist", systemImage: "exclamationmark.circle.fill")
        } description: {
            Text(parserError)
        } actions: {
            Button("Close") { parserDidFail.toggle() }
        }
    }
}
