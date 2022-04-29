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
	@Published var jsonArchiveUrl: URL?=nil
	@Published var rtfdFileURL: URL?=nil
	@Published var documentType=UTType.json
	// MARK: init
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	// MARK: Export Archive
	func exportArchive() {
		jsonArchiveUrl=nil
		cardsDocument=nil
		documentType=UTType.json
		let managedObjectContext=PersistenceController.shared.container.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
		do {
			let contactCardMOs = try managedObjectContext.fetch(fetchRequest)
			let contactCards=ContactDataConverter.convertToContactCards(managedObjects: contactCardMOs)
			let cardsData=try ContactDataConverter.encodeData(contactCards: contactCards)
#if os(iOS)
			let jsonArchiveUrl=try FileWorker.getUrlInCachesDirectory(filename: "Contact Cards", fileExtension: "json")
			try cardsData.write(to: jsonArchiveUrl)
			self.jsonArchiveUrl=jsonArchiveUrl
#elseif os(macOS)
		cardsDocument=CardsDocument(json: cardsData)
#endif
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
				let rtfdFileWrapper = try FileWorker.getRtfdFileWrapper(attributedString: attributedString)
				let rtfdFileUrl=try FileWorker.getUrlInCachesDirectory(filename: "Contact Cards", fileExtension: "rtfd")
				try rtfdFileWrapper.write(to: rtfdFileUrl, options: .atomic, originalContentsURL: nil)
				self.rtfdFileURL=rtfdFileUrl
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
