//
//  ContactPickerViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/31/22.
//
import Foundation
import ContactsUI
import Contacts
import SwiftUI


class ContactPickerViewController: UIViewController, CNContactPickerDelegate {
	weak var contactPickerDelegate: ContactPickerViewDelegate?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.open(animated: animated)
	}
	
	private func open(animated: Bool) {
		let cnContactPicker = CNContactPickerViewController()
		cnContactPicker.delegate = self
		cnContactPicker.modalPresentationStyle = .fullScreen
		self.present(cnContactPicker, animated: false)
	}
	
	func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
		self.dismiss(animated: false) {
			self.contactPickerDelegate?.contactPickerViewControllerDidCancel(self)
		}
	}
	
	func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
		self.dismiss(animated: false) {
			self.contactPickerDelegate?.contactPickerViewController(self, didSelect: contact)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.contactPickerDelegate?.showingContactPicker=false
	}
	
}
