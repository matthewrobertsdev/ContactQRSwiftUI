//
//  WatchCardViewModel.swift
//  Contact Cards (watchOS) WatchKit Extension
//
//  Created by Matt Roberts on 7/22/22.
//

import Foundation
import SwiftUI
class WatchCardViewModel: ObservableObject {
	@Published var fieldInfoModels=[FieldInfoModel]()
	@Binding var selectedCard: ContactCardMO?
	init(selectedCard: Binding<ContactCardMO?>) {
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
	func update(card: ContactCardMO?) {
		guard let contactCard=card else {
			return
		}
		updatePreview(card: contactCard)
	}
	func updatePreview(card: ContactCardMO) {
		fieldInfoModels=makeDisplayModel(card: card)

	}
}
