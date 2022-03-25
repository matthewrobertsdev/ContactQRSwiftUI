//
//  AddShortcutButton.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/25/22.
//
import SwiftUI
import UIKit
import IntentsUI

struct SiriShortcutButton: UIViewRepresentable {
	
	func makeUIView(context: Context) -> INUIAddVoiceShortcutButton {
		let shortcutButton = INUIAddVoiceShortcutButton(style: .automatic)
		return shortcutButton
	}

	func updateUIView(_ nsView: INUIAddVoiceShortcutButton, context: Context) {
	}

}
