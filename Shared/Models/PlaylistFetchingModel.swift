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
	var vm: ViewModel
	
	init(vm: ViewModel) {
		self.vm = vm
	}
	
	func parsePlaylist() async {
		let decoder = M3UDecoder()
		
		guard let url = URL(string: vm.tempPlaylistURL) else { return catchError(error) }
		
		do {
			async let (data, _) = try URLSession.shared.data(from: url)
			
			let m3u = try await decoder.decode(data)
			
			vm.tempPlaylist = m3u
		} catch {
			catchError(error)
		}
	}
	
	func cancel() {
		vm.tempPlaylist  	= nil
		vm.tempPlaylistURL 	= ""
		vm.tempPlaylistName = ""
		vm.tempPlaylistEPG 	= ""
	}
	
	private func catchError(_ error: Error?) {
		#if DEBUG
		if let desc = error?.localizedDescription { print(desc) }
		#endif
		vm.parserError = error
		vm.parserDidFail = true
	}
}
