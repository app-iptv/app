//
//  AsyncButton.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 23/12/2024.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
	@State private var task: Task<(), Never>? = nil
	
	let action: () async -> Void
	let label: (Bool) -> Label
	
	init(action: @escaping () async -> Void, label: @escaping (Bool) -> Label) {
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
