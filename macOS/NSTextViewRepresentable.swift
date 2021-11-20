//
//  NSTextViewRepresentable.swift
//  Contact Cards (macOS)
//
//  Created by Matt Roberts on 11/19/21.
//

/*
import Foundation
import SwiftUI
import AppKit
struct NSTextViewRepresentable<T: View>: NSViewRepresentable {
	@Binding var attributedString: NSAttributedString
	var content: () -> T

	func makeNSView(context: Context) -> NSTextView {
		let textView=NSTextView()
		textView.textStorage?.append(attributedString)
		return NSTextView()
	}

	func updateNSView(_ nsView: NSTextView, context: Context) {
		nsView.string=""
		nsView.textStorage?.append(attributedString)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(state: _attributedString, content: content)
	}

	class Coordinator: NSObject {
		private let state: Binding<NSAttributedString>

		init<V: View>(state: Binding<NSAttributedString>, content: @escaping () -> V) {
			self.state = state
			super.init()
		}
		
	}
}
*/


import SwiftUI
import AppKit
	struct NSTextViewRepresentable: NSViewRepresentable {

		let attributedString: NSAttributedString
		@Binding var size: CGSize
		
		func makeNSView(context: Context) -> NSTextView {
			let textView = NSTextView()

			textView.textContainer?.widthTracksTextView = true
			textView.textContainer?.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
			textView.drawsBackground = false
			textView.isEditable=false
			textView.alignment = .center
			return textView
		}

		func updateNSView(_ nsView: NSTextView, context: Context) {
			nsView.textStorage?.setAttributedString(attributedString)
			nsView.alignment = .center
			DispatchQueue.main.async {
				size = nsView.textStorage?.size() ?? .zero
			}
		}
	}
