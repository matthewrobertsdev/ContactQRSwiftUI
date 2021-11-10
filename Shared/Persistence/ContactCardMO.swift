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
//Contact Card Managed Object
class ContactCardMO: NSManagedObject, NSItemProviderWriting, Identifiable {
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
