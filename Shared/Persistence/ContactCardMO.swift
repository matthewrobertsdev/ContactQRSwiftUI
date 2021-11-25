//
//  ContactCardMO.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/22/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
import CoreData
import Contacts
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
//Contact Card Managed Object
class ContactCardMO: NSManagedObject, NSItemProviderWriting {
	//type for item provider
	static var writableTypeIdentifiersForItemProvider=["public.vcard"]
	//load vCardString as data for item provider
	func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
		completionHandler(vCardString.data(using: .unicode), nil)
		return nil
	}
	//properties
	@NSManaged public var qrCodeImage: Data?
	@NSManaged public var filename: String
	@NSManaged public var vCardString: String
	@NSManaged public var color: String
	//managed object entity name
	static var entityName: String { return "ContactCard" }
}
func setFields(contactCardMO: ContactCardMO, filename: String, cnContact: CNContact, color: String) {
	contactCardMO.filename=filename
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
	contactCardMO.color=color
	setQRCode(contactCardMO: contactCardMO)
}
func setQRCode(contactCardMO: ContactCardMO) {
#if os(iOS)
	if let qrData=ContactDataConverter.getQRPNGData(vCardString: contactCardMO.vCardString) {
		contactCardMO.qrCodeImage=qrData
	}
#elseif os(macOS)
	if let qrData=ContactDataConverter.getQRPNGData(vCardString: contactCardMO.vCardString) {
		contactCardMO.qrCodeImage=qrData
	}
#endif
}

