//
//  ActiveContactCard.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/24/21.
//

import Foundation
// MARK: ActiveContactCard
class ActiveContactCard {
	static let shared=ActiveContactCard()
	private init() {
	}
	var card: ContactCardMO?
}
