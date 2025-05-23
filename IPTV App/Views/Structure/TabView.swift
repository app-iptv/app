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

	#if os(iOS)
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
	#endif

	internal init(selectedTab: Binding<Tab>, isRemovingAll: Binding<Bool>) {
		self._selectedTab = selectedTab
		self._isRemovingAll = isRemovingAll
	}

	var body: some View {
		#if os(macOS)
		HomeView()
		#else
		SwiftUI.TabView(selection: $selectedTab) {
			HomeView()
				.toolbarBackground(visibility, for: placement)
				.tabForView(for: .home)
				.environment(\.horizontalSizeClass, sizeClass)
			SettingsView(isRemovingAll: $isRemovingAll)
				.toolbarBackground(visibility, for: placement)
				.tabForView(for: .settings)
				.environment(\.horizontalSizeClass, sizeClass)
		}
		.environment(\.horizontalSizeClass, .compact)
		#endif
	}
}
