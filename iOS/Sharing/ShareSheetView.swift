//
//  ShareSheetView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/16/22.
//
import SwiftUI
import UIKit

struct ShareSheetView: UIViewControllerRepresentable {
	
	var fileURL: URL?
	var isVisible: Binding<Bool>
	
	init(fileURL: URL?, isVisible: Binding<Bool>) {
		self.fileURL=fileURL
		self.isVisible=isVisible
	}

	func makeUIViewController(context: Context) -> UIViewController {
		let controller=ShareViewController()
		if let fileURL = fileURL {
			controller.activityViewController=UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
		}
		controller.activityViewController?.completionWithItemsHandler = { (_, _, _, _) in isVisible.wrappedValue=false }
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
}
