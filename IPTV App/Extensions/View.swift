//
//  View.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 14/04/2024.
//

import SwiftUI

extension View {
	func onboardingView(isFirstLaunch: Binding<Bool>) -> some View {
		return self.modifier(OnboardingViewModifier(isFirstLaunch: isFirstLaunch))
	}
}
