//
//  IntentHandler.swift
//  SelectContactIntentMacOS
//
//  Created by Matt Roberts on 3/13/22.
//
import Intents
import CoreData
class IntentHandler: INExtension, ConfigurationIntentHandling {
	override func handler(for intent: INIntent) -> Any? {
		return self
	}
	func resolveParameter(for intent: ConfigurationIntent, with completion:
							@escaping (ContactCardINObjectMacResolutionResult) -> Void) {
	}
	func provideParameterOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping
											(INObjectCollection<ContactCardINObjectMac>?, Error?) -> Void) {
		print("Should load choices")
		let container=loadPersistentCloudKitContainer()
		let managedObjectContext=container.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
		do {
			// Execute Fetch Request
			var contactCards = try managedObjectContext.fetch(fetchRequest)
			contactCards.sort { firstCard, secondCard in
				firstCard.filename<secondCard.filename
			}
			let contactCardINObjects=contactCards.map({(contactCard: ContactCardMO) -> ContactCardINObjectMac in
				return ContactCardINObjectMac(identifier: contactCard.objectID.uriRepresentation().absoluteString, display: contactCard.filename)
			})
			let collection = INObjectCollection(items: contactCardINObjects)
			print("Should have gotten choices")
			completion(collection, nil)
		} catch {
			print("Unable to fetch contact cards")
			completion(INObjectCollection(items: [ContactCardINObjectMac]()), nil)
		}
	}
}
