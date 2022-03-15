//
//  CardEditorViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/12/21.
//
import Foundation
import SwiftUI
import CoreData
//view model for card editor
class CardEditorViewModel: ObservableObject {
	private var viewContext: NSManagedObjectContext
	var forEditing=false
	private var card: ContactCardMO?
	@Binding private var selectedCard: ContactCardMO?
	@Binding var showingEmptyTitleAlert: Bool
	init(viewContext: NSManagedObjectContext, forEditing: Bool, card: ContactCardMO?, showingEmptyTitleAlert: Binding<Bool>, selectedCard: Binding<ContactCardMO?>) {
		self.viewContext=viewContext
		self.forEditing=forEditing
		self.card=card
		if let theCard=card {
			print("Card: "+theCard.filename)
		}
		self._showingEmptyTitleAlert=showingEmptyTitleAlert
		self._selectedCard=selectedCard
		if forEditing {
			fillFromCard(card: card)
		} else {
			selectableColorModels[0].selected=true
		}
	}
	// MARK: Sheet Title
	func getTitle() -> String {
#if os(iOS)
		if forEditing {
			return "Edit Card"
		} else {
			return "New Card"
		}
#elseif os(macOS)
		if forEditing {
			return "Edit Card:"
		} else {
			return "Add Card:"
		}
#endif
	}
	// MARK: Card Title
	@Published var cardTitle=""
	// MARK: Card Color
	@Published var cardColor="Contrasting Color"
	// MARK: Name
	@Published var firstName=""
	@Published var lastName=""
	@Published var prefixString=""
	@Published var suffix=""
	@Published var nickname=""
	// MARK: Company
	@Published var company=""
	@Published var jobTitle=""
	@Published var department=""
	// MARK: Phones
	@Published var mobilePhone=""
	@Published var workPhone1=""
	@Published var workPhone2=""
	@Published var homePhone=""
	@Published var otherPhone=""
	// MARK: Emails
	@Published var homeEmail=""
	@Published var workEmail1=""
	@Published var workEmail2=""
	@Published var otherEmail=""
	// MARK: Social Profiles
	@Published var twitterUsername=""
	@Published var facebookUrl=""
	@Published var linkedInUrl=""
	@Published var whatsAppNumber=""
	@Published var instagramUsername=""
	@Published var snapchatUsername=""
	@Published var pinterestUsername=""
	// MARK: URLs
	@Published var homeUrl=""
	@Published var workUrl1=""
	@Published var workUrl2=""
	@Published var otherUrl1=""
	@Published var otherUrl2=""
	//a MARK: Addresses
	//home address
	@Published var homeStreetAddress=""
	@Published var homeCity=""
	@Published var homeState=""
	@Published var homeZip=""
	//work address
	@Published var workStreetAddress=""
	@Published var workCity=""
	@Published var workState=""
	@Published var workZip=""
	//other address
	@Published var otherStreetAddress=""
	@Published var otherCity=""
	@Published var otherState=""
	@Published var otherZip=""
	// MARK: Save
	func saveContact() -> Bool {
		let titleCopy=cardTitle
		if titleCopy.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)=="" {
			showingEmptyTitleAlert.toggle()
			return false
		}
		let contact=getContactFromFields()
		// MARK: Create New Card
		if forEditing==false {
			let cardEntity=NSEntityDescription.entity(forEntityName: ContactCardMO.entityName, in: viewContext)
			guard let cardEntity=cardEntity else {
				return true
			}
			let contactCard=ContactCardMO(entity: cardEntity, insertInto: viewContext)
			setFields(contactCardMO: contactCard, filename: cardTitle, cnContact: contact, color: cardColor)
			// MARK: Save New Card
			do {
				try viewContext.save()
				selectedCard=contactCard
				return true
			} catch {
				print("Couldn't save contact")
			}
		// MARK: Update Old Card
		} else {
			guard let card=card else {
				return false
			}
			setFields(contactCardMO: card, filename: cardTitle, cnContact: contact, color: cardColor)
			// MARK: Save New Card
			do {
				try viewContext.save()
				return true
			} catch {
				print("Couldn't save contact")
			}
		}
		/*
			updateWidget(contactCard: self.contactCard)
			updateSiri(contactCard: self.contactCard)
		 */
		return false
	}
	
	// MARK: Color Model
	@Published var selectableColorModels=[SelectableColorModel(string: "Contrasting Color"), SelectableColorModel(string: "Gray"), SelectableColorModel(string: "Red"), SelectableColorModel(string: "Orange"), SelectableColorModel(string: "Yellow"), SelectableColorModel(string: "Green"), SelectableColorModel(string: "Blue"), SelectableColorModel(string: "Purple"), SelectableColorModel(string: "Pink"), SelectableColorModel(string: "Brown")]
	// MARK: Deslect All
	public func deselectAllColors() {
		selectableColorModels.indices.forEach {
			selectableColorModels[$0].selected = false
		}

	}
}
