//
//  FillContactsFromFields.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/27/21.
//
import Foundation
import Contacts
extension CardEditorViewModel {
	// MARK: Fill from Card
	public func fillFromCard(card: ContactCardMO?) {
		clearFields()
		guard let card=card else {
			return
		}
		// MARK: Fill Color
		let colorModelIndex=selectableColorModels.firstIndex { selelctableColorModel in
			selelctableColorModel.string==card.color
		}
		selectableColorModels[colorModelIndex ?? 0].selected=true
		cardColor=selectableColorModels[colorModelIndex ?? 0].string
		// MARK: Fill Title and Fields
		cardTitle=card.filename
		do {
			guard let cnContact=try ContactDataConverter.getCNContact(vCardString: card.vCardString) else {
				return
		}
			fillFields(contact: cnContact)
		} catch {
			print("Unable to fill fields from contact.")
		}
	}
	public func fillFields(contact: CNContact) {
		fillName(contact: contact)
		fillJob(contact: contact)
		fillPhoneNumbers(contact: contact)
		fillEmails(contact: contact)
		fillSocialProfiles(contact: contact)
		fillUrls(contact: contact)
		fillPostalAddresses(contact: contact)
	}
	// MARK: Fill Name
	private func fillName(contact: CNContact) {
		firstName=contact.givenName
		lastName=contact.familyName
		prefixString=contact.namePrefix
		suffix=contact.nameSuffix
		nickname=contact.nickname
	}
	// MARK: Fill Job
	private func fillJob(contact: CNContact) {
		company=contact.organizationName
		jobTitle=contact.jobTitle
		department=contact.departmentName
	}
	// MARK: Fill Phones
	private func fillPhoneNumbers(contact: CNContact) {
		let phoneNumbers=contact.phoneNumbers
		mobilePhone=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelPhoneNumberMobile || labeledNumber.label==CNLabelPhoneNumberiPhone
		})?.value.stringValue ?? ""
		let workPhoneNumbers=phoneNumbers.filter({ (labeledNumber) in
			return labeledNumber.label==CNLabelWork
		})
		workPhone1=workPhoneNumbers.first?.value.stringValue ?? ""
		if workPhoneNumbers.count>1 {
			workPhone2=workPhoneNumbers[1].value.stringValue
		}
		homePhone=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelHome
		})?.value.stringValue ?? ""
		otherPhone=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})?.value.stringValue ?? ""
	}
	// MARK: Fill Emails
	private func fillEmails(contact: CNContact) {
		let emails=contact.emailAddresses
		homeEmail=emails.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelHome
		})?.value.substring(from: 0) ?? ""
		otherEmail=emails.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})?.value.substring(from: 0) ?? ""
		let workEmails=emails.filter({ (labeledEmail) in
			return labeledEmail.label==CNLabelWork
		})
		workEmail1=workEmails.first?.value.substring(from: 0) ?? ""
		if workEmails.count>1 {
			workEmail2=workEmails[1].value.substring(from: 0)
		}
	}
	// MARK: Fill Social Priles
	private func fillSocialProfiles(contact: CNContact) {
		let socialProfiles=contact.socialProfiles
		twitterUsername=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceTwitter.lowercased()
		})?.value.username ?? ""
		linkedInUrl=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceLinkedIn.lowercased()
		})?.value.urlString ?? ""
		facebookUrl=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceFacebook.lowercased()
		})?.value.urlString ?? ""
		whatsAppNumber=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()=="WhatsApp".lowercased()
		})?.value.username ?? ""
		instagramUsername=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()=="Instagram".lowercased()
		})?.value.username ?? ""
		snapchatUsername=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()=="Snapchat".lowercased()
		})?.value.username ?? ""
		pinterestUsername=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()=="Pinterest".lowercased()
		})?.value.username ?? ""
	}
	// MARK: Fill URLs
	private func fillUrls(contact: CNContact) {
		let urls=contact.urlAddresses
		homeUrl = urls.first(where: { (labeledUrl) in
			return labeledUrl.label==CNLabelHome
		})?.value.substring(from: 0) ?? ""
		let workUrls=urls.filter({ (labeledNumber) in
			return labeledNumber.label==CNLabelWork
		})
		workUrl1=workUrls.first?.value.substring(from: 0) ?? ""
		if workUrls.count>1 {
			workUrl2=workUrls[1].value.substring(from: 0)
		}
		let otherUrls=urls.filter({ (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})
		otherUrl1=otherUrls.first?.value.substring(from: 0) ?? ""
		if otherUrls.count>1 {
			otherUrl2=otherUrls[1].value.substring(from: 0)
		}
	}
	// MARK: Fill Addresses
	private func fillPostalAddresses(contact: CNContact) {
		let addresses=contact.postalAddresses
		let firstHomeAddress=addresses.first { (address) -> Bool in
			address.label==CNLabelHome
		}?.value
		if let homeAddress=firstHomeAddress {
			homeStreetAddress=homeAddress.street
			homeCity=homeAddress.city
			homeState=homeAddress.state
			homeZip=homeAddress.postalCode
		}
		let firstWorkAddress=addresses.first { (address) -> Bool in
			address.label==CNLabelWork
		}?.value
		if let workAddress=firstWorkAddress {
			workStreetAddress=workAddress.street
			workCity=workAddress.city
			workState=workAddress.state
			workZip=workAddress.postalCode
		}
		let firstOtherAddress=addresses.first { (address) -> Bool in
			address.label==CNLabelOther
		}?.value
		if let otherAddress=firstOtherAddress {
			otherStreetAddress=otherAddress.street
			otherCity=otherAddress.city
			otherState=otherAddress.state
			otherZip=otherAddress.postalCode
		}
	}
}
