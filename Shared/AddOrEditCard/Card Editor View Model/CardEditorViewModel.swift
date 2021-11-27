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
	private var forEditing=false
	private var card: ContactCardMO?
	init(viewContext: NSManagedObjectContext, forEditing: Bool, card: ContactCardMO?) {
		self.viewContext=viewContext
		self.forEditing=forEditing
		self.card=card
		if forEditing {
			fillFromCard(card: card)
		}
	}
	// MARK: card title
	@Published var cardTitle=""
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
	func saveContact() {
		//let titleCopy=cardTitle
		/*
		if titleCopy.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)=="" {
			let emptyTitleMessage="Card title must not be blank."
			let emptyTitleAlert = UIAlertController(title: "Title Required",
												message: emptyTitleMessage, preferredStyle: .alert)
			let emptyTitleAction=UIAlertAction(title: NSLocalizedString("Got it.",
																	comment: "Empty title Action"), style: .default, handler: { [weak self] _ in
																		  guard let strongSelf=self else {
																			  return
											}
				strongSelf.fieldsScrollView.scrollRectToVisible(strongSelf.chooseTitleLabel.frame, animated: true)
			})
			emptyTitleAlert.addAction(emptyTitleAction)
			emptyTitleAlert.preferredAction=emptyTitleAction
			self.navigationController?.present(emptyTitleAlert, animated: true, completion: nil)
			print("Title was empty")
			return
		}
		 */
		let contact=getContactFromFields()
		let cardEntity=NSEntityDescription.entity(forEntityName: ContactCardMO.entityName, in: viewContext)
		guard let cardEntity=cardEntity else {
			return
		}
		let contactCard=ContactCardMO(entity: cardEntity, insertInto: viewContext)

	setFields(contactCardMO: contactCard, filename: cardTitle, cnContact: contact, color: "Contrasting Color")
		do {
			try viewContext.save()
		} catch {
			//present(localErrorSavingAlertController(), animated: true)
			print("Couldn't save contact")
		}
		/*
		if forEditing==false {
			guard let context=self.managedObjectContext else {
				return
			}
			let card=NSEntityDescription.entity(forEntityName: ContactCardMO.entityName, in: context)
			guard let card=card else {
				return
			}
			contactCard=ContactCardMO(entity: card, insertInto: context)
		}
		guard let card=contactCard else {
			return
		}
		let index=colorCollectionView.indexPathsForSelectedItems?.first?.item
			guard let index=index else {
				return
			}
		let color=colorModel.colors[index]
		setFields(contactCardMO: card, filename: title, cnContact: contact, color: color.name)
			let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
			do {
				try managedObjectContext?.save()
			} catch {
				present(localErrorSavingAlertController(), animated: true)
				print("Couldn't save contact")
			}
			NotificationCenter.default.post(name: .contactUpdated, object: self, userInfo: ["uuid": self.contactCard?.objectID.uriRepresentation().absoluteString ?? ""])
			UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
			navigationController?.dismiss(animated: true)
			ActiveContactCard.shared.contactCard=card
			NotificationCenter.default.post(name: .contactCreated, object: self, userInfo: nil)
			updateWidget(contactCard: self.contactCard)
		 */
	}
}
