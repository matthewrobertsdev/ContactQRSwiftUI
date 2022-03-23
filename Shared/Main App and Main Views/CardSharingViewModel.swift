//
//  VCardViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/17/22.
//
#if os(macOS)
import AppKit
#endif
import Foundation
class CardSharingViewModel: ObservableObject {
	@Published var vCard: VCardDocument?
	@Published var filename=""
	@Published var cardFileArray = [URL]()
	@Published var fileUrl: URL?
#if os(macOS)
	@Published var sharingItems=[NSSharingService]()
#endif
	// MARK: Update Model
	func update(card: ContactCardMO?) {
		vCard=nil
		cardFileArray=[URL]()
#if os(macOS)
		sharingItems=[NSSharingService]()
#endif
		guard let contactCard=card else {
			return
		}
		DispatchQueue.main.async { [weak self] in
			if let strongSelf=self {
				strongSelf.updateSharing(card: contactCard)
			}
		}
	}
	func updateSharing(card: ContactCardMO) {
		assignSharingFile(card: card)
		vCard=VCardDocument(vCard: card.vCardString)
		filename=card.filename
#if os(macOS)
		sharingItems=NSSharingService.sharingServices(forItems: cardFileArray)
#endif
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
