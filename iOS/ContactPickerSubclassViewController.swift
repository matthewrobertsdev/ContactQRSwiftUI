//
//  ContactPickerSubclassViewController.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/1/22.
//

import UIKit
import ContactsUI

class ContactPickerSubclassViewController: CNContactPickerViewController, CNContactPickerDelegate {
	
	weak var contactPickerDelegate: ContactPickerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
		delegate=self
        // Do any additional setup after loading the view.
    }
	
	func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
		print("cancelled")
		self.contactPickerDelegate?.contactPickerViewControllerDidCancel()
		self.dismiss(animated: true)
	}
	
	func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
		print("Contact selected")
		self.contactPickerDelegate?.contactPickerViewController(didSelect: contact)
		self.dismiss(animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.contactPickerDelegate?.showingContactPicker=false
		//activityIndicatorView.stopAnimating()
	}
    

	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
