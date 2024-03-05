//
//  ViewModel.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 12/02/2024.
//

import Foundation
import M3UKit
import SwiftUI
import Combine

class ViewModel: ObservableObject {
	@Published var selectedGroup: String = "All"
	
	@Published var mediaSearchText: String = ""
	
	@Published var tempPlaylistName: String = ""
	@Published var tempPlaylistURL: String = ""
	@Published var tempPlaylist: Playlist = Playlist(medias: [])
	
	@Published var parserDidFail: Bool = false
	@Published var parserError: String = ""
	@Published var isPresented: Bool = false
	
	@Published var selectedPlaylist: SavedPlaylist? = nil
	@Published var selectedMedia: Playlist.Media? = nil
}
