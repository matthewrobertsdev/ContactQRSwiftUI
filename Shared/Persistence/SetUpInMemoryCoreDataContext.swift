//
//  SetUpInMemoryCoreDataContext.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/25/22.
//

import Foundation
import CoreData
func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext? {
	guard let modelURL = Bundle.main.url(forResource: "ContactCards", withExtension: "xcdatamodeld") else {
		return nil
	}
	guard let managedObjectModel=NSManagedObjectModel(contentsOf: modelURL) else {
		return nil
	}
	let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
	do {
		try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
	} catch {
		print("Adding in-memory persistent store failed")
	}

	let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
	managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
	return managedObjectContext
}
