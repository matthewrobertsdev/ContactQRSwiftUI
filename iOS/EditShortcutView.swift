//
//  EditShortcutView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/29/22.
//

import SwiftUI
import UIKit
import IntentsUI

struct EditShortcutView: UIViewControllerRepresentable {
	
	init(editShortCutViewController: INUIEditVoiceShortcutViewController?) {
		self.editShortCutViewController=editShortCutViewController
	}
	
	weak var editShortCutViewController: INUIEditVoiceShortcutViewController?

	
	func makeUIViewController(context: Context) -> UIViewController {
		return editShortCutViewController ?? UIViewController()
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
}
