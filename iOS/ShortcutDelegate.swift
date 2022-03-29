//
//  ShortcutDelegate.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/28/22.
//
import UIKit
import IntentsUI
class ShortcutDelegate: NSObject, INUIAddVoiceShortcutButtonDelegate,
						INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
	weak var navigationController: UINavigationController?
	init(navigationController: UINavigationController?) {
		self.navigationController = navigationController
	}
	func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		print("Should show add shortcut view controller")
		addVoiceShortcutViewController.delegate = self
		DispatchQueue.main.async { [weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.navigationController?.pushViewController(addVoiceShortcutViewController, animated: true)
		}
	}
	func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		print("Should show edit shortcut view controller")
		editVoiceShortcutViewController.delegate = self
		DispatchQueue.main.async { [weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.navigationController?.pushViewController(editVoiceShortcutViewController, animated: true)
		}
	}
	func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
		DispatchQueue.main.async {
			controller.navigationController?.popViewController(animated: true)
		}
		
	}
	func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
										didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
		DispatchQueue.main.async {
			controller.navigationController?.popViewController(animated: true)
		}
	}
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
										 didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
		DispatchQueue.main.async {
			controller.navigationController?.popViewController(animated: true)
		}
	}
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
										 didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
		DispatchQueue.main.async {
			controller.navigationController?.popViewController(animated: true)
		}
	}
	func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
		DispatchQueue.main.async {
			controller.navigationController?.popViewController(animated: true)
		}
	}
}
