//
//  AsyncButton.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 08/11/2024.
//

import SwiftUI

struct AsyncButton<Content: View>: View {
	var action: () async -> Void
	var label: () -> Content
	
	init(action: @escaping () async -> Void, label: @escaping () -> Content) {
		self.action = action
		self.label = label
	}
	
	var body: some View {
		Button {
			Task(operation: action)
		} label: {
			label()
		}
	}
}

extension AsyncButton where Content == Label<Text, Image> {
	init(_ titleKey: LocalizedStringKey, systemImage: String, action: @escaping () async -> Void) {
		self.init(action: action) {
			Label(titleKey, systemImage: systemImage)
		}
	}
}
