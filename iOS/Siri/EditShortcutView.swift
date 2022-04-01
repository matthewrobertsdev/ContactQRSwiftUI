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
	
	init(editShortcutViewController: INUIEditVoiceShortcutViewController?) {
		self.editShortcutViewController=editShortcutViewController
	}
	
	weak var editShortcutViewController: INUIEditVoiceShortcutViewController?

	
	func makeUIViewController(context: Context) -> UIViewController {
		let controller=EditShortcutViewController()
		controller.editShortcutViewController=editShortcutViewController
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
}
