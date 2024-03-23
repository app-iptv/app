//
//  ViewModel.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 12/02/2024.
//

import SwiftUI
import M3UKit
import Observation

@Observable
class ViewModel {
	var selectedGroup: String = "All"
	var mediaSearchText: String = ""
	
	var tempPlaylistName: String = ""
	var tempPlaylistURL: String = ""
	var tempPlaylist: Playlist = Playlist(medias: [])
	
	var parserDidFail: Bool = false
	var parserError: String = ""
	var isParsing: Bool = false
	
	var isPresented: Bool = false
	var openedSingleStream: Bool = false
	
	var selectedPlaylist: ModelPlaylist? = nil
	var selectedMedia: Playlist.Media? = nil
}
