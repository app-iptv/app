//
//  Icon.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 23/12/2024.
//

import Foundation
import SwiftUICore
import DeveloperToolsSupport

enum Icon {
	case blue
	case green
	case red
	case yellow
	case original
}

extension Icon {
	var name: LocalizedStringKey {
		switch self {
			case .blue: "Blue"
			case .green: "Green"
			case .red: "Red"
			case .yellow: "Yellow"
			case .original: "Default"
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
			case .blue: .blue
			case .green: .green
			case .red: .red
			case .yellow: .yellow
			case .original: .default
		}
	}
}

extension Icon: RawRepresentable, Identifiable, CaseIterable {
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
			case .blue: "blue"
			case .green: "green"
			case .red: "red"
			case .yellow: "yellow"
			case .original: "original"
		}
	}
	
	public var id: RawValue { rawValue }
}

