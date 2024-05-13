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

class EPGFetchingModel {
	
	private init() { }
	
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
				print(nsError.localizedDescription)
				completion(nil, response, error)
				return
			}
			
			// Check for redirection
			if httpResponse.statusCode == 301 || httpResponse.statusCode == 302 {
				// Extract the redirection URL
				if let location = httpResponse.allHeaderFields["Location"] as? String,
				   let redirectURL = URL(string: location) {
					print("Redirecting to:", redirectURL)
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
			print("invalid url")
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
			print("Invalid response")
			throw DataFetchingError.invalidExtension
		}
		
		if let pathExt = httpResponse.url?.pathExtension {
			return pathExt
		} else {
			print("Invalid extension")
			return nil
		}
	}
	
	func getPrograms(with link: String) async throws -> XMLTV {
		do {
			let (epgData, fileType) = try await getData(from: link)
			
			guard let epgData = epgData else {
				throw DataFetchingError.dataFetchFailed
			}
			
			var actualData: Data
			
			switch fileType {
				case "xz":
					print("It's an XZ file.")
					actualData = try XZArchive.unarchive(archive: epgData)
				case "gz":
					print("It's a GZip file.")
					actualData = try GzipArchive.unarchive(archive: epgData)
				case "zlib":
					print("It's an Zlib file.")
					actualData = try ZlibArchive.unarchive(archive: epgData)
				case "xml":
					print("It's an XML file.")
					actualData = epgData
				default:
					throw DataFetchingError.invalidExtension
			}
			
			let xmlTV = try XMLTV(data: actualData)
			
			print("XMLTV created: SUCCESS")
			
			return xmlTV
		} catch {
			print("Error: \(error) \(error.localizedDescription)")
			throw DataFetchingError.dataFetchFailed
		}
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
