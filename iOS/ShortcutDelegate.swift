//
//  ShortcutDelegate.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/28/22.
//
import UIKit
import IntentsUI
import SwiftUI
class ShortcutDelegate: NSObject, ObservableObject, INUIAddVoiceShortcutButtonDelegate,
						INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
	@Published var showingAddShortcutViewController=false
	@Published var showingEditShortcutViewController=false
	@Published var addShortcutViewController: INUIAddVoiceShortcutViewController?
	@Published var editShortcutViewController: INUIEditVoiceShortcutViewController?
	
	func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		print("Should show add shortcut view controller")
		addVoiceShortcutViewController.delegate = self
		DispatchQueue.main.async { [weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.addShortcutViewController=addVoiceShortcutViewController
			strongSelf.showingAddShortcutViewController=true
			/*
			strongSelf.navigationController?.pushViewController(addVoiceShortcutViewController, animated: true)
			 */
		}
	}
	func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		print("Should show edit shortcut view controller")
		editVoiceShortcutViewController.delegate = self
		DispatchQueue.main.async { [weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.editShortcutViewController=editVoiceShortcutViewController
			strongSelf.showingEditShortcutViewController=true
		}
	}
	func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
		
		DispatchQueue.main.async {[weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.showingAddShortcutViewController=false
		}
		
	}
	func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
										didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
		DispatchQueue.main.async {[weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.showingAddShortcutViewController=false
		}
	}
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
										 didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
		DispatchQueue.main.async {[weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.showingEditShortcutViewController=false
		}
	}
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
										 didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
		DispatchQueue.main.async {[weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.showingEditShortcutViewController=false
		}
	}
	func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
		DispatchQueue.main.async {[weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.showingEditShortcutViewController=false
		}
	}
}
