//
//  AboutView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 27/03/2024.
//

import SwiftUI
import M3UKit

struct AboutView: View {
	
	let version = Bundle.main.releaseVersionNumber ?? "1.0"
	
	let build = Bundle.main.buildVersionNumber ?? "1"
	
	var body: some View {
		#if os(macOS)
		NavigationStack {
			HStack { content.fixedSize() }
		}
		#else
		return content
		#endif
	}
	
	private var frame: CGFloat {
		#if os(macOS)
		100
		#else
		150
		#endif
	}
	
	private var content: some View {
		Group {
			Image(.macIcon)
				.resizable()
				.frame(width: 100, height: 100)
			VStack(alignment: .leading) {
				Text("IPTV App")
					.font(.title)
					.bold()
				Text("A simple IPTV client")
					.font(.body)
				Text("v\(version) · \(build)")
					.font(.caption)
					.padding(.vertical, 1)
				Label("https://www.github.com/pedrodsac/", systemImage: "ellipsis.curlybraces")
					.font(.caption2)
			}
		}
		.navigationTitle("About IPTV App")
	}
}

#Preview {
	AboutView()
}
