//
//  ManageCardsViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/20/22.
//
import Foundation
import SwiftUI
import CoreData
import UniformTypeIdentifiers
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
	@Published var rtfdFileURL: URL?=nil
	@Published var documentType=UTType.json
	
	
	// MARK: init
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	// MARK: Export Archive
	func exportArchive() {
		cardsDocument=nil
		documentType=UTType.json
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
			print("Unable to creat cards archive")
		}
#if os(iOS)
		showingArchiveExporter=true
#elseif os(macOS)
		showingMacFileExporter=true
#endif
	}
	// MARK: Export RTFD
	func exportRTFD() {
		rtfdFileURL=nil
		cardsDocument=nil
		documentType=UTType.rtfd
		let managedObjectContext=PersistenceController.shared.container.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
		do {
			let contactCardMOs = try managedObjectContext.fetch(fetchRequest)
			let attributedString=CloudDataDescriber.getAttributedString(cards: contactCardMOs)
			if let attributedString = attributedString {
#if os(iOS)
			guard var rtfdFileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
					return
				}
				let data = try attributedString.fileWrapper(from: NSRange (location: 0, length: attributedString.length ), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
			rtfdFileURL.appendPathComponent("Contact Cards")
			rtfdFileURL.appendPathExtension("rtfd")
				try data.write(to: rtfdFileURL, options: .atomic, originalContentsURL: nil)
				self.rtfdFileURL=rtfdFileURL
#elseif os(macOS)
		cardsDocument=CardsDocument(rtfd: attributedString)
#endif
			}
		} catch {
			print("Unable to create cards RTFD document")
		}
#if os(iOS)
		showingRTFDExporter=true
#elseif os(macOS)
		showingMacFileExporter=true
#endif
	}
}
