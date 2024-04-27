//
//  EPGProgramView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 27/04/2024.
//

import SwiftUI
import XMLTV
import SDWebImageSwiftUI

struct EPGProgramView: View {
	let program: TVProgram
	
	init(for program: TVProgram) {
		self.program = program
	}
	
	let currentInterval = Date().timeIntervalSinceReferenceDate
	var startInterval: TimeInterval { program.start?.timeIntervalSinceReferenceDate ?? 0 }
	var endInterval: TimeInterval { program.stop?.timeIntervalSinceReferenceDate ?? 0 }
	
	var progress: Double { ((currentInterval - startInterval) / (endInterval - startInterval)) * 100 }
	
    var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: 5) {
				if let start = program.start?.formatted(date: .omitted, time: .shortened), let stop = program.stop?.formatted(date: .omitted, time: .shortened) {
					HStack {
						Text(start + " - " + stop)
							.font(.caption)
						Spacer()
						Text(program.start?.formatted(date: .abbreviated, time: .omitted) ?? "")
							.font(.caption)
					}
				}
				if let title = program.title {
					Text(title)
				} else {
					Text(LocalizedStringKey("Untitled"))
				}
			}
			
			if isNowBetweenDates(startDate: program.start ?? .distantPast, endDate: program.stop ?? .distantPast) {
				ProgressView(value: progress, total: 100)
					.progressViewStyle(.linear)
					.padding(-3)
					.padding(.bottom, -5)
				#if targetEnvironment(macCatalyst)
					.padding(.top, -5)
				#endif
			}
		}
		.padding(10)
		.background(isNowBetweenDates(startDate: program.start ?? .distantPast, endDate: program.stop ?? .distantPast) ? .liveEPGColour : .backgroundEPGColour, in: RoundedRectangle(cornerRadius: 8))
		.padding(.bottom, 5)
    }
	
	private func isNowBetweenDates(startDate: Date, endDate: Date) -> Bool {
		let now = Date()
		return now > startDate && now < endDate
	}
}
