//
//  ErrorView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct ErrorView: View {
	@Binding var parserDidFail: Bool
	@Binding var parserError: String
	
	var body: some View {
		ContentUnavailableView {
			Label("Error", systemImage: "exclamationmark.triangle")
		} description: {
			Text(parserError)
		} actions: {
			Button("Close") { parserDidFail.toggle() }
		}
		#if os(macOS)
		.frame(width: 200, height: 300)
		#endif
		.padding()
	}
}
