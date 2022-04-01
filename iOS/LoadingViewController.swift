//
//  LoadingViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/31/22.
//

import UIKit

class LoadingViewController: UIViewController {
	
	let activityIndicatorView=UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
		activityIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
		activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
		activityIndicatorView.translatesAutoresizingMaskIntoConstraints = true
		view.addSubview(activityIndicatorView)
		activityIndicatorView.startAnimating()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		activityIndicatorView.stopAnimating()
	}

}
