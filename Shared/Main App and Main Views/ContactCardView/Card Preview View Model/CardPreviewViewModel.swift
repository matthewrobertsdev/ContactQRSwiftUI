//
//  CardPreviewViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//

import Foundation
class CardPreviewViewModel: ObservableObject {
	@Published var fieldInfoModels=[FieldInfoModel]()
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
	func update(card: ContactCardMO) {
		fieldInfoModels=makeDisplayModel(card: card)
	}
}
