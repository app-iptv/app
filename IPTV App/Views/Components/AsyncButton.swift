//
//  AsyncButton.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 08/11/2024.
//

import SwiftUI

struct AsyncButton: View {
	var action: () async -> Void
	var label: () -> any View
	
	init(action: @escaping () async -> Void, label: @escaping () -> any View) {
		self.action = action
		self.label = label
	}
	
	var body: some View {
		Button {
			Task { await action() }
		} label: {
			AnyView(label())
		}
	}
}

extension AsyncButton {
	init(_ titleKey: LocalizedStringKey, systemImage: String, action: @escaping () async -> Void) {
		self.init(action: action) {
			SwiftUI.Label(titleKey, systemImage: systemImage)
		}
	}
}
