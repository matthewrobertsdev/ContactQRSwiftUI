//
//  SaveSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/24/22.
//
import SwiftUI
import UIKit
struct SaveSheetView: UIViewControllerRepresentable {
	
	var fileURL: URL?
	var isVisible: Binding<Bool>
	
	init(fileURL: URL?, isVisible: Binding<Bool>) {
		self.fileURL=fileURL
		self.isVisible=isVisible
	}

	func makeUIViewController(context: Context) -> UIViewController {
		let controller=SaveDocumentPresenterViewController()
		if let fileURL=fileURL {
			controller.saveDocumentViewController=SaveDocumentViewController(forExporting: [fileURL], asCopy: true)
			controller.saveDocumentViewController?.handleDismiss = {() -> () in
				isVisible.wrappedValue=false
				return
			}
		}
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
}
