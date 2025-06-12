//
//  AsyncButton.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 23/12/2024.
//

import SwiftUI

struct AsyncButton<Content: View>: View {
	@State private var task: Task<(), Never>? = nil
	
	let action: () async -> Void
	let label: (Bool) -> Content
	
	init(action: @escaping () async -> Void, label: @escaping (Bool) -> Content) {
		self.action = action
		self.label = label
	}

	var body: some View {
		Button {
			task = Task { @MainActor in
				await action()
				task = nil
			}
		} label: {
			label(task != nil)
		}
		.onDisappear {
			task?.cancel()
			task = nil
		}
	}
}
