//
//  ErrorView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct ErrorView: View {
	@State private var vm = ViewModel.shared
	
	var body: some View {
		ContentUnavailableView {
			Label("Error", systemImage: "exclamationmark.triangle")
		} description: {
			if let error = vm.parserError {
				Text(error.localizedDescription)
			}
		} actions: {
			Button("Close") { vm.parserDidFail.toggle() }
		}
		#if os(macOS)
		.frame(width: 200, height: 300)
		#endif
		.padding()
	}
}
