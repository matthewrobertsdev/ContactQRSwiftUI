//
//  FillFieldsFromContact.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/1/22.
//

import Foundation
import Contacts
extension CardEditorViewModel {
	public func fillFromContact(contact: CNContact) {
		clearFields()
		fillFields(contact: contact)
	}
}
