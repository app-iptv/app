//
//  mediaDetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit
import AVKit
import XMLTV
import Gzip
import SWCompression

struct MediaDetailView: View {
	
	@State private var programs: [TVProgram]? = nil
	
	@State private var searchQuery: String = ""
	
	var filteredPrograms: [TVProgram]? {
		guard !searchQuery.isEmpty else { return programs }
		return programs?.filter { ($0.title ?? String(localized: "Untitled")).localizedCaseInsensitiveContains(searchQuery) }
	}
	
	@State private var isLoading: Bool = false
	
	@State private var isUnsupported: Bool = false
	
	let playlistName: String
	
	let media: Media
	
	let epgLink: String
	
	var body: some View {
		VStack(spacing: 10) {
			PlayerView(media: media, playlistName: playlistName)
				.aspectRatio(16/9, contentMode: .fit)
				.cornerRadius(10)
			HStack {
				VStack(alignment: .leading, spacing: 2.5) {
					if let groupTitle = media.attributes["group-title"] {
						Text(groupTitle)
							.font(.footnote)
					}
					Text(media.title)
						.font(.headline)
				}
				Spacer()
			}
			
			if isLoading {
				VStack {
					Spacer()
					ProgressView()
					Spacer()
				}
			} else if let programs = filteredPrograms {
				ScrollView {
					ScrollViewReader { reader in
						VStack(alignment: .leading, spacing: 2.5) {
							ForEach(programs, id: \.self) { program in
								EPGProgramView(for: program)
									.id(isNowBetweenDates(startDate: program.start ?? .distantPast, endDate: program.stop ?? .distantPast))
							}
							.onAppear {
								withAnimation {
									reader.scrollTo(true, anchor: .center)
								}
							}
						}
					}
				}
			} else if (filteredPrograms?.isEmpty ?? true) && !(programs?.isEmpty ?? true) {
				ContentUnavailableView.search(text: searchQuery)
			} else if !(programs?.isEmpty ?? true) {
				ContentUnavailableView("TV Guide is empty", systemImage: "tv.slash", description: Text("The EPG link provided does not include any programs for this channel."))
			} else {
				Spacer()
			}
		}
		.task {
			do {
				isLoading = true
				self.programs = try await getPrograms()
				isLoading = false
			} catch {
				print(error, error.localizedDescription)
				self.programs = nil
				isLoading = false
			}
		}
		.searchable(text: $searchQuery)
		.refreshable { await refreshEPG() }
		.toolbarTitleDisplayMode(.inline)
		.safeAreaPadding(.horizontal)
	}
	
	private func refreshEPG() async {
		do {
			self.programs = try await getPrograms()
		} catch {
			print(error, error.localizedDescription)
			self.programs = nil
		}
	}
	
	private func isNowBetweenDates(startDate: Date, endDate: Date) -> Bool {
		let now = Date()
		return now > startDate && now < endDate
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
						fetchData(from: redirectURL, completion: completion)
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
	
	private func getData() async throws -> (Data?, String?) {
		guard let url = URL(string: epgLink) else {
			print("invalid url")
			throw DataFetchingError.invalidURL
		}
		
		return try await withCheckedThrowingContinuation { continuation in
			fetchData(from: url) { data, response, error in
				guard error == nil else {
					continuation.resume(throwing: error!)
					return
				}
				
				continuation.resume(returning: (data, checkFileType(of: response)))
			}
		}
	}
	
	func checkFileType(of response: URLResponse?) -> String? {
		guard let httpResponse = response as? HTTPURLResponse else {
			print("Invalid response")
			return nil
		}
		
		if let pathExt = httpResponse.url?.pathExtension {
			return pathExt
		} else {
			print("Invalid extension")
			return nil
		}
	}
	
	private func getPrograms() async throws -> [TVProgram]? {
		do {
			let (epgData, fileType) = try await getData()
			
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
					actualData = try epgData.gunzipped()
				default:
					print("It's an XML File")
					actualData = epgData
					print(fileType)
					print(epgData)
			}
			
			let xmlTV = try XMLTV(data: actualData)
			
			let channels = xmlTV.getChannels()
			
			guard let selectedChannel = channels.first(where: { channel in
				channel.id == media.attributes["tvg-id"]
			}) else {
				print("Selected channel not found")
				return []
			}
			
			print("Programs found")
			return xmlTV.getPrograms(channel: selectedChannel)
		} catch {
			print("Error: \(error) \(error.localizedDescription)")
			throw DataFetchingError.dataFetchFailed
		}
	}
	
	enum DataFetchingError: Error {
		case invalidURL
		case dataFetchFailed
	}
}
