//
//  MockContactCardMO.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/25/22.
//

import Foundation
import Contacts
import CoreData
func mockContactCardMO(context: NSManagedObjectContext?, color: String, filename: String) -> ContactCardMO{
	return setFields(contactCardMO: ContactCardMO(entity: ContactCardMO.entity(), insertInto: context), filename: filename, cnContact: CNContact(), color: color)
}
