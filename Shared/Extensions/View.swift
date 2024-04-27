//
//  View.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 14/04/2024.
//

import SwiftUI

extension View {
	func tabForView(selection: Binding<Tab>, for tab: Tab) -> some View {
		self
			.tag(tab)
			.tabItem { Label(tab.name, systemImage: selection.wrappedValue == tab ? tab.fillImage : tab.nonFillImage) }
	}
}
