//
//  LoadDocumentViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 5/22/22.
//

import UIKit
import UniformTypeIdentifiers
class LoadDocumentViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
	var handleDismiss={() -> () in
		return
	}
	var handleLoad={(url: URL) -> () in
		return
	}
	override init(forOpeningContentTypes contentTypes: [UTType], asCopy: Bool) {
		super.init(forOpeningContentTypes: contentTypes, asCopy: asCopy)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		handleDismiss()
		delegate=self
	}
	func documentPicker(_ controller: UIDocumentPickerViewController,
						didPickDocumentsAt urls: [URL]) {
		if let url=urls.first {
			handleLoad(url)
		}
	}
}
