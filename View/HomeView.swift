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
	
	@State var isParsing: Bool = false
	
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
	
	@State var selectedSortingOption: SortingOption = .normal
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
	
	// MARK: ParsePlaylistFunc
	func parsePlaylist() async {
		print("Parsing Playlist...")
		await withCheckedContinuation { continuation in
			isParsing.toggle()
			isPresented.toggle()
			parser.parse(URL(string: tempPlaylistURL)!) { result in
				switch result {
					case .success(let playlist):
						print("Success")
						self.tempPlaylist = playlist
						self.parserDidFail = false
						continuation.resume()
					case .failure(let error):
						print("Error: \(error)")
						self.parserError = "\(error.localizedDescription)"
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
			
			isParsing.toggle()
			
			if parserDidFail {
				self.tempPlaylistName = ""
				self.tempPlaylistURL = ""
				self.tempPlaylist = Playlist(medias: [])
			} else {
				context.insert(SavedPlaylist(id: UUID(), name: tempPlaylistName, playlist: tempPlaylist, m3uLink: tempPlaylistURL))
				self.tempPlaylistName = ""
				self.tempPlaylistURL = ""
				self.tempPlaylist = Playlist(medias: [])
			}
		}
	}
	
	// MARK: BodyNavigationSplitView
	var body: some View {
		if isParsing {
			isParsingView
		} else if isPresented {
			addPlaylistView
		} else if parserDidFail {
			errorSheetView
		} else if savedPlaylists.isEmpty {
			ContentUnavailableView {
				Label("No Playlists", systemImage: "list.and.film")
			} description: {
				Text("Playlists that you add will appear here.")
			} actions: {
				Button { isPresented.toggle() } label: { Label("Add Playlist", systemImage: "plus") }
			}
			
		} else {
			#if os(macOS)
			NavigationStack {
				List(searchResults) { playlist in
					PlaylistRow(playlist: playlist, mediaSearchText: $mediaSearchText, selectedGroup: $selectedGroup, outerGroups: $outerGroups, selectedSortingOption: $selectedSortingOption)
				}
				.navigationDestination(for: SavedPlaylist.self) { playlist in
					var mediaSearchResults: [Playlist.Media] {
						if mediaSearchText == "" {
							return playlist.playlist?.medias ?? []
						} else {
							return playlist.playlist?.medias.filter { $0.name.lowercased().contains(mediaSearchText.lowercased()) } ?? []
						}
					}
					
					var groups: [String] {
						var allGroups = Set(mediaSearchResults.compactMap { $0.attributes.groupTitle })
						allGroups.insert("All")
						return allGroups.sorted()
					}
					
					var sortedMedias: [Playlist.Media] {
						switch selectedSortingOption {
							case .country:
								return mediaSearchResults.sorted { $0.attributes.country ?? "Z" < $1.attributes.country ?? "Z" }
							case .alphabetical:
								return mediaSearchResults.sorted { $0.name < $1.name }
							case .language:
								return mediaSearchResults.sorted { $0.attributes.language ?? "Z" < $1.attributes.language ?? "Z" }
							case .kind:
								return mediaSearchResults.sorted { $0.attributes.groupTitle ?? "Z" < $1.attributes.groupTitle ?? "Z" }
							case .normal:
								return mediaSearchResults
						}
					}
					
					var filteredMedias: [Playlist.Media] {
						if selectedGroup == "All" {
							sortedMedias
						} else {
							sortedMedias.filter { $0.attributes.groupTitle == selectedGroup }
						}
					}
					
					List(filteredMedias, id: \.self) { media in
						
						// MARK: MediaItem
						MediaRow(media: media, navigationTitle: playlist.name, playlistName: playlist.name)
							.buttonStyle(.plain)
							.contextMenu {
								ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? ""))
							}
							.swipeActions(edge: .leading) {
								ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? ""))
							}
					}
					.navigationDestination(for: Playlist.Media.self) { media in
						PlayerView(playlistName: playlist.name, media: media)
#if os(macOS)
							.navigationTitle(playlist.name)
							.navigationSubtitle(media.name)
#else
							.navigationTitle(media.name)
							.navigationBarTitleDisplayMode(.inline)
#endif
					}
					.id(mediaSearchText)
					.navigationSplitViewColumnWidth(min: 200, ideal: 150, max: 300)
					.navigationTitle(playlist.name)
					.listStyle(.plain)
					.searchable(text: $mediaSearchText, prompt: "Search Streams")
					.onAppear { self.outerGroups = groups }
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
						ToolbarItem(id: "sortingOptionsPicker") {
							Picker("Sort", selection: $selectedSortingOption) {
								ForEach(SortingOption.allCases) { option in
									option.label
										.tag(option)
								}
							}.pickerStyle(.segmented)
						}
#if !os(macOS)
						ToolbarItem(id: "editButton") { EditButton() }
#endif
					}
				}
				.listStyle(.sidebar)
				.navigationTitle("Playlists")
				.navigationSplitViewColumnWidth(min: 175, ideal: 200, max: 300)
				.toolbar {
					ToolbarItem(id: "addPlaylist") { Button("Add Playlist", systemImage: "plus") { isPresented.toggle() } }
				}
			}
			#else
			NavigationStack {
				List(searchResults) { playlist in
					PlaylistRow(playlist: playlist, mediaSearchText: $mediaSearchText, selectedGroup: $selectedGroup, outerGroups: $outerGroups, selectedSortingOption: $selectedSortingOption)
				}
				.navigationDestination(for: SavedPlaylist.self) { playlist in
					var mediaSearchResults: [Playlist.Media] {
						if mediaSearchText == "" {
							return playlist.playlist?.medias ?? []
						} else {
							return playlist.playlist?.medias.filter { $0.name.lowercased().contains(mediaSearchText.lowercased()) } ?? []
						}
					}
					
					var groups: [String] {
						var allGroups = Set(mediaSearchResults.compactMap { $0.attributes.groupTitle })
						allGroups.insert("All")
						return allGroups.sorted()
					}
					
					var sortedMedias: [Playlist.Media] {
						switch selectedSortingOption {
							case .country:
								return mediaSearchResults.sorted { $0.attributes.country ?? "Z" < $1.attributes.country ?? "Z" }
							case .alphabetical:
								return mediaSearchResults.sorted { $0.name < $1.name }
							case .language:
								return mediaSearchResults.sorted { $0.attributes.language ?? "Z" < $1.attributes.language ?? "Z" }
							case .kind:
								return mediaSearchResults.sorted { $0.attributes.groupTitle ?? "Z" < $1.attributes.groupTitle ?? "Z" }
							case .normal:
								return mediaSearchResults
						}
					}
					
					var filteredMedias: [Playlist.Media] {
						if selectedGroup == "All" {
							sortedMedias
						} else {
							sortedMedias.filter { $0.attributes.groupTitle == selectedGroup }
						}
					}
					
					List(filteredMedias, id: \.self) { media in
						
						// MARK: MediaItem
						MediaRow(media: media, navigationTitle: playlist.name, playlistName: playlist.name)
							.buttonStyle(.plain)
							.contextMenu {
								ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? ""))
							}
							.swipeActions(edge: .leading) {
								ShareLink(item: media.url, preview: SharePreview(media.name, image: media.attributes.logo ?? ""))
							}
					}
					.navigationDestination(for: Playlist.Media.self) { media in
						PlayerView(playlistName: playlist.name, media: media)
#if os(macOS)
							.navigationTitle(playlistName)
							.navigationSubtitle(media.name)
#else
							.navigationTitle(media.name)
							.navigationBarTitleDisplayMode(.inline)
#endif
					}
					.id(mediaSearchText)
					.navigationSplitViewColumnWidth(min: 200, ideal: 150, max: 300)
					.navigationTitle(playlist.name)
					.listStyle(.plain)
					.searchable(text: $mediaSearchText, prompt: "Search Streams")
					.onAppear { self.outerGroups = groups }
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
						ToolbarItem(id: "sortingOptionsPicker") {
							Picker("Sort", selection: $selectedSortingOption) {
								ForEach(SortingOption.allCases) { option in
									option.label
										.tag(option)
								}
							}.pickerStyle(.segmented)
						}
						#if !os(macOS)
						ToolbarItem(id: "editButton") { EditButton() }
						#endif
					}
				}
				.listStyle(.sidebar)
				.navigationTitle("Playlists")
				.navigationSplitViewColumnWidth(min: 175, ideal: 200, max: 300)
				.toolbar {
					ToolbarItem(id: "addPlaylist") { Button("Add Playlist", systemImage: "plus") { isPresented.toggle() } }
				}
			}
			#endif
		}
	}
	
	// MARK: AddPlaylistView
	var addPlaylistView: some View {
		VStack {
			Text("Add Playlist")
				.font(.largeTitle)
				.bold()
				.padding()
			
			VStack {
				TextField("Playlist Name", text: $tempPlaylistName)
					.textFieldStyle(.roundedBorder)
				TextField("Playlist URL", text: $tempPlaylistURL)
					.textFieldStyle(.roundedBorder)
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
		}
		#if os(macOS)
		.frame(width: 200, height: 300)
		#endif
		.padding()
	}
	
	// MARK: ErrorSheetView
	var errorSheetView: some View {
		ContentUnavailableView {
			Label("Error", systemImage: "exclamationmark.triangle")
		} description: {
			Text(parserError)
		} actions: {
			Button("Close") { parserDidFail.toggle() }
		}
		#if os(macOS)
		.frame(width: 200, height: 300)
		#endif
		.padding()
	}
	
	// MARK: IsParsingView
	var isParsingView: some View {
		ZStack {
			Rectangle()
				.fill(.black)
				.opacity(0.75)
				.ignoresSafeArea()
			
			VStack(spacing: 20) {
				ProgressView()
				Text("Adding playlist...")
			}
			.background {
				RoundedRectangle(cornerRadius: 20)
					.fill(.white)
					.frame(width: 200, height: 200)
			}
		}
	}
}
