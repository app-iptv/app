//
//  SwiftDataCoordinator.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 31/05/2024.
//

import SwiftData
import Foundation

@MainActor
final class SwiftDataCoordinator: NSObject {
	
	static let shared = SwiftDataCoordinator()
	
	let persistenceContainer: ModelContainer = {
		print(URL.applicationSupportDirectory.path(percentEncoded: false))
		let schema = Schema([
			Playlist.self
		])
		
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
	var modelContext: ModelContext {
		persistenceContainer.mainContext
	}
}
