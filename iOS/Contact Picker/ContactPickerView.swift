//
//  ContactPickerView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/31/22.
//
import SwiftUI
import Contacts
import Combine

#if os(iOS)
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
#endif

protocol ContactPickerViewDelegate: AnyObject {
	
	var showingContactPicker: Bool { get set }

	func contactPickerViewController(didSelect contact: CNContact)
	
	func contactPickerViewControllerDidCancel()
	
}
