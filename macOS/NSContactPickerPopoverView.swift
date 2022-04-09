//
//  NSContactPickerPopoverView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/14/21.
//

import Foundation
import SwiftUI
import ContactsUI
import Contacts
//MARK: Contact Picker Mac
struct NSContactPickerPopoverView<T: View>: NSViewRepresentable {
	@Binding var isVisible: Bool
	weak var contactPickerDelegate: ContactPickerViewDelegate?
	var content: () -> T

	func makeNSView(context: Context) -> NSView {
		NSView()
	}

	func updateNSView(_ nsView: NSView, context: Context) {
		context.coordinator.setVisible(isVisible, in: nsView)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(isVisible: _isVisible, delegate: contactPickerDelegate, content: content)
	}

	class Coordinator: NSObject, CNContactPickerDelegate {
		private var contactPickerPopover: CNContactPicker
		private var isVisible: Binding<Bool>
		weak var delegate: ContactPickerViewDelegate?

		init<V: View>(isVisible: Binding<Bool>, delegate: ContactPickerViewDelegate?, content: @escaping () -> V) {
			contactPickerPopover = CNContactPicker()
			//contactPickerPopover.displayedKeys=[CNContactGivenNameKey, CNContactPhoneNumbersKey]
			self.isVisible = isVisible
			self.delegate=delegate
			super.init()
			contactPickerPopover.delegate=self
		}

		func setVisible(_ isVisible: Bool, in view: NSView) {
			if isVisible {
				DispatchQueue.main.async {  [weak self] in
					guard let strongSelf=self else {
						return
					}
					strongSelf.contactPickerPopover.showRelative(to: view.bounds, of: view, preferredEdge: .minY)
				}
			} else {
				DispatchQueue.main.async {  [weak self] in
					guard let strongSelf=self else {
						return
					}
					strongSelf.contactPickerPopover.close()
				}
			}
		}
		func contactPickerDidClose(_ picker: CNContactPicker) {
			self.isVisible.wrappedValue = false
		}

		func popoverShouldDetach(_ popover: NSPopover) -> Bool {
			false
		}
		func contactPicker(_ picker: CNContactPicker,
						   didSelect contact: CNContact) {
			print("inside contact picker")
			self.isVisible.wrappedValue = false
			delegate?.contactPickerViewController(didSelect: contact)
		}
	}
}
