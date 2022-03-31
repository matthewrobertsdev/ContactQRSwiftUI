//
//  ContactPickerView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/31/22.
//
import SwiftUI
import Contacts
import Combine

struct ContactPickerView: UIViewControllerRepresentable {
	weak var contactPickerViewDelegate: ContactPickerViewDelegate?
	
	init(contactPickerViewDelegate: ContactPickerViewDelegate) {
		self.contactPickerViewDelegate=contactPickerViewDelegate
	}
	
	typealias UIViewControllerType = ContactPickerViewController

	func makeUIViewController(context: UIViewControllerRepresentableContext<ContactPickerView>) -> ContactPickerView.UIViewControllerType {
		let result = ContactPickerView.UIViewControllerType()
		result.contactPickerDelegate = contactPickerViewDelegate
		return result
	}
	
	func updateUIViewController(_ uiViewController: ContactPickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ContactPickerView>) { }

}

class ContactPickerViewDelegate: NSObject, ObservableObject {
	@Published var showingContactPicker=false

	func contactPickerViewController(_ viewController: ContactPickerViewController, didSelect contact: CNContact) {
		withAnimation {
			showingContactPicker=false

		}
	}
	
	func contactPickerViewControllerDidCancel(_ viewController: ContactPickerViewController) {
		withAnimation {
			showingContactPicker=false

		}
	}
}
