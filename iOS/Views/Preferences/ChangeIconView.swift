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
	
	@AppStorage("SELECTED_ICON") var selectedIcon: Icon = .original
	
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
		selectedIcon = icon
		
		UIApplication.shared.setAlternateIconName(icon.iconName) { error in
			if let error = error {
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
				.frame(width: 70, height: 70)
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

enum Icon: Identifiable, CaseIterable {
	case blue, green, red, yellow, original
	
	var id: Self { self }
	
	var name: LocalizedStringKey {
		switch self {
			case .blue:
				"Blue"
			case .green:
				"Green"
			case .red:
				"Red"
			case .yellow:
				"Yellow"
			case .original:
				"Default"
		}
	}
	
	var iconName: String {
		switch self {
			case .blue: "BlueIcon"
			case .green: "GreenIcon"
			case .red: "RedIcon"
			case .yellow: "YellowIcon"
			case .original: "DefaultIcon"
		}
	}
	
	var iconImage: ImageResource {
		switch self {
			case .blue:
				.blue
			case .green:
				.green
			case .red:
				.red
			case .yellow:
				.yellow
			case .original:
				.default
		}
	}
}

extension Icon: RawRepresentable {
	typealias RawValue = String
	
	init?(rawValue: RawValue) {
		switch rawValue {
			case "blue":
				self = .blue
			case "green":
				self = .green
			case "red":
				self = .red
			case "yellow":
				self = .yellow
			case "original":
				self = .original
			default:
				return nil
		}
	}
	
	var rawValue: RawValue {
		switch self {
			case .blue:
				return "blue"
			case .green:
				return "green"
			case .red:
				return "red"
			case .yellow:
				return "yellow"
			case .original:
				return "original"
		}
	}
}
