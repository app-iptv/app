//
//  ErrorView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct ErrorView: View {
	@Bindable var viewModel: AddPlaylistViewModel
	
	internal init(viewModel: AddPlaylistViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ContentUnavailableView {
			Label("Error", systemImage: "exclamationmark.triangle")
		} description: {
			if let error = viewModel.parserError {
				Text(error.localizedDescription)
			}
		} actions: {
			Button("Close") { viewModel.parserDidFail.toggle() }
		}
		#if os(macOS)
		.frame(width: 200, height: 300)
		#endif
		.padding()
	}
}
