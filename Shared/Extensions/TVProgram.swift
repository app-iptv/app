//
//  TVProgram.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import XMLTV
import Foundation

extension TVProgram: Identifiable {
	public var id: UUID { UUID() }
	
	public func isCurrent() -> Bool {
		let now = Date()
		
		guard let start, let stop else { return false }
		
		return now > start && now < stop
	}
}
