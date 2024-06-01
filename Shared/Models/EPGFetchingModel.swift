//
//  EPGFetchingModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 28/04/2024.
//

import Foundation
import XMLTV
import SWCompression
import SwiftUI
import SwiftData

@Observable
class EPGFetchingModel {
	
	var xmlTV: XMLTV? = nil
	
	init() {
		Task {
			ViewModel.shared.isLoadingEPG = true
			
			do {
				let epgLink: Int = UserDefaults.standard.integer(forKey: "SELECTED_PLAYLIST_INDEX")
				
				let predicate = #Predicate<Playlist>{ _ in
					true
				}
				
				var fetchDescriptor = FetchDescriptor(predicate: predicate)
				fetchDescriptor.fetchLimit = 1
				
				let items = try await SwiftDataCoordinator.shared.modelContext.fetch(fetchDescriptor)
				let playlist = items.safelyAccessElement(at: epgLink)
				
				if let epg = playlist?.epgLink {
					xmlTV = try await getPrograms(with: epg)
				} else {
					print("NO EPG")
					throw DataFetchingError.dataFetchFailed
				}
			} catch {
				dump(error)
			}
			
			ViewModel.shared.isLoadingEPG = false
		}
	}
	
	func isNowBetweenDates(program: TVProgram) -> Bool {
		let now = Date()
		return now > (program.start ?? .distantPast) && now < (program.stop ?? .distantPast)
	}
	
	func fetchData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			// Check for error
			guard error == nil else {
				completion(nil, response, error)
				return
			}
			
			// Check for HTTP response
			guard let httpResponse = response as? HTTPURLResponse else {
				let nsError = NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
				#if DEBUG
				print(nsError.localizedDescription)
				#endif
				completion(nil, response, error)
				return
			}
			
			// Check for redirection
			if httpResponse.statusCode == 301 || httpResponse.statusCode == 302 {
				// Extract the redirection URL
				if let location = httpResponse.allHeaderFields["Location"] as? String,
				   let redirectURL = URL(string: location) {
					#if DEBUG
					print("Redirecting to:", redirectURL)
					#endif
					// Delay for 2 seconds before fetching data from the redirection URL
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.fetchData(from: redirectURL, completion: completion)
					}
					return
				} else {
					let error = NSError(domain: "RedirectionError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid redirection URL"])
					completion(nil, response, error)
					return
				}
			}
			
			// If no redirection, pass the data, response, and error to the completion handler
			completion(data, response, error)
		}
		task.resume()
	}
	
	func getData(from link: String) async throws -> (Data?, String?) {
		guard let url = URL(string: link) else {
			#if DEBUG
			print("invalid url")
			#endif
			throw DataFetchingError.invalidURL
		}
		
		return try await withCheckedThrowingContinuation { continuation in
			fetchData(from: url) { data, response, error in
				guard error == nil else {
					continuation.resume(throwing: error!)
					return
				}
				
				
				let fileType: String?
				
				do {
					fileType = try self.checkFileType(of: response)
					continuation.resume(returning: (data, fileType))
				} catch {
					continuation.resume(throwing: error)
				}
			}
		}
	}
	
	func checkFileType(of response: URLResponse?) throws -> String? {
		guard let httpResponse = response as? HTTPURLResponse else {
			#if DEBUG
			print("Invalid response")
			#endif
			throw DataFetchingError.invalidExtension
		}
		
		if let pathExt = httpResponse.url?.pathExtension {
			return pathExt
		} else {
			#if DEBUG
			print("Invalid extension")
			#endif
			return nil
		}
	}
	
	func getPrograms(with link: String) async throws -> XMLTV {
		let (epgData, fileType) = try await getData(from: link)
		
		guard let epgData = epgData else {
			throw DataFetchingError.dataFetchFailed
		}
		
		var actualData: Data
		
		switch fileType {
			case "xz":
				#if DEBUG
				print("It's an XZ file.")
				#endif
				actualData = try XZArchive.unarchive(archive: epgData)
			case "gz":
				#if DEBUG
				print("It's a GZip file.")
				#endif
				actualData = try GzipArchive.unarchive(archive: epgData)
			case "zlib":
				#if DEBUG
				print("It's an Zlib file.")
				#endif
				actualData = try ZlibArchive.unarchive(archive: epgData)
			case "xml":
				#if DEBUG
				print("It's an XML file.")
				#endif
				actualData = epgData
			default:
				throw DataFetchingError.invalidExtension
		}
		
		let xmlTV = try XMLTV(data: actualData)
		
		#if DEBUG
		print("XMLTV created: SUCCESS")
		#endif
		
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
	
	static var shared: EPGFetchingModel = EPGFetchingModel()
}
