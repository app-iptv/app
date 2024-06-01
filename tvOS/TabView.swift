//
//  TabView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 18/05/2024.
//

import SwiftUI

struct TabView: View {
	@Environment(\.horizontalSizeClass) private var sizeClass
	
	@Binding private var selectedTab: Tab
	
	@Binding private var isRemovingAll: Bool
	
	private var visibility: Visibility {
		switch sizeClass {
			case .compact:
				return .automatic
			case .regular:
				return .visible
			default:
				return .automatic
		}
	}
	
	private var placement: ToolbarPlacement {
		switch sizeClass {
			case .compact:
				return .automatic
			case .regular:
				return .tabBar
			default:
				return .automatic
		}
	}
	
	internal init(selectedTab: Binding<Tab>, isRemovingAll: Binding<Bool>) {
		self._selectedTab = selectedTab
		self._isRemovingAll = isRemovingAll
	}
	
	var body: some View {
		SwiftUI.TabView(selection: $selectedTab) {
			TVView()
				.tabForView(for: .tv)
			GuideView()
				.tabForView(for: .guide)
			MoviesAndTVShowsView()
				.tabForView(for: .movies)
			SearchView()
				.tabForView(for: .search)
			SettingsView(isRemovingAll: $isRemovingAll)
				.tabForView(for: .settings)
		}
	}
}
