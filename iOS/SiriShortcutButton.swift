//
//  AddShortcutButton.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/25/22.
//
import SwiftUI
import UIKit
import IntentsUI

final class SiriShortcutButton: UIViewRepresentable {
	init (navigationController: UINavigationController?) {
		self.navigationController=navigationController
	}
	
	weak var navigationController: UINavigationController?
	var shortCutDelegate: ShortcutDelegate?
	func makeUIView(context: Context) -> INUIAddVoiceShortcutButton {
		let shortcutButton = INUIAddVoiceShortcutButton(style: .automatic)
		if let navigationController = navigationController {
			let intent=ShowCardIntent()
			intent.suggestedInvocationPhrase = "Show Card"
			let interaction = INInteraction(intent: intent, response: nil)
			interaction.donate { (error) in
				if let error = error {
					print("\n Error: \(error.localizedDescription))")
				} else {
					print("\n Donated ShowCardItent")
				}
			}
			shortcutButton.shortcut=INShortcut(intent: intent)
			shortCutDelegate=ShortcutDelegate(navigationController: navigationController)
			shortcutButton.delegate=shortCutDelegate
		}
		return shortcutButton
	}
	
	func updateUIView(_ nsView: INUIAddVoiceShortcutButton, context: Context) {
	}
	
}
