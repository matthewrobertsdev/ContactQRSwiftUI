//
//  CardPreviewViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//

import Foundation
class CardPreviewViewModel: ObservableObject {
	@Published var card=ContactCardMO()
	@Published var attributedString=NSAttributedString(string:"")
	init(card: ContactCardMO) {
		self.card=card
		getAttributedString()
	}
	func getAttributedString() {
		do {
			guard let attributedString=try?
			ContactInfoManipulator.makeContactDisplayString(cnContact:ContactDataConverter.getCNContact(vCardString: card.vCardString), fontSize: 20)
			else {
				return
			}
			self.attributedString=attributedString
		}
	}
}
