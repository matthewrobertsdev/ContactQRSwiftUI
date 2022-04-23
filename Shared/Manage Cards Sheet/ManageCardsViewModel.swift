//
//  ManageCardsViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/20/22.
//
import Foundation
import SwiftUI
class ManageCardsViewModel: ObservableObject {
	// MARK: Visibility State
	@Published var showingAboutiCloud=false
	@Published var showingArchiveExporter=false
	@Published var showingRTFDExporter=false
	@Published var showingMacFileExporter=false
	@Published var showingArchiveImporter=false
	@Binding var isVisible: Bool
	// MARK: Card Document
	@Published var cardsDocument: CardsDocument?=nil
	
	
	// MARK: init
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	// MARK: Export Archive
	func exportArchive() {
		let managedObjectContext=PersistenceController.shared.container.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
		do {
			var contactCards=[ContactCard]()
			let contactCardMOs = try managedObjectContext.fetch(fetchRequest)
			contactCardMOs.forEach { contactCardMO in
				contactCards.append(ContactCard(filename: contactCardMO.filename, vCardString: contactCardMO.vCardString, color: contactCardMO.color))
			}
			let encoder=JSONEncoder()
			encoder.outputFormatting = .prettyPrinted
			let cardsData=try encoder.encode(contactCards)
			cardsDocument=CardsDocument(json: cardsData)
		} catch {
			print("Unable to save contact cards")
		}
#if os(iOS)
		showingArchiveExporter=true
#elseif os(macOS)
		showingMacFileExporter=true
#endif
	}
	// MARK: Export RTFD
	func exportRTFD() {
		cardsDocument=CardsDocument(rtfd: "{}")
#if os(iOS)
		showingRTFDExporter=true
#elseif os(macOS)
		showingMacFileExporter=true
#endif
	}
}
