//
//  LoadingView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct LoadingView: View {
	var body: some View {
		ZStack {
			Rectangle()
				.fill(.black)
				.opacity(0.75)
				.ignoresSafeArea()
			
			VStack(spacing: 20) {
				ProgressView()
				Text("Adding playlist...")
			}
			.background {
				RoundedRectangle(cornerRadius: 20)
					.fill(.reversePrimary)
					.frame(width: 200, height: 200)
			}
		}
	}
}
