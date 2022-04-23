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

class ContactPickerViewController: UIViewController {
	weak var contactPickerDelegate: ContactPickerViewDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.open(animated: animated)
	}
	private func open(animated: Bool) {
		let cnContactPicker = ContactPickerSubclassViewController()
		cnContactPicker.contactPickerDelegate=contactPickerDelegate
		self.present(cnContactPicker, animated: true)
	}
}
