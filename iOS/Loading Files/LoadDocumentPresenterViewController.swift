//
//  LoadDocumentPresenterViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 5/22/22.
//

import UIKit

class LoadDocumentPresenterViewController: UIViewController {

	var loadDocumentViewController: LoadDocumentViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.open(animated: animated)
	}
	
	private func open(animated: Bool) {
		if let loadDocumentViewController = loadDocumentViewController {
			DispatchQueue.main.async {
				self.present(loadDocumentViewController, animated: true)
			}
		}
	}

}
