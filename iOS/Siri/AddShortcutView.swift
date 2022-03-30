//
//  AddShortcutView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/29/22.
//

import SwiftUI
import UIKit
import IntentsUI

struct AddShortcutView: UIViewControllerRepresentable {
	
	init(addShortcutViewController: INUIAddVoiceShortcutViewController?) {
		self.addShortcutViewController=addShortcutViewController
	}
	
	weak var addShortcutViewController: INUIAddVoiceShortcutViewController?

	
	func makeUIViewController(context: Context) -> UIViewController {
		return addShortcutViewController ?? UIViewController()
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
}
