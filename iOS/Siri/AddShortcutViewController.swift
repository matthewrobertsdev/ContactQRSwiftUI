//
//  AddShortcutViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/1/22.
//
import UIKit
import IntentsUI
class AddShortcutViewController: UIViewController {
	
	var addShortcutViewController: INUIAddVoiceShortcutViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UIDevice.current.userInterfaceIdiom == .phone {
			addShortcutViewController?.modalPresentationStyle = .fullScreen
		}
		self.open(animated: animated)
	}
	
	private func open(animated: Bool) {
		if let addShortcutViewController = addShortcutViewController {
			self.present(addShortcutViewController, animated: true)
		}
	}
	
}
