//
//  DisplayQRModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/16/21.
//

import Foundation
import Contacts
import SwiftUI
/*
 Model for the displaying a qr
 */
class QRModel {
	private var contact=CNContact()
	private var contactCard: ContactCardMO?
	init() {
	}
	func setUp(contactCard: ContactCardMO?) {
		self.contactCard=contactCard
		guard let vCardString=contactCard?.vCardString else {
			return
		}
		do {
			let contact=try ContactDataConverter.getCNContact(vCardString: vCardString)
			if let contact=contact {
				self.contact=contact
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
	}
#if os(iOS)
	func makeQRCode() -> UIImage? {
		return ContactDataConverter.cnContactToQR_Code(cnContact: contact)
	}
#elseif os(macOS)
	func makeQRCode() -> NSImage? {
		return ContactDataConverter.cnContactToQR_Code(cnContact: contact)
	}
#endif
	func getContactCardTitle() -> String {
		if let filename=self.contactCard?.filename {
			return filename
		} else {
			return ""
		}
	}
}
