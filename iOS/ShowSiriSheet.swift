//
//  ShowSiriSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/22/22.
//

import SwiftUI
import UIKit

struct ShowSiriSheet: View {
	@Binding var isVisible: Bool
    var body: some View {
		Text("Hello, World!").toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button(action: dismiss) {
					Text("Done")
				}
			}
		}
    }
	
	func dismiss() {
		isVisible=false
	}
}

class ShowSiriUIHostingController: UIHostingController<ShowSiriSheet> {
	
}

final class ShowSiriUIViewControllerRepresentable: UIViewControllerRepresentable {
	
	@Binding var isVisible: Bool
	
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	
	func makeUIViewController(context: Context) -> UINavigationController {
		let controller = UINavigationController(rootViewController: ShowSiriUIHostingController(rootView: ShowSiriSheet(isVisible: $isVisible)))
		
		controller.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismiss))
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
	}
	
	@objc func dismiss() {
		isVisible=false
	}
}

/*
struct ShowSiriSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShowSiriSheet()
    }
}
*/
