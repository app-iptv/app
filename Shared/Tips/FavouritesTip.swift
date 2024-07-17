//
//  FavouritesTip.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 04/07/2024.
//

import TipKit

struct FavouritesTip: Tip {
	var title: Text {
		Text("Add to Favourites")
	}
	
	var message: Text? {
		Text("Long-press or swipe to the left to add a media to favourites.")
	}
	
	var image: Image? {
		Image(systemName: "star")
	}
	
	var rules: [Rule] = [
		#Rule(Self.$showTip) {
			$0 == true
		}
	]
	
	@Parameter static var showTip: Bool = false
}
