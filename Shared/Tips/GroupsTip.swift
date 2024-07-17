//
//  GroupsTip.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/07/2024.
//

import TipKit

struct GroupsTip: Tip {
	var title: Text {
		Text("Group Picker")
	}
	
	var message: Text? {
		Text("Select the desired group using the group picker to only show relevant medias.")
	}
	
	var image: Image? {
		Image(systemName: "tray.2")
	}
	
	var rules: [Rule] = [
		#Rule(Self.$showTip) {
			$0 == true
		}
	]
	
	@Parameter static var showTip: Bool = false
}
