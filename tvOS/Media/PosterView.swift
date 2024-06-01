//
//  PosterView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PosterView<Content: View>: View {
	@FocusState private var isFocused: Bool
	
	private let title: String
	private let size: PosterSize
	private let action: () -> Void
	private let image: () -> WebImage<Content>
	
	private var height: CGFloat {
		switch size {
			case .small:
				180
			case .regular:
				230
			case .large:
				400
		}
	}
	
	private var width: CGFloat {
		switch size {
			case .small:
				320
			case .regular:
				410
			case .large:
				1700
		}
	}
	
	internal init(title: String, size: PosterSize, action: @escaping () -> Void, image: @escaping () -> WebImage<Content>) {
		self.title 	= title
		self.size 	= size
		self.action = action
		self.image 	= image
	}
	
	var body: some View {
//		VStack(spacing: 0) {
//			image()
//				.frame(width: width, height: height)
//				.padding(20)
//				.background(material, in: .rect(cornerRadius: 10))
//				.padding(.all, isFocused ? 20 : nil)
//				.ignoresSafeArea()
//				.scaleEffect(isFocused ? 1.1 : 1, anchor: .center)
//				.animation(.default)
//		
//			Text(title)
//				.font(.caption2)
//				.animation(.default)
//		}
//		.focusable()
//		.focused($isFocused)
//		.onTapGesture(perform: action)
		VStack(spacing: 0) {
			ZStack {
				image()
					.frame(width: width, height: height)
					.padding(20)
					.background(.regularMaterial, in: .rect(cornerRadius: 10))
					.padding(.all, isFocused ? 20 : nil)
					.ignoresSafeArea()
					.animation(.default)
				
				// Overlay with scale effect
				image()
					.frame(width: width, height: height)
					.padding(20)
					.background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
					.padding(.all, isFocused ? 20 : nil)
					.ignoresSafeArea()
					.scaleEffect(isFocused ? 1.1 : 1, anchor: .center)
					.animation(.default)
					.opacity(isFocused ? 1 : 0) // Show overlay only when focused
			}
			
			Text(title)
				.font(.caption2)
				.animation(.default)
		}
		.focusable()
		.focused($isFocused)
		.onTapGesture(perform: action)

	}
}

enum PosterSize {
	case small, regular, large
}
