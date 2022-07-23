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
// MARK: Contact Card MO
class ContactCardMO: NSManagedObject, NSItemProviderWriting {
	// MARK: For Sharing
	//type for item provider
	static var writableTypeIdentifiersForItemProvider=["public.vcard"]
	//load vCardString as data for item provider
	func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
		completionHandler(vCardString.data(using: .unicode), nil)
		return nil
	}
	//MARK: Properties
	@NSManaged public var qrCodeImage: Data?
	@NSManaged public var filename: String
	@NSManaged public var vCardString: String
	@NSManaged public var color: String
	//managed object entity name
	static var entityName: String { return "ContactCard" }
	
	override public func willChangeValue(forKey key: String) {
			super.willChangeValue(forKey: key)
			self.objectWillChange.send()
		}
}
#if os(watchOS)
#else
//MARK: Assign to Fields
@discardableResult
func setFields(contactCardMO: ContactCardMO, filename: String, cnContact: CNContact, color: String) -> ContactCardMO {
	contactCardMO.filename=filename
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
	contactCardMO.color=color
	if let qrData=ContactDataConverter.getQRPNGData(vCardString: contactCardMO.vCardString) {
		contactCardMO.qrCodeImage=qrData
	}
	return contactCardMO
}
#endif

