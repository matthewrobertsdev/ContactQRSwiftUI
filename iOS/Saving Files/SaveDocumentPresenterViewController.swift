//
//  SaveDocumentPresenterViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/24/22.
//
import UIKit
class SaveDocumentPresenterViewController: UIViewController {

	var saveDocumentViewController: SaveDocumentViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.open(animated: animated)
	}
	
	private func open(animated: Bool) {
		if let saveDocumentViewController = saveDocumentViewController {
			DispatchQueue.main.async {
				self.present(saveDocumentViewController, animated: true)
			}
		}
	}

}
