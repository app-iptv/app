//
//  Icon.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 23/12/2024.
//

import Foundation
import SwiftUICore
import DeveloperToolsSupport

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
