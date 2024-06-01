//
//  InfinitePagingScrollView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI

struct InfinitePagingScrollView<Content: View, T: Identifiable>: View {
	@State private var currentPage = 0
	private let items: [T]
	private let content: (T) -> Content
	
	init(items: [T], @ViewBuilder content: @escaping (T) -> Content) {
		self.items = items
		self.content = content
	}
	
	var body: some View {
		GeometryReader { geometry in
			SwiftUI.TabView(selection: $currentPage) {
				ForEach(0..<items.count, id: \.self) { index in
					content(items[index])
						.frame(width: geometry.size.width)
						.tag(index)
				}
			}
			.tabViewStyle(PageTabViewStyle())
		}
	}
}
