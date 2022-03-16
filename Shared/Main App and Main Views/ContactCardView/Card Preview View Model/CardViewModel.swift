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
	@Published var cardFileArray = [URL]()
	@Published var fileUrl: URL?
	@Published var vCard: VCardDocument?
	@Binding var selectedCard: ContactCardMO?
	private var context: NSManagedObjectContext
	init(context: NSManagedObjectContext, selectedCard: Binding<ContactCardMO?>) {
		self.context=context
		_selectedCard=selectedCard
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
	func update(card: ContactCardMO) {
		cardFileArray=[URL]()
		vCard=nil
		updatePreview(card: card)
		DispatchQueue.main.async { [weak self] in
			if let strongSelf=self {
				strongSelf.updateSharing(card: card)
			}
		}
	}
	func updatePreview(card: ContactCardMO) {
		fieldInfoModels=makeDisplayModel(card: card)

	}
	func updateSharing(card: ContactCardMO) {
		assignSharingFile(card: card)
		vCard=VCardDocument(vCard: card.vCardString)
	}
	// MARK: Sharing vCard
	func assignSharingFile(card: ContactCardMO) {
		guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
			return
		}
		fileUrl=ContactDataConverter.writeTemporaryFile(contactCard: card, directoryURL: directoryURL, useCardName: false)
		guard let fileURL=fileUrl else {
			return
		}
		cardFileArray=[fileURL]
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
#if os(macOS)
	// MARK: Copying vCard
	func writeToPasteboard() {
		NSPasteboard.general.clearContents()
		guard let fileUrl=fileUrl else {
			return
		}
		NSPasteboard.general.setData(fileUrl.dataRepresentation, forType: .fileURL)
	}
#endif
}
