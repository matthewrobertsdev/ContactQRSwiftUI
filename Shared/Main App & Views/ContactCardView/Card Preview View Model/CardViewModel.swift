//
//  CardPreviewViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//

import Foundation
import CoreData
import SwiftUI
class CardViewModel: ObservableObject {
	@Published var fieldInfoModels=[FieldInfoModel]()
	@Published var filename = ""
	@Published var color = ""
	@Binding var selectedCard: ContactCardMO?
	private var context: NSManagedObjectContext
	init(context: NSManagedObjectContext, selectedCard: Binding<ContactCardMO?>) {
		self.context=context
		_selectedCard=selectedCard
		NotificationCenter.default.addObserver(forName: .deleteCard, object: nil, queue: .main) { [weak self] _ in
			guard let strongSelf = self else {
				return
			}
			strongSelf.deleteCard()
		}
	}
	// MARK: Make Display Model
	func makeDisplayModel(card: ContactCardMO) -> [FieldInfoModel] {
		do {
			guard let cnContact=try?
					ContactDataConverter.getCNContact(vCardString: card.vCardString)
			else {
				return [FieldInfoModel]()
			}
			return ContactInfoManipulator.makeContactDisplayModel(cnContact: cnContact)
		}
	}
	// MARK: Update Model
	func update(card: Binding<ContactCardMO?>) {
		_selectedCard = card
		updatePreview(card: selectedCard)
	}
	func updatePreview(card: ContactCardMO?) {
		if let card = card {
			filename = card.filename
			color = card.color
			fieldInfoModels=makeDisplayModel(card: card)
		}

	}
	// MARK: Delete Card
	func deleteCard() {
		if let card=selectedCard {
			context.delete(card)
			do {
				try context.save()
			} catch {
				context.rollback()
				print("Error trying to save deletion of contact card.")
			}
			selectedCard=nil
		}
	}
}
