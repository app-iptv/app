//
//  Array.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 19/03/2024.
//

import Foundation

extension Array: @retroactive RawRepresentable where Element: Codable {
	public init?(rawValue: String) {
		guard let data = rawValue.data(using: .utf8),
			let result = try? JSONDecoder().decode([Element].self, from: data)
		else { return nil }
		self = result
	}

	public var rawValue: String {
		guard let data = try? JSONEncoder().encode(self),
			let result = String(data: data, encoding: .utf8)
		else { return "[]" }
		return result
	}
}

extension Array {
	public func safelyAccessElement(at index: Int) -> Element? {
		guard index >= 0 && index < count else {
			return nil
		}

		return self[index]
	}
}
