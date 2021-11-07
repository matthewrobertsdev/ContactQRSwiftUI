//
//  LoadPersistentContainer.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/6/21.
//
import Foundation
import CoreData
func loadPersistentCloudKitContainer() -> NSPersistentCloudKitContainer {
	let container=NSPersistentCloudKitContainer(name: "ContactCards")
	let groupIdentifier="group.com.apps.celeritas.contact.cards"
	if let fileContainerURL=FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) {
		let storeURL=fileContainerURL.appendingPathComponent("ContactCards.sqlite")
		let storeDescription=NSPersistentStoreDescription(url: storeURL)
		storeDescription.cloudKitContainerOptions=NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.apps.celeritas.ContactCards")
		let remoteChangeKey = NSPersistentStoreRemoteChangeNotificationPostOptionKey
		storeDescription.setOption(true as NSNumber,
										   forKey: remoteChangeKey)
		storeDescription.setOption(true as NSObject, forKey: NSPersistentHistoryTrackingKey)
		container.persistentStoreDescriptions=[storeDescription]
	}
	container.viewContext.automaticallyMergesChangesFromParent=true
	container.viewContext.mergePolicy=NSMergeByPropertyObjectTrumpMergePolicy
	try? container.viewContext.setQueryGenerationFrom(.current)
	container.loadPersistentStores { (_, error) in
		print(error.debugDescription)
	}
	return container
}
