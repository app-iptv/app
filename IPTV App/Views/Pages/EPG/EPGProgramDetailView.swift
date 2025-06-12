//
//  EPGProgramDetailView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 03/05/2024.
//

import SDWebImageSwiftUI
import SwiftUI
import XMLTV

struct EPGProgramDetailView: View {
	private let program: TVProgram

	init(for program: TVProgram) {
		self.program = program
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				HStack(spacing: 10) {
					WebImage(url: URL(string: program.icon ?? "")) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
					} placeholder: {
						Image(systemName: "photo.tv").imageScale(.large)
					}
					.frame(width: 150, height: 150)

					VStack(alignment: .leading, spacing: 5) {
						Text(LocalizedStringKey(program.title ?? "Untitled"))
							.font(.title2)
							.fontWeight(.semibold)
						if let start = program.start, let stop = program.stop {
							Text(
								"\(localizedDateString(for: start)), \(start.formatted(date: .omitted, time: .shortened)) - \(stop.formatted(date: .omitted, time: .shortened))"
							)
							.font(.caption)
						}
					}

					Spacer()
				}
				
				if let description = program.description {
					Text(description)
				}
			}
			.padding(.horizontal)
			.navigationTitle(LocalizedStringKey(program.title ?? "Untitled"))
			#if os(macOS)
				.padding(.top)
			#endif
		}
	}
}

extension EPGProgramDetailView {
	private func localizedDateString(for date: Date) -> String {
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: Date())
		let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
		let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!

		if calendar.isDate(date, inSameDayAs: today) {
			return date.formatted(.relative(presentation: .named))
		} else if calendar.isDate(date, inSameDayAs: yesterday) {
			return String(localized: "Yesterday")
		} else if calendar.isDate(date, inSameDayAs: tomorrow) {
			return String(localized: "Tomorrow")
		} else {
			return date.formatted(date: .complete, time: .omitted)
		}
	}
}
