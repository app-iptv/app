//
//  AboutView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 27/03/2024.
//

import M3UKit
import SwiftUI

struct AboutView: View {
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	@Environment(\.verticalSizeClass) private var verticalSizeClass
	
	let version = Bundle.main.releaseVersionNumber ?? "1.0"

	let build = Bundle.main.buildVersionNumber ?? "1"

	var body: some View {
		NavigationStack {
			Group {
				if horizontalSizeClass == .regular || verticalSizeClass == .compact {
					HStack {
						content.fixedSize()
					}
					.padding()
				} else {
					content
				}
			}
			.navigationTitle("About")
		}
	}
}

extension AboutView {
	private var size: CGFloat {
		switch horizontalSizeClass {
			case .compact:
				return 250
			default:
				return 110
		}
	}
	
	private var content: some View {
		Group {
			Image(.macIcon)
				.resizable()
				.frame(width: size, height: size)
			VStack(alignment: .leading) {
				Text("IPTV App")
					.font(.title)
					.bold()
				
				Text("A simple IPTV client")
					.font(.body)
				
				Text("v\(version) · \(build)")
					.font(.caption)
					.padding(.vertical, 1)
				
				Label(
					"https://www.github.com/app-iptv/",
					systemImage: "ellipsis.curlybraces"
				)
				.font(.caption2)
			}
		}
	}
}

#Preview {
	NavigationStack { AboutView() }
}
