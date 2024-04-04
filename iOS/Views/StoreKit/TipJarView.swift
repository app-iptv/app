//
//  TipJarView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 24/03/2024.
//

import SwiftUI
import StoreKit

struct TipJarView: View {
	@State private var tinyTip: Product? = nil
	@State private var smallTip: Product? = nil
	@State private var mediumTip: Product? = nil
	@State private var largeTip: Product? = nil
	
	var body: some View {
		#if targetEnvironment(macCatalyst)
		NavigationStack {
			content
		}
		#else
		content
		#endif
	}
	
	private var content: some View {
		List {
			Section {
				TipView(tip: $tinyTip)
				TipView(tip: $smallTip)
				TipView(tip: $mediumTip)
				TipView(tip: $largeTip)
			} footer: {
				Text("IPTV App is a free resource for the community so any finantial support is greatly appreciated!")
			}
		}
		.navigationTitle("Tip Jar")
		.task { await loadTips() }
	}
	
	private func loadTips() async {
		tinyTip 	= try? await Product.products(for: ["me.pedrocordeiro.IPTVapp.tinyTip"]).first
		smallTip 	= try? await Product.products(for: ["me.pedrocordeiro.IPTVapp.smallTip"]).first
		mediumTip 	= try? await Product.products(for: ["me.pedrocordeiro.IPTVapp.mediumTip"]).first
		largeTip 	= try? await Product.products(for: ["me.pedrocordeiro.IPTVapp.largeTip"]).first
	}
}
