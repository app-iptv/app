//
//  View.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 14/04/2024.
//

import SwiftUI

extension View {
	func tabForView(for tab: Tab) -> some View {
		return
			self
				.tag(tab)
				.tabItem { Label(tab.name, systemImage: tab.nonFillImage) }
	}
}
