//
//  OnboardingController.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 07/06/2024.
//

import SwiftUI
import UIOnboarding

struct OnboardingView: UIViewControllerRepresentable {
	typealias UIViewControllerType = UIOnboardingViewController
	
	func makeUIViewController(context: Context) -> UIOnboardingViewController {
		let config = UIOnboardingViewConfiguration(
			appIcon: OnboardingController.setUpIcon(),
			firstTitleLine: OnboardingController.setUpFirstTitleLine(),
			secondTitleLine: OnboardingController.setUpSecondTitleLine(),
			features: OnboardingController.setUpFeatures(),
			textViewConfiguration: OnboardingController.setUpNotice(),
			buttonConfiguration: OnboardingController.setUpButton()
		)
		
		let onboardingVC = UIOnboardingViewController(withConfiguration: config)
		onboardingVC.delegate = context.coordinator
		
		return onboardingVC
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
	
	class Coordinator: NSObject, UIOnboardingViewControllerDelegate {
		func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {
			onboardingViewController.modalTransitionStyle = .coverVertical
			onboardingViewController.dismiss(animated: true) {
				UserDefaults.standard.set(false, forKey: "FIRST_LAUNCH")
			}
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return .init()
	}
}

struct OnboardingController {
	// App Icon
	static func setUpIcon() -> UIImage {
		return UIImage(named: "AppIcon") ?? .icon
	}
	
	// First Title Line
	// Welcome Text
	static func setUpFirstTitleLine() -> NSMutableAttributedString {
		.init(string: String(localized: "Welcome to"), attributes: [.foregroundColor: UIColor.accent])
	}
	
	// Second Title Line
	// App Name
	static func setUpSecondTitleLine() -> NSMutableAttributedString {
		.init(string: Bundle.main.displayName ?? "IPTV App", attributes: [
			.foregroundColor: UIColor.accent
		])
	}
	
	// Core Features
	static func setUpFeatures() -> [UIOnboardingFeature] {
		return .init([
			.init(icon: .init(systemName: "film.stack")!,
				  title: String(localized: "What your Movies or TV Channels"),
				  description: String(localized: "Import your playlists and watch TV and movies wherever you are.")),
			.init(icon: .init(systemName: "icloud")!,
				  title: String(localized: "iCloud Sync"),
				  description: String(localized: "Your playlists securely sync across all of your devices using iCloud.")),
			.init(icon: .init(systemName: "list.bullet.below.rectangle")!,
				  title: String(localized: "Electronic Program Guide"),
				  description: String(localized: "Stay informed with EPG, a digital TV guide for all upcoming programs."))
		])
	}
	
	// Notice Text
	static func setUpNotice() -> UIOnboardingTextViewConfiguration {
		return .init(icon: .init(systemName: "play.tv")!,
					 text: String(localized: "Designed with accessibility in mind."),
					 linkTitle: String(localized: "Learn more..."),
					 link: "https://github.com/lascic/UIOnboarding/",
					 tint: .accent)
	}
	
	// Continuation Title
	static func setUpButton() -> UIOnboardingButtonConfiguration {
		return .init(title: String(localized: "Continue"),
					 backgroundColor: .accent)
	}
}
