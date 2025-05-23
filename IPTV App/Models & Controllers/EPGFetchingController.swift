//
//  EPGFetchingController.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 28/04/2024.
//

import Foundation
import XMLTV
import SWCompression
import SwiftUI
import SwiftData

@MainActor
@Observable
class EPGFetchingController {
	var id: UUID
	var xmlTV: XMLTV? = nil
	
	init() { id = UUID() }
	
	func load(epg: String? = nil, appState: AppState? = nil) async {
		id = UUID()
		
		guard let epg, let appState else { return }
		
		appState.isLoadingEPG = true
		
		do {
			xmlTV = try await getPrograms(with: epg)
		} catch {
			dump(error)
		}
		
		appState.isLoadingEPG = false
	}
	
	func getData(from link: String) async throws -> (Data, URLResponse) {
		guard let url = URL(string: link) else {
			#if DEBUG
			print("Invalid url")
			#endif
			throw DataFetchingError.invalidURL
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		return (data, response)
	}
	
	func getPrograms(with link: String) async throws -> XMLTV {
		let (data, response) = try await getData(from: link)
		
		var extractedData: Data
		
		let fileType = response.url?.pathExtension
		
		switch fileType {
			case "xz":
				extractedData = try XZArchive.unarchive(archive: data)
			case "gz":
				extractedData = try GzipArchive.unarchive(archive: data)
			case "zlib":
				extractedData = try ZlibArchive.unarchive(archive: data)
			case "xml":
				extractedData = data
			default:
				throw DataFetchingError.invalidExtension
		}
		
		let xmlTV = try XMLTV(data: extractedData)
		
		return xmlTV
	}
	
	enum DataFetchingError: Error {
		case invalidURL
		case dataFetchFailed
		case invalidExtension
		
		var localizedDescription: LocalizedStringKey {
			switch self {
				case .invalidURL:
					"EPG_INVALID_URL"
				case .dataFetchFailed:
					"EPG_DATAFETCH_FAILED"
				case .invalidExtension:
					"EPG_INVALID_EXTENSION"
			}
		}
	}
}
