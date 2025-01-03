//
//  ParserError.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 24/12/2024.
//

import Foundation

enum ParserError: Error {
	case invalidURL
	case invalidData
	
	var localizedDescription: String {
		switch self {
			case .invalidURL: "Invalid URL"
			case .invalidData: "Invalid Data"
		}
	}
}
