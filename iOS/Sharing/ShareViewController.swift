//
//  ShareViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/16/22.
//

import UIKit

class ShareViewController: UIViewController {

	var activityViewController: UIActivityViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.open(animated: animated)
	}
	
	private func open(animated: Bool) {
		if let activityViewController = activityViewController {
			DispatchQueue.main.async {
				self.present(activityViewController, animated: true)
			}
		}
	}

}
