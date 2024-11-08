//
//  AddPlaylistViewModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 08/11/2024.
//

import Foundation

@Observable
class AddPlaylistViewModel {
	var tempPlaylistName: String = ""
	var tempPlaylistURL: String = ""
	var tempPlaylistEPG: String = ""
	var tempPlaylist: PlData? = nil
	
	var isParsing: Bool = false
	var parserError: Error? = nil
	var parserDidFail: Bool = false
}
