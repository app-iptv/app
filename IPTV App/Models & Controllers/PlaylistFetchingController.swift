//
//  PlaylistFetchingController.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 25/04/2024.
//

import Foundation
import M3UKit

@MainActor
@Observable
class PlaylistFetchingController {
	var playlist: Playlist? = nil
	var viewModel: AddPlaylistViewModel
	
	init(viewModel: AddPlaylistViewModel) {
		self.viewModel = viewModel
	}
	
	func parsePlaylist() async {
		let decoder = M3UDecoder()
		
		guard let url = URL(string: viewModel.tempPlaylistURL) else { return catchError(ParserError.invalidURL) }
		
		do {
			async let (data, _) = try URLSession.shared.data(from: url)
			
			let m3u = try await decoder.decode(data)
			
			viewModel.tempPlaylist = m3u
		} catch {
			catchError(error)
		}
	}
	
	func addPlaylistFromFile(data: Data) async {
		let decoder = M3UDecoder()
		
		let m3u = decoder.decode(data)
			
		viewModel.tempPlaylist = m3u
	}
	
	func cancel() {
		viewModel.tempPlaylist  	= nil
		viewModel.tempPlaylistURL 	= ""
		viewModel.tempPlaylistName = ""
		viewModel.tempPlaylistEPG 	= ""
	}
	
	private func catchError(_ error: Error?) {
		viewModel.parserError = error
		viewModel.parserDidFail = true
		viewModel.isParsing = false
	}
}
