//
//  OnboardingViewModifier.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 30/12/2024.
//

import SwiftUI

struct OnboardingViewModifier: ViewModifier {
	@Binding var isFirstLaunch: Bool
	
	internal init(isFirstLaunch: Binding<Bool>) {
		self._isFirstLaunch = isFirstLaunch
	}
	
	func body(content: Content) -> some View {
		content
			#if os(macOS)
			.sheet(isPresented: $isFirstLaunch) { FirstLaunchView(isFirstLaunch: $isFirstLaunch) }
			#else
			.fullScreenCover(isPresented: $isFirstLaunch) { OnboardingView().ignoresSafeArea() }
			#endif
	}
}
