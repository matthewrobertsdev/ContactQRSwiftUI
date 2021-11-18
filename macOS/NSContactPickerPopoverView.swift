//
//  NSContactPickerPopoverView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/14/21.
//

import Foundation
import SwiftUI
import ContactsUI
struct NSContactPickerPopoverView<T: View>: NSViewRepresentable {
	@Binding var isVisible: Bool
	var content: () -> T

	func makeNSView(context: Context) -> NSView {
		NSView()
	}

	func updateNSView(_ nsView: NSView, context: Context) {
		context.coordinator.setVisible(isVisible, in: nsView)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(state: _isVisible, content: content)
	}

	class Coordinator: NSObject, CNContactPickerDelegate {
		private var contactPickerPopover: CNContactPicker
		private let state: Binding<Bool>

		init<V: View>(state: Binding<Bool>, content: @escaping () -> V) {
			contactPickerPopover = CNContactPicker()
			self.state = state
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
				contactPickerPopover.close()
			}
		}
		

		func contactPickerDidClose(_ picker: CNContactPicker) {
			self.state.wrappedValue = false
		}

		func popoverShouldDetach(_ popover: NSPopover) -> Bool {
			false
		}
	}
}
