//
//  ViewModifiers.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 09/05/2024.
//

import SwiftUI

struct ElementViewModifier: ViewModifier {
	
	let type: ElementType
	
	init(for type: ElementType) {
		self.type = type
	}
	
	func body(content: Content) -> some View {
		switch type {
			case .top:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 2.5, bottomTrailing: 2.5, topTrailing: 8), style: .circular))
			case .bottom:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 8, bottomTrailing: 8, topTrailing: 2.5), style: .circular))
			case .right:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 2.5, bottomTrailing: 8, topTrailing: 8), style: .circular))
			case .left:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 8, bottomTrailing: 2.5, topTrailing: 2.5), style: .circular))
			case .topLeft:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 2.5, bottomTrailing: 2.5, topTrailing: 2.5), style: .circular))
			case .topRight:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 2.5, bottomTrailing: 2.5, topTrailing: 8), style: .circular))
			case .bottomLeft:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 8, bottomTrailing: 2.5, topTrailing: 2.5), style: .circular))
			case .bottomRight:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 2.5, bottomTrailing: 8, topTrailing: 2.5), style: .circular))
			case .middle:
				content
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 2.5, bottomTrailing: 2.5, topTrailing: 2.5), style: .circular))
		}
	}
}

enum ElementType {
	case top, bottom, right, left, topLeft, topRight, bottomLeft, bottomRight, middle
}
