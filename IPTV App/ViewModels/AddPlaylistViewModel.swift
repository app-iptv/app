//
//  AddPlaylistViewModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 08/11/2024.
//

import Foundation
import SwiftData

@MainActor
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
	
	private var networkModel: PlaylistFetchingController {
		PlaylistFetchingController(viewModel: self)
	}
	
	private var context: ModelContext {
		SwiftDataController.main.modelContext
	}
	
	func handleResult(_ result: Result<URL, any Error>) {
		Task {
			do {
				let url = try result.get()
				
				guard url.startAccessingSecurityScopedResource() else {
					// Handle error
					return
				}
				
				let (data, _) = try await URLSession.shared.data(from: url)
				
				fileData = data
				
				url.stopAccessingSecurityScopedResource()
			} catch {
				handleError(error)
			}
		}
	}
	
	func addPlaylistFromURL() async {
		await networkModel.parsePlaylist()
		
		guard parserError == nil else { return }
		
		context.insert(playlist)
		
		networkModel.cancel()
	}
	
	func cancel() {
		networkModel.cancel()
	}
	
	func handleError(_ error: Error?) {
		parserError = error
		parserDidFail = true
	}
	
	func addPlaylist(with data: Data?) async {
		guard let data else { await addPlaylistFromURL(); return }
		
		await networkModel.addPlaylistFromFile(data: data)
		
		guard parserError == nil else { return }
		
		context.insert(playlist)
		networkModel.cancel()
	}
}
