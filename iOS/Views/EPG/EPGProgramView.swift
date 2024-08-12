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
	
	private let currentInterval = Date().timeIntervalSinceReferenceDate
	private var startInterval: TimeInterval { program.start?.timeIntervalSinceReferenceDate ?? 0 }
	private var endInterval: TimeInterval { program.stop?.timeIntervalSinceReferenceDate ?? 0 }
	
	private var progress: Double { ((currentInterval - startInterval) / (endInterval - startInterval)) * 100 }
	
	private var formatter: RelativeDateTimeFormatter {
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .numeric
		formatter.unitsStyle = .short
		
		return formatter
	}
	
	var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                if let start = program.start {
					HStack {
                        Text(start.formatted(date: .omitted, time: .shortened) + " - " + (program.stop?.formatted(date: .omitted, time: .shortened) ?? "Undefined"))
							.font(.caption)
						
						Spacer()
						
						Text(localizedDateString(for: start))
							.font(.caption)
					}
				}
				
				Text(LocalizedStringKey(program.title ?? "Untitled"))
					.lineLimit(1)
					.foregroundStyle(program.isCurrent() ? .red : .primary)
			}
			.padding(.vertical, 2.5)
			.padding(7.5)
			
			if program.isCurrent() {
				ProgressView(value: progress, total: 100)
					.progressViewStyle(SquaredProgressViewStyle())
					.ignoresSafeArea(.all)
					#if os(macOS)
					.padding(.bottom, -7)
					#else
					.padding(.bottom, -7.5)
					#endif
			}
			
			Divider()
				.ignoresSafeArea()
				.shadow(radius: 0.5)
		}
    }
	
	private func localizedDateString(for date: Date) -> String {
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: Date())
		let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
		let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
		
		if calendar.isDate(date, inSameDayAs: today) {
			return String(localized: "Today")
		} else if calendar.isDate(date, inSameDayAs: yesterday) {
			return String(localized: "Yesterday")
		} else if calendar.isDate(date, inSameDayAs: tomorrow) {
			return String(localized: "Tomorrow")
		} else {
			return date.formatted(date: .complete, time: .omitted).capitalized
		}
	}
	
	struct SquaredProgressViewStyle: ProgressViewStyle {
		func makeBody(configuration: Configuration) -> some View {
			GeometryReader { geometry in
				ZStack(alignment: .leading) {
					Rectangle()
						.foregroundColor(Color.gray.opacity(0.2))
						.frame(width: geometry.size.width, height: 3)
					
					Rectangle()
						.foregroundColor(Color.blue)
						.frame(width: CGFloat(configuration.fractionCompleted ?? 0) * geometry.size.width, height: 3)
				}
			}
		}
	}
}
