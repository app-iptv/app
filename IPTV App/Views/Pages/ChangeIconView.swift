//
//  ChangeIconView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 10/04/2024.
//

import SwiftUI

struct ChangeIconView: View {
	@State private var errorDidFail: Bool = false
	@State private var errorDetail: String = ""
	
	@AppStorage("SELECTED_ICON") private var selectedIcon: Icon = .original
	
	let icons: [Icon] = [.blue, .red, .green, .yellow]
	
	var body: some View {
		List {
			Section {
				Button {
					setIcon(.original)
				} label: {
					iconLabel(for: .original)
				}
			}
			
			Section {
				ForEach(icons) { icon in
					Button {
						setIcon(icon)
					} label: {
						iconLabel(for: icon)
					}
				}
			}
		}
		.alert("Error Changing Icon", isPresented: $errorDidFail) {
			Button("Cancel") { errorDidFail.toggle() }
		} message: {
			Text(errorDetail)
		}
		.navigationTitle("Change App Icon")
	}
	
	private func setIcon(_ icon: Icon) {
		Task {
			do {
				try await UIApplication.shared.setAlternateIconName(icon.iconName)
				selectedIcon = icon
			} catch {
				errorDidFail = true
				errorDetail = error.localizedDescription
			}
		}
	}
	
	private func iconLabel(for icon: Icon) -> some View {
		HStack(spacing: 5) {
			Image(icon.iconImage)
				.resizable()
				.scaledToFit()
				.frame(width: 60, height: 60)
				.clipShape(.rect(cornerRadius: 17.5))
				.overlay(
					RoundedRectangle(cornerRadius: 17.5).stroke(
						lineWidth: 0.25
					).foregroundStyle(.black)
				)
				.padding(5)
				.padding(.leading, -5)
			Text(icon.name)
			
			Spacer()
			
			if selectedIcon == icon {
				Image(systemName: "checkmark")
					.foregroundStyle(Color.accentColor)
			}
		}
	}
}
