//
//  SaveDocumentViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/24/22.
//

import UIKit
import SwiftUI
class SaveDocumentViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
	var fileURL: URL?
	var handleDismiss={() -> () in
		return
	}
	override init(forExporting urls: [URL], asCopy: Bool) {
		fileURL=urls.first
		super.init(forExporting: urls, asCopy: true)
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
		guard let fileURL=fileURL else {
			return
		}
		let fileManager=FileManager.default
		try? fileManager.removeItem(at: fileURL)
	}
}
