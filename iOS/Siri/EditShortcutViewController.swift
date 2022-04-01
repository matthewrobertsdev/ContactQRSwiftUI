//
//  EditShortcutViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/1/22.
//
import UIKit
import IntentsUI
class EditShortcutViewController: UIViewController {
	
	var editShortcutViewController: INUIEditVoiceShortcutViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UIDevice.current.userInterfaceIdiom == .phone {
			editShortcutViewController?.modalPresentationStyle = .fullScreen
		}
		self.open(animated: animated)
	}
	
	private func open(animated: Bool) {
		if let editShortcutViewController = editShortcutViewController {
			self.present(editShortcutViewController, animated: true)
		}
	}
	
}
