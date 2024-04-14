//
//  View.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 14/04/2024.
//

import SwiftUI

extension View {
	func tabForView(selection: Binding<Tab>, for view: Tab) -> some View {
		self.tabItem { Label(view.name, systemImage: selection.wrappedValue == view ? view.fillImage : view.nonFillImage) }
	}
}
