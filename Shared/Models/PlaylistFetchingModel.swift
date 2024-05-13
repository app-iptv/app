//
//  PlaylistFetchingModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 25/04/2024.
//

import Foundation
import M3UKit

@Observable
class PlaylistFetchingModel {
	var playlist: Playlist? = nil
	var error: Error? = nil
	
	func parsePlaylist() async {
		let decoder = M3UDecoder()
		
		guard let url = URL(string: ViewModel.shared.tempPlaylistURL) else { return catchError(error) }
		
		do {
			let m3u = try decoder.decode(Data(contentsOf: url))
			
			ViewModel.shared.tempPlaylist = m3u
		} catch {
			catchError(error)
		}
		
		func catchError(_ error: Error?) {
			if let desc = error?.localizedDescription { print(desc) }
			ViewModel.shared.parserError = error
			ViewModel.shared.parserDidFail = true
		}
	}
	
	func cancel() {
		ViewModel.shared.tempPlaylist  		= nil
		ViewModel.shared.tempPlaylistURL 	= ""
		ViewModel.shared.tempPlaylistName 	= ""
		ViewModel.shared.tempPlaylistEPG 	= ""
	}
}
