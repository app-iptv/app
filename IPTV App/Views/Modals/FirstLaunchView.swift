//
//  FirstLaunchView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 09/03/2024.
//

import SwiftUI

struct FirstLaunchView: View {
	@Binding var isFirstLaunch: Bool

	internal init(isFirstLaunch: Binding<Bool>) {
		self._isFirstLaunch = isFirstLaunch
	}

	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				Text(
					"Welcome! Enjoy instant access to live TV channels from around the world, right at your fingertips. You can create a new playlist by clicking \"New Playlist\" in \"File\" in the Menu Bar, or by clicking CMD + N"
				)
				.multilineTextAlignment(.center)
				.padding(.horizontal)
				
				Image(.macExample)
					.resizable()
					.scaledToFit()
					.padding(.trailing, 30)
				
				Text(
					"You can show this screen again by clicking \"Show Tips Again\" in \"Settings\" in \"IPTV\" in the Menu Bar, or by clicking CMD + T"
				)
				.multilineTextAlignment(.center)
				.padding([.horizontal, .top])
				
				Image(.showTipsAgain)
					.resizable()
					.scaledToFit()
					.padding(.trailing, 30)
			}
		}
		.padding(.top)
		
		Divider()

		HStack {
			Spacer()

			Button("Get Started") { isFirstLaunch.toggle() }
		}
		.padding(20)
		.padding(.top, -5)
	}
}

#Preview {
	FirstLaunchView(isFirstLaunch: .constant(true))
}
