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
