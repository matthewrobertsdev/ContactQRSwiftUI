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

class ContactCardMO: NSManagedObject, NSItemProviderWriting, Identifiable {
	static var writableTypeIdentifiersForItemProvider=["public.vcard"]
	func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
		completionHandler(vCardString.data(using: .unicode), nil)
		return nil
	}
	@NSManaged public var qrCodeImage: Data?
	@NSManaged public var filename: String
	@NSManaged public var vCardString: String
	@NSManaged public var color: String
	static var entityName: String { return "ContactCard" }
}
