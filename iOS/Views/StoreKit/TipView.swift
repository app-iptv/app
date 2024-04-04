//
//  TipView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 26/03/2024.
//

import SwiftUI
import StoreKit

struct TipView: View {
	
	@Binding var tip: Product?
	
	var body: some View {
		HStack {
			Text(tip?.displayName ?? "")
			Spacer()
			Button(tip?.displayPrice ?? "") { }
				.buttonStyle(.bordered)
		}
		.padding(5)
	}
}
