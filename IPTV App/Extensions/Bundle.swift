//
//  Bundle.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 02/04/2024.
//

import Foundation

extension Bundle {
	var releaseVersionNumber: String? {
		return infoDictionary?["CFBundleShortVersionString"] as? String
	}
	
	var buildVersionNumber: String? {
		return infoDictionary?["CFBundleVersion"] as? String
	}
}
