//
//  UserInterfaceSizeClass.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 06/04/2024.
//

import SwiftUI

#if !os(tvOS)
extension UserInterfaceSizeClass {
	var toolbarRole: ToolbarRole {
		if self == .compact {
			return ToolbarRole.automatic
		} else {
			return ToolbarRole.browser
		}
	}
	
	var toolbarTitleDisplayMode: ToolbarTitleDisplayMode {
		if self == .compact {
			return ToolbarTitleDisplayMode.inline
		} else {
			return ToolbarTitleDisplayMode.inlineLarge
		}
	}
}
#endif
