//
//  ErrorView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct ErrorView: View {
	@Bindable var vm: ViewModel
	
	init(_ vm: ViewModel) { self.vm = vm }
	
	var body: some View {
		ContentUnavailableView {
			Label("Error", systemImage: "exclamationmark.triangle")
		} description: {
			Text(vm.parserError)
		} actions: {
			Button("Close") { vm.parserDidFail.toggle() }
		}
		#if os(macOS)
		.frame(width: 200, height: 300)
		#endif
		.padding()
	}
}
