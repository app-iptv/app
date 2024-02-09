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
	
	// MARK: SearchResultsArray
	var searchResults: [SavedPlaylist] {
		if searchText == "" {
			return savedPlaylists
		} else {
			return savedPlaylists.filter { $0.name.contains(searchText) }
		}
	}
	
	let parser = PlaylistParser()
	
	@Binding var isPresented: Bool
	
	@State var selectedSortingOption: SortingOption = .alphabetical
	@State var selectedViewingOption: ViewingOption = .list
	
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
	
	// MARK: BodyNavigationSplitView
	var body: some View {
		VStack {
			if savedPlaylists.isEmpty {
				ContentUnavailableView {
					Label("No Playlists", systemImage: "list.and.film")
				} description: {
					Text("Playlists that you add will appear here.")
				} actions: {
					Button { isPresented.toggle() } label: { Label("Add Playlist", systemImage: "plus") }
				}
				
			} else {
				NavigationSplitView {
					SidebarList(searchResults: searchResults, mediaSearchText: mediaSearchText, selectedGroup: selectedGroup, outerGroups: outerGroups, selectedSortingOption: selectedSortingOption, selectedViewingOption: selectedViewingOption)
						.navigationTitle("Playlists")
						.navigationSplitViewColumnWidth(min: 175, ideal: 200, max: 300)
						.toolbar {
							ToolbarItem(id: "addPlaylist") { Button(action: {isPresented.toggle()}, label: { Image(systemName: "plus") }) }
#if os(iOS)
							ToolbarItem(id: "settings", placement: .navigation) { NavigationLink { SettingsView() } label: { Label("Settings", systemImage: "gear") } }
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
	
	// MARK: ParsePlaylistFunc
	func parsePlaylist() async {
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
	
	
	// MARK: AddPlaylistFunc
	func addPlaylist() {
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
			Label("Error Parsing Playlist", systemImage: "exclamationmark.triangle")
		} description: {
			Text(parserError)
		} actions: {
			Button("Close") { parserDidFail.toggle() }
		}.padding()
	}
}
