//
//  UpdateSiriCard.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/30/22.
//
import Foundation
import SwiftUI
func updateSiriCard(contactCard: ContactCardMO?) {
	if let card=contactCard {
		UserDefaults(suiteName: appGroupKey)?.set(card.color, forKey: SiriCardKeys.chosenCardColor.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(card.qrCodeImage, forKey: SiriCardKeys.chosenCardImageData.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(card.objectID.uriRepresentation().absoluteString, forKey: SiriCardKeys.chosenCardObjectID.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(card.filename, forKey: SiriCardKeys.chosenCardTitle.rawValue)
	} else {
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardColor.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardImageData.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardObjectID.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardTitle.rawValue)
	}
}
