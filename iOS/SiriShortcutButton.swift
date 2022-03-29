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
	
	init(shortcutDelegate: ShortcutDelegate) {
		self.shortcutDelegate=shortcutDelegate
	}
	
	var shortcutDelegate: ShortcutDelegate?
	func makeUIView(context: Context) -> INUIAddVoiceShortcutButton {
		let shortcutButton = INUIAddVoiceShortcutButton(style: .automatic)
			let intent=ShowCardIntent()
			intent.suggestedInvocationPhrase = "Show Card"
		/*
			let interaction = INInteraction(intent: intent, response: nil)
			interaction.donate { (error) in
				if let error = error {
					print("\n Error: \(error.localizedDescription))")
				} else {
					print("\n Donated ShowCardItent")
				}
			}
		 */
			shortcutButton.shortcut=INShortcut(intent: intent)
			shortcutButton.delegate=shortcutDelegate
		return shortcutButton
	}
	
	func updateUIView(_ nsView: INUIAddVoiceShortcutButton, context: Context) {
	}
	
}
