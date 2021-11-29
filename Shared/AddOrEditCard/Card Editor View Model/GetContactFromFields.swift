//
//  GetContactFromFields.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/13/21.
//
import Foundation
import Contacts
extension CardEditorViewModel {
	// MARK: Get Contact
	private func getContactFromFields() -> CNMutableContact {
		let contact=CNMutableContact()
		getNameDetails(contact: contact)
		getJobDetails(contact: contact)
		getPhoneNumbers(contact: contact)
		getEmails(contact: contact)
		getSocialProfiles(contact: contact)
		getUrls(contact: contact)
		getAddresses(contact: contact)
		return contact
	}
	// MARK: Get Name
	private func getNameDetails(contact: CNMutableContact) {
		if  !(firstName=="") {
			contact.givenName=firstName
		}
		if  !(lastName=="") {
			contact.familyName=lastName
		}
		if  !(prefixString=="") {
			contact.namePrefix=prefixString
		}
		if  !(suffix=="") {
			contact.nameSuffix=suffix
		}
		if  !(nickname=="") {
			contact.nickname=nickname
		}
	}
	// MARK: Get Job
	private func getJobDetails(contact: CNMutableContact) {
		if  !(company=="") {
			contact.organizationName=company
		}
		if  !(jobTitle=="") {
			contact.jobTitle=jobTitle
		}
		if  !(department=="") {
			contact.departmentName=department
		}
	}
	// MARK: Get Phones
	private func getPhoneNumbers(contact: CNMutableContact) {
		if  !(mobilePhone=="") {
			let phone=CNPhoneNumber(stringValue: mobilePhone)
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMobile, value: phone))
		}
		if  !(workPhone1=="") {
			let phone=CNPhoneNumber(stringValue: workPhone1)
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: phone))
		}
		if  !(workPhone2=="") {
			let phone=CNPhoneNumber(stringValue: workPhone2)
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: phone))
		}
		if  !(homePhone=="") {
			let phone=CNPhoneNumber(stringValue: homePhone)
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelHome, value: phone))
		}
		if  !(otherPhone=="") {
			let phone=CNPhoneNumber(stringValue: otherPhone)
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelOther, value: phone))
		}
	}
	// MARK: Get Emails
	private func getEmails(contact: CNMutableContact) {
		if  !(homeEmail=="") {
			let email=NSString(string: homeEmail)
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: NSString(string: email)))
		}
		if  !(workEmail1=="") {
			let email=NSString(string: workEmail1)
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: email))
		}
		if  !(workEmail2=="") {
			let email=NSString(string: workEmail2)
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: email))
		}
		if  !(otherEmail=="") {
			let email=NSString(string: otherEmail)
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: NSString(string: email)))
		}
	}
	// MARK: Get Socail Profiles
	func getSocialProfiles(contact: CNMutableContact) {
		if !(twitterUsername=="") {
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: nil, username:
																												twitterUsername, userIdentifier: nil, service: CNSocialProfileServiceTwitter)))
		}
		if !(linkedInUrl=="") {
			var linkedInURL=linkedInUrl
			if !linkedInURL.starts(with: "https://") && !linkedInURL.starts(with: "http://") {
				linkedInURL="https://\(linkedInURL)"
			}
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString:
																												linkedInURL, username: linkedInURL, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)))
		}
		if !(facebookUrl=="") {
			var facebookURL=facebookUrl
			if !facebookURL.starts(with: "https://") && !facebookURL.starts(with: "http://") {
				facebookURL="https://\(facebookURL)"
			}
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: facebookURL,
																											 username: facebookURL, userIdentifier: nil, service: CNSocialProfileServiceFacebook)))
		}
		if !(whatsAppNumber=="") {
			var whatsAppNumber=whatsAppNumber
			whatsAppNumber = whatsAppNumber.filter("0123456789.".contains)
			
			let whatsAppURL="https://wa.me/\(whatsAppNumber)"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: whatsAppURL,
																											 username: whatsAppNumber, userIdentifier: nil, service: "WhatsApp")))
		}
		if !(instagramUsername=="") {
			var instagramUsername=instagramUsername
			instagramUsername = instagramUsername.replacingOccurrences(of: "@", with: "")
			
			let instagramURL="https://www.instagram.com/\(instagramUsername)"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: instagramURL,
																											 username: instagramUsername, userIdentifier: nil, service: "Instagram")))
		}
		if !(snapchatUsername=="") {
			let snapchatUsername=snapchatUsername
			
			let snapchatURL="https://www.snapchat.com/add/\(snapchatUsername)/"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: snapchatURL,
																											 username: snapchatUsername, userIdentifier: nil, service: "Snapchat")))
		}
		if !(pinterestUsername=="") {
			let pinterestUsername=pinterestUsername
			let pinterestURL="https://www.pinterest.com/\(pinterestUsername)"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: pinterestURL,
																											 username: pinterestUsername, userIdentifier: nil, service: "Pinterest")))
		}
	}
	// MARK: Get URLs
	private func getUrls(contact: CNMutableContact) {
		if  !(homeUrl=="") {
			var url=NSString(string:
								homeUrl)
			url=validateUrl(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: NSString(string: url)))
		}
		if  !(workUrl1=="") {
			var url=NSString(string:workUrl1)
			url=validateUrl(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: url))
		}
		if  !(workUrl2=="") {
			var url=NSString(string: workUrl2)
			url=validateUrl(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: url))
		}
		if  !(otherUrl1=="") {
			var url=NSString(string: otherUrl1)
			url=validateUrl(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: url))
		}
		if  !(otherUrl2=="") {
			var url=NSString(string: otherUrl2)
			url=validateUrl(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: url))
		}
	}
	// MARK: Get Addresses
	private func getAddresses(contact: CNMutableContact) {
		if !(homeStreetAddress=="") || !(homeCity=="") ||
			!(homeState=="") || !(homeZip=="") {
			let address=CNMutablePostalAddress()
			address.street=homeStreetAddress
			address.city=homeCity
			address.state=homeState
			address.postalCode=homeZip
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: address))
		}
		if !(workStreetAddress=="") || !(workCity=="") ||
			!(workState=="") || !(workZip=="") {
			let address=CNMutablePostalAddress()
			address.street=workStreetAddress
			address.city=workCity
			address.state=workState
			address.postalCode=workZip
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelWork, value: address))
		}
		if !(otherStreetAddress=="") || !(otherCity=="") ||
			!(otherState=="") || !(otherZip=="") {
			let address=CNMutablePostalAddress()
			address.street=otherStreetAddress
			address.city=otherCity
			address.state=otherState
			address.postalCode=otherZip
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelOther, value: address))
		}
	}
}
