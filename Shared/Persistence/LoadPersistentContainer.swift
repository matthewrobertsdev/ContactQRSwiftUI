//
//  LoadPersistentContainer.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/6/21.
//
import Foundation
import CoreData
// MARK: Load Container
func loadPersistentCloudKitContainer() -> NSPersistentCloudKitContainer {
	//cloud kit container with entity name "ContactCards"
	let container=NSPersistentCloudKitContainer(name: "ContactCards")
	//app group name
	let groupIdentifier="group.com.apps.celeritas.contact.cards"
	//file url for app group
	if let fileContainerURL=FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) {
		//store url for sqlite database
		let storeURL=fileContainerURL.appendingPathComponent("ContactCards.sqlite")
		let storeDescription=NSPersistentStoreDescription(url: storeURL)
		//iCloud container identifier
		storeDescription.cloudKitContainerOptions=NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.apps.celeritas.ContactCards")
		//listen to remote changes
		let remoteChangeKey = NSPersistentStoreRemoteChangeNotificationPostOptionKey
		storeDescription.setOption(true as NSNumber,
										   forKey: remoteChangeKey)
		//track history
		storeDescription.setOption(true as NSObject, forKey: NSPersistentHistoryTrackingKey)
		//assign store description
		container.persistentStoreDescriptions=[storeDescription]
	}
	//reflect changes
	container.viewContext.automaticallyMergesChangesFromParent=true
	//trump merge policy
	container.viewContext.mergePolicy=NSMergeByPropertyObjectTrumpMergePolicy
	try? container.viewContext.setQueryGenerationFrom(.current)
	//load stores
	container.loadPersistentStores { (_, error) in
		print(error.debugDescription)
	}
	return container
}
