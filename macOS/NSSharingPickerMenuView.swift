//
//  NSSharingServicePickerMenuView.swift
//  Contact Cards (macOS)
//
//  Created by Matt Roberts on 11/30/21.
//

import Foundation
import SwiftUI
import AppKit
//MARK: SHaring Picker Mac
struct NSSharingPickerMenuView<T: View>: NSViewRepresentable {
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

	class Coordinator: NSObject, NSSharingServicePickerDelegate {
		private var sharingPickerMenu: NSSharingServicePicker
		private let state: Binding<Bool>

		init<V: View>(state: Binding<Bool>, content: @escaping () -> V) {
			sharingPickerMenu = NSSharingServicePicker(items: [])
			self.state = state
			super.init()
			sharingPickerMenu.delegate=self
		}

		func setVisible(_ isVisible: Bool, in view: NSView) {
			if isVisible {
				DispatchQueue.main.async {  [weak self] in
					guard let strongSelf=self else {
						return
					}
					strongSelf.sharingPickerMenu.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
				}
			}
		}
	}
}
