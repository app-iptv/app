//
//  FavouritesTip.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 24/08/2024.
//

import Foundation
import TipKit

struct FavouritesTip: Tip {
	static var setFavouriteEvent = Event(id: "setFavorite")
	static var showTipEvent = Event(id: "showTip")

	var title: Text {
		Text("Add to Favourites")
	}

	var message: Text? {
		Text(
			"You can add channels to your favourites by dragging the channel to the left to easily access it later."
		)
	}

	var image: Image? {
		Image(systemName: "star")
	}

	var rules: [Rule] {
		#Rule(Self.setFavouriteEvent) { event in
			event.donations.count == 0
		}

		#Rule(Self.showTipEvent) { event in
			event.donations.count >= 3
		}
	}
}
