//
//  IntentViewController.swift
//  ShowCardSiriIntentUI
//
//  Created by Matt Roberts on 3/30/22.
//

import IntentsUI
import SwiftUI
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.
class IntentViewController: UINavigationController, INUIHostedViewControlling {
	override func viewDidLoad() {
		super.viewDidLoad()
		setNavigationBarHidden(true, animated: false)
		setViewControllers([UIHostingController(rootView: SiriQRView())], animated: false)
		setNavigationBarHidden(true, animated: false)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}
	// MARK: - INUIHostedViewControlling
	// Prepare your view controller for the interaction to handle.
	func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior,
					   context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
		// Do configuration here, including preparing views and calculating a desired size for presentation.
		completion(true, parameters, self.desiredSize)
	}
	var desiredSize: CGSize {
		let screenSize=UIScreen.main.bounds
		var smaller: CGFloat
		var greater: CGFloat
		if screenSize.width<screenSize.height {
			greater=screenSize.height
		} else {
			greater=screenSize.width
		}
		smaller=greater*(9/20)
		if 340<smaller {
			smaller=340
		}
		return CGSize(width: 300, height: smaller)
	}
}


