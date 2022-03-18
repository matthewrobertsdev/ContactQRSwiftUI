//
//  VCardViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/17/22.
//

import Foundation
class VCardViewModel: ObservableObject {
	@Published var vCard: VCardDocument?
	@Published var filename=""

	// MARK: Update Model
	func update(card: ContactCardMO?) {
		vCard=nil
		filename=""
		guard let card=card else {
			return
		}
		DispatchQueue.main.async { [weak self] in
			if let strongSelf=self {
				strongSelf.vCard=VCardDocument(vCard: card.vCardString)
				strongSelf.filename=card.filename
			}
		}
	}
}
