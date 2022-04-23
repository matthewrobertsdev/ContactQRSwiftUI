//
//  ShareSheetView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/16/22.
//
import SwiftUI
import UIKit

struct ShareSheetView: UIViewControllerRepresentable {
	
	var text=""
	var isVisible: Binding<Bool>
	
	init(text: String, isVisible: Binding<Bool>) {
		self.text=text
		self.isVisible=isVisible
	}

	func makeUIViewController(context: Context) -> UIViewController {
		let controller=ShareViewController()
		controller.activityViewController=UIActivityViewController(activityItems: [text], applicationActivities: nil)
		controller.activityViewController?.completionWithItemsHandler = { (_, _, _, _) in isVisible.wrappedValue=false }
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
}
