//
//  LoadSheetView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 5/22/22.
//

import SwiftUI
import UIKit
struct LoadSheetView: UIViewControllerRepresentable {
	
	var loadHandler = {(url: URL) -> () in
		return
	}
	var isVisible: Binding<Bool>
	
	init(loadHandler: @escaping (URL) -> Void, isVisible: Binding<Bool>) {
		self.loadHandler=loadHandler
		self.isVisible=isVisible
	}
	
	func makeUIViewController(context: Context) -> UIViewController {
		let controller=LoadDocumentPresenterViewController()
		controller.loadDocumentViewController=LoadDocumentViewController(forOpeningContentTypes: [.json, .plainText], asCopy: false)
		if UIDevice.current.userInterfaceIdiom == .phone {
			controller.loadDocumentViewController?.modalPresentationStyle = .fullScreen
		}
		controller.loadDocumentViewController?.handleDismiss = {() -> () in
			isVisible.wrappedValue=false
			return
		}
		controller.loadDocumentViewController?.handleLoad = loadHandler
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
}
