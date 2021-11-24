//
//  ContactImnfoManipulator.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/26/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Foundation
import Contacts
class ContactInfoManipulator {
	// MARK: Make Model
	static func makeContactDisplayModel(cnContact: CNContact) -> [FieldInfoModel] {
		//create display model
		var displayModel=[FieldInfoModel]()
		//name
		addNameDisplayModel(cnContact: cnContact, displayModel: &displayModel)
		//job
		addJobDisplayModel(cnContact: cnContact, displayModel: &displayModel)
		//phone
		addPhoneDisplayModel(cnContact: cnContact, displayModel: &displayModel)
		//email
		addEmailDisplayModel(cnContact: cnContact, displayModel: &displayModel)
		//social profiles
		addSocialProfileDisplayModel(cnContact: cnContact, displayModel: &displayModel)
		//URLs
		addUrlsDisplayModel(cnContact: cnContact, displayModel: &displayModel)
		//addresses
		addAddressesDisplayModel(cnContact: cnContact, displayModel: &displayModel)
		//return display model
		return displayModel
	}
	// MARK: Names
	private static func addNameDisplayModel(cnContact: CNContact, displayModel: inout [FieldInfoModel]) {
		if !(cnContact.namePrefix=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Prefix:  \(cnContact.namePrefix)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.givenName=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "First Name:  \(cnContact.givenName)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.familyName=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Last Name:  \(cnContact.familyName)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.nameSuffix=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Suffix:  \(cnContact.nameSuffix)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.nickname=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Nickname:  \(cnContact.nickname)", linkText: "", hyperlink: ""))
		}
	}
	// MARK: Jobs
	private static func addJobDisplayModel(cnContact: CNContact, displayModel: inout [FieldInfoModel]) {
		if !(cnContact.organizationName=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Company:  \(cnContact.organizationName)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.jobTitle=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Job Title:  \(cnContact.jobTitle)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.departmentName=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Department:  \(cnContact.departmentName)", linkText: "", hyperlink: ""))
		}
	}
	// MARK: Phones
	private static func addPhoneDisplayModel(cnContact: CNContact, displayModel: inout [FieldInfoModel]) {
		for phoneNumber in cnContact.phoneNumbers {
			var phoneLabelString=""
			if let phoneNumberLabel=phoneNumber.label {
				phoneLabelString =
				makeContactLabel(label: phoneNumberLabel)
			}
			let linkString=phoneNumber.value.stringValue
			displayModel.append(FieldInfoModel(hasLink: true, text: "\(phoneLabelString) Phone:", linkText: linkString, hyperlink: "tel://\(linkString)"))
		}
	}
	// MARK: Emails
	private static func addEmailDisplayModel(cnContact: CNContact, displayModel: inout [FieldInfoModel]) {
		for emailAddress in cnContact.emailAddresses {
			var emailLabelString=""
			if let emailLabel=emailAddress.label { emailLabelString =
				makeContactLabel(label: emailLabel)
			}
			let linkString=emailAddress.value as String
			displayModel.append(FieldInfoModel(hasLink: true, text: "\(emailLabelString) Email:", linkText: linkString, hyperlink: "mailto:\(linkString)"))
		}
	}
	// MARK: Social Profiles
	private static func addSocialProfileDisplayModel(cnContact: CNContact, displayModel: inout [FieldInfoModel]) {
		if let twitterUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceTwitter.lowercased()
		})?.value.username {
			displayModel.append(FieldInfoModel(hasLink: true, text: "Twitter Username:", linkText: twitterUsername, hyperlink: "https://twitter.com/\(twitterUsername)"))
		}
		if let linkedInURL=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceLinkedIn.lowercased()
		})?.value.urlString {
			displayModel.append(FieldInfoModel(hasLink: true, text: "LinkedIn URL:", linkText: linkedInURL, hyperlink: linkedInURL))
		}
		if let facebookURL=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceFacebook.lowercased()
		})?.value.urlString {
			if facebookURL != "" {
				displayModel.append(FieldInfoModel(hasLink: true, text: "Facebook URL:", linkText: facebookURL, hyperlink: facebookURL))
			}
		}
		if let whatsAppNumber=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="WhatsApp".lowercased()
		})?.value.username {
			if whatsAppNumber != "" {
				displayModel.append(FieldInfoModel(hasLink: true, text: "WhatsApp Number:", linkText: whatsAppNumber, hyperlink: "https://wa.me/\(whatsAppNumber)"))
			}
		}
		if let instagramUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Instagram".lowercased()
		})?.value.username {
			if instagramUsername != "" {
				displayModel.append(FieldInfoModel(hasLink: true, text: "Instagram Username:", linkText: instagramUsername, hyperlink: "https://www.instagram.com/\(instagramUsername)"))
			}
		}
		if let snapchatUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Snapchat".lowercased()
		})?.value.username {
			if snapchatUsername != "" {
				displayModel.append(FieldInfoModel(hasLink: true, text: "Snapchat Username:", linkText: snapchatUsername, hyperlink: "https://www.snapchat.com/add/\(snapchatUsername)"))
			}
		}
		if let pinterestUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Pinterest".lowercased()
		})?.value.username {
			if pinterestUsername != "" {
				displayModel.append(FieldInfoModel(hasLink: true, text: "Snapchat Username:", linkText: pinterestUsername, hyperlink: "https://www.pinterest.com/\(pinterestUsername)"))
			}
		}
	}
	// MARK: URLs
	private static func addUrlsDisplayModel(cnContact: CNContact, displayModel: inout [FieldInfoModel]) {
		for urlAddress in (cnContact.urlAddresses) {
			var urlAddressLabelString=""
			if let urlAddressLabel=urlAddress.label { urlAddressLabelString =
				makeContactLabel(label: urlAddressLabel)
			}
			let linkString=urlAddress.value as String
			displayModel.append(FieldInfoModel(hasLink: true, text: "\(urlAddressLabelString) URL:", linkText: linkString, hyperlink: linkString))
		}
	}
	// MARK: Addresses
	private static func addAddressesDisplayModel(cnContact: CNContact, displayModel: inout [FieldInfoModel]) {
		for address in cnContact.postalAddresses {
			var addressLabelString=""
			if let addressLabel=address.label { addressLabelString =
				makeContactLabel(label: addressLabel)
			}
			let addressString = "\(address.value.street as String) \(address.value.city as String) \(address.value.state) \(address.value.postalCode)"
			let searchAddressString=addressString.replacingOccurrences(of: " ", with: "+")
			displayModel.append(FieldInfoModel(hasLink: true, text: "\(addressLabelString) Address:", linkText: addressString, hyperlink: "http://maps.apple.com/?q=\(searchAddressString)"))
		}
	}
	// MARK: Make Label
    private static func makeContactLabel(label: String) -> String {
        var displayLabel=label
        if displayLabel.count<4 {
            return ""
        }
        let removeStartRange=displayLabel.startIndex..<label.index(displayLabel.startIndex, offsetBy: 4)
        displayLabel.removeSubrange(removeStartRange)
        if displayLabel.count<4 {
            return ""
        }
        let removeEndRange=displayLabel.index(displayLabel.endIndex, offsetBy: -4)..<displayLabel.endIndex
        displayLabel.removeSubrange(removeEndRange)
        return String(displayLabel)
    }
	// MARK: Error String
	static let badVCardString = "One or more of the data was invalid.  " +
	"Probably something you inputted is too long for that kind of contact info.  " +
	"Please edit the contact info until it is sharable as a file."
}
