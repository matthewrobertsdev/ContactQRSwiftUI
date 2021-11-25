//
//  CardPreviewViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//

import Foundation
class CardPreviewViewModel: ObservableObject {
	@Published var card=ContactCardMO()
	@Published var displayModel=[FieldInfoModel]()
	init(card: ContactCardMO) {
		self.card=card
		makeDisplayModel()
		ActiveContactCard.shared.card=card
	}
	// MARK: Make Display Model
	func makeDisplayModel() {
		do {
			guard let cnContact=try?
					ContactDataConverter.getCNContact(vCardString: card.vCardString)
			else {
				return
			}
			displayModel=ContactInfoManipulator.makeContactDisplayModel(cnContact: cnContact)
		}
	}
}
