//
//  DeleteAllCardsViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/27/22.
//

import SwiftUI
import CloudKit
import CoreData
class DeleteAllCardsViewModel: ObservableObject {
	@Published var deleteTextFieldText = ""
	let deleteWarning = """
	Once you delete cards from iCloud, you will not be able to get \
	them back.  Confirm deleting by typing the word \"delete\" below \
	and then delete the cards by using the \"Delete All Cards From \
	iCloud\" button.  Please note that if your iCloud account is \
	restricted, the cards will not be deleted from iCloud until \
	you un-restrict access to iCloud and the app has time to sync \
	with iCloud.
	"""
	@Binding var showingAlert: Bool
	@Binding var alertType: ManageCardsAlertType?
	init(showingAlert: Binding<Bool>, alertType: Binding<ManageCardsAlertType?>) {
		_showingAlert=showingAlert
		_alertType=alertType
	}
	func tryToDeleteAllCards() {
		if deleteTextFieldText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "delete" {
			alertType = .deleteNotConfirmed
			showingAlert=true
		} else {
			let managedObjectContext=PersistenceController.shared.container.viewContext
			//Initialize Fetch Request
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactCard")
			//Configure Fetch Request
			fetchRequest.includesPropertyValues = false
			do {
				guard let items = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] else {
					return
				}
				for item in items {
					managedObjectContext.delete(item)
				}
				try managedObjectContext.save()
				alertType = .cardsDeleted
				showingAlert=true
			} catch {
				alertType = .deletionError
				showingAlert=true
			}
		}
	}
}
