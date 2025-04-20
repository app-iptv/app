//
//  AddPlaylistViewModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 08/11/2024.
//

import Foundation

@Observable
class AddPlaylistViewModel {
	var playlist: Playlist = Playlist("", medias: [], m3uLink: "", epgLink: "")
	
	var isParsing: Bool = false
	var parserError: Error? = nil
	var parserDidFail: Bool = false
	
	var isAddingFile: Bool = false
	var addedFromFile: Bool = false
	var fileData: Data? = nil
	var fileName: String = ""
	
	func handleResult(_ result: Result<URL, any Error>) async throws {
		let url = try result.get()
		
		guard url.startAccessingSecurityScopedResource() else {
			// Handle error
			return
		}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		
		fileData = data
		
		url.stopAccessingSecurityScopedResource()
	}
	
	func handleError(_ error: Error?) {
		parserError = error
		parserDidFail = true
	}
}
