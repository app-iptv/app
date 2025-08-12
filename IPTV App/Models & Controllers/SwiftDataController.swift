//
//  SwiftDataController.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 31/05/2024.
//

import SwiftData
import Foundation

@MainActor
final class SwiftDataController {
	init() { }
	
	let persistenceContainer: ModelContainer = {
		print(URL.applicationSupportDirectory.path(percentEncoded: false))
		let schema = Schema([Playlist.self])
		
		let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [config])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
//	let previewContainer: ModelContainer = {
//		do {
//			let schema = Schema([Playlist.self])
//			
//			let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
//			
//			let container = try ModelContainer(for: schema, configurations: [config])
//			container.mainContext.insert(Playlist.preview)
//			
//			return container
//		} catch {
//			fatalError("Could not create preview container: \(error)")
//		}
//	}()
	
	var modelContext: ModelContext { persistenceContainer.mainContext }
	
	static let main = SwiftDataController()
}
