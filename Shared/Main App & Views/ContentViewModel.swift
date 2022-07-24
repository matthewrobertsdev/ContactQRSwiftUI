//
//  ContentViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/23/22.
//

import CoreData

class ContentViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
	@Published var cards: [ContactCardMO] = []

	let fetchedResultsController: NSFetchedResultsController<ContactCardMO>

	init(context: NSManagedObjectContext) {
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
		fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ContactCardMO.filename, ascending: true)]

		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		super.init()
		fetchedResultsController.delegate = self

		do {
			try fetchedResultsController.performFetch()
			cards = fetchedResultsController.fetchedObjects ?? []
		} catch {
			print("Fetch failed")
		}

	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		cards = fetchedResultsController.fetchedObjects ?? []
	}
}
