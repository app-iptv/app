//
//  GuideProgramItemView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI
import XMLTV

struct GuideProgramItemView: View {
	private var program: TVProgram

	internal init(program: TVProgram) {
		self.program = program
	}

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 4) {
				Text(program.title ?? "Untitled")
					.font(.subheadline)
					.bold()
					.foregroundStyle(program.isCurrent() ? .red : .primary)
					.multilineTextAlignment(.leading)
				if let episode = program.episode {
					Text(episode)
						.font(.callout)
						.foregroundStyle(.secondary)
						.multilineTextAlignment(.leading)
				}
			}
			Spacer()
			if let start = program.start, let stop = program.stop {
				Text(
					"\(start.formatted(date: .abbreviated, time: .shortened)) - \(stop.formatted(date: .omitted, time: .shortened))"
				)
				.font(.caption)
				.multilineTextAlignment(.trailing)
			}
		}
		.padding()
		.background(.ultraThinMaterial)
		.clipShape(.rect(cornerRadius: 10))
	}
}
