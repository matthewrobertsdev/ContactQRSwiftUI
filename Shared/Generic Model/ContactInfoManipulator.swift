//
//  ContactImnfoManipulator.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/26/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Foundation
import Contacts
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
class ContactInfoManipulator {
	static func makeContactDisplayModel(cnContact: CNContact) -> [FieldInfoModel] {
		var displayModel=[FieldInfoModel]()
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
		if !(cnContact.organizationName=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Company:  \(cnContact.organizationName)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.jobTitle=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Job Title:  \(cnContact.jobTitle)", linkText: "", hyperlink: ""))
		}
		if !(cnContact.departmentName=="") {
			displayModel.append(FieldInfoModel(hasLink: false, text: "Department:  \(cnContact.departmentName)", linkText: "", hyperlink: ""))
		}
		return displayModel
	}
    static func makeContactLabel(label: String) -> String {
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

	static func makeContactDisplayString(cnContact: CNContact?, fontSize: CGFloat) -> NSAttributedString {
		let displayString=NSMutableAttributedString()
		var basicString=""
		guard let cnContact=cnContact else {
			return NSAttributedString()
		}
		if !(cnContact.namePrefix=="") {
			basicString+="Prefix:  \(cnContact.namePrefix)\n\n"
		}
		if !(cnContact.givenName=="") {
			basicString+="First Name:  \(cnContact.givenName)\n\n"
		}
		if !(cnContact.familyName=="") {
			basicString+="Last Name:  \(cnContact.familyName)\n\n"
			}
		if !(cnContact.nameSuffix=="") {
			basicString+="Suffix:  \(cnContact.nameSuffix)\n\n"
		}
			if !(cnContact.nickname=="") {
				basicString+="Nickname:  \(cnContact.nickname)\n\n"
			}
		if !(cnContact.organizationName=="") {
			basicString+="Company:  \(cnContact.organizationName)\n\n"
		}
		if !(cnContact.jobTitle=="") {
			basicString+="Job Title:  \(cnContact.jobTitle)\n\n"
		}
		if !(cnContact.departmentName=="") {
			basicString+="Department:  \(cnContact.departmentName)\n\n"
		}
			displayString.append(NSAttributedString(string: basicString))
			basicString=""
			for phoneNumber in cnContact.phoneNumbers {
				var phoneLabelString=""
				if let phoneNumberLabel=phoneNumber.label {
					phoneLabelString =
					makeContactLabel(label: phoneNumberLabel)
				}
				let linkString=phoneNumber.value.stringValue
				addLink(stringToAddTo: displayString, label: phoneLabelString+" Phone", linkModifer: "tel://", basicLink: linkString)
			}
			for emailAddress in cnContact.emailAddresses {
				var emailLabelString=""
				if let emailLabel=emailAddress.label { emailLabelString =
					makeContactLabel(label: emailLabel)
				}
				let linkString=emailAddress.value as String
				addLink(stringToAddTo: displayString, label: emailLabelString+" Email", linkModifer: "mailto:", basicLink: linkString)
			}
		addSocialProfiles(cnContact: cnContact, displayString: displayString)
			for urlAddress in (cnContact.urlAddresses) {
				var urlAddressLabelString=""
				if let urlAddressLabel=urlAddress.label { urlAddressLabelString =
					makeContactLabel(label: urlAddressLabel)
				}
				let linkString=urlAddress.value as String
				addLink(stringToAddTo: displayString, label: urlAddressLabelString+" URL", linkModifer: "", basicLink: linkString)
			}
			basicString=""
			for address in cnContact.postalAddresses {
				var addressLabelString=""
				if let addressLabel=address.label { addressLabelString =
					makeContactLabel(label: addressLabel)
				}
				displayString.append(NSMutableAttributedString(string: "\(addressLabelString) Address: "))
				let addressDisplayString=NSMutableAttributedString(string:
																"\(address.value.street as String)\n \(address.value.city as String) \(address.value.state) \(address.value.postalCode)")
				let addressString=NSMutableAttributedString(string:
																"\(address.value.street as String) \(address.value.city as String) \(address.value.state) \(address.value.postalCode)")
				let searchAddressString=addressString.mutableString.replacingOccurrences(of: " ", with: "+")
				addressDisplayString.addAttribute(.link, value: "http://maps.apple.com/?q=\(searchAddressString)", range: NSRange(location: 0, length: addressDisplayString.length))
				displayString.append(addressDisplayString)
				displayString.append(NSAttributedString(string: "\n\n"))
			}
		addBasicFormatting(displayString: displayString, fontSize: fontSize)
		return displayString
	}
	static func addSocialProfiles(cnContact: CNContact, displayString: NSMutableAttributedString) {
		if let twitterUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceTwitter.lowercased()
		})?.value.username {
			addLink(stringToAddTo: displayString, label: "Twitter Username", linkModifer: "https://twitter.com/", basicLink: twitterUsername)
		}
		if let linkedInURL=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceLinkedIn.lowercased()
		})?.value.urlString {
			if linkedInURL != "" {
				addLink(stringToAddTo: displayString, label: "LinkedIn URL", linkModifer: "", basicLink: linkedInURL)
			}
		}
		if let facebookURL=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceFacebook.lowercased()
		})?.value.urlString {
			if facebookURL != "" {
				addLink(stringToAddTo: displayString, label: "Facebook URL", linkModifer: "", basicLink: facebookURL)
			}
		}
		if let whatsAppNumber=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="WhatsApp".lowercased()
		})?.value.username {
			if whatsAppNumber != "" {
				addLink(stringToAddTo: displayString, label: "WhatsApp Number", linkModifer: "https://wa.me/", basicLink: whatsAppNumber)
			}
		}
		if let instagramUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Instagram".lowercased()
		})?.value.username {
			if instagramUsername != "" {
				addLink(stringToAddTo: displayString, label: "Instagram Username", linkModifer: "https://www.instagram.com/", basicLink: instagramUsername)
			}
		}
		if let snapchatUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Snapchat".lowercased()
		})?.value.username {
			if snapchatUsername != "" {
				addLink(stringToAddTo: displayString, label: "Snapchat Username", linkModifer: "https://www.snapchat.com/add/", basicLink: snapchatUsername)
			}
		}
		if let pinterestUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Pinterest".lowercased()
		})?.value.username {
			if pinterestUsername != "" {
				addLink(stringToAddTo: displayString, label: "Pinterest Username", linkModifer: "https://www.pinterest.com/", basicLink: pinterestUsername)
			}
		}
	}
	static func addLink(stringToAddTo: NSMutableAttributedString, label: String, linkModifer: String, basicLink: String) {
		stringToAddTo.append(NSAttributedString(string: "\(label): "))
		let urlString=NSMutableAttributedString(string: basicLink)
		urlString.addAttribute(.link, value: linkModifer+basicLink, range: NSRange(location: 0, length: urlString.length))
		stringToAddTo.append(urlString)
		stringToAddTo.append(NSAttributedString(string: "\n\n"))
	}
	static func getBadVCardAttributedString(fontSize: CGFloat) -> NSAttributedString {
		let badVCardWarning=NSMutableAttributedString(string: "One or more of the data was invalid.  Probably something you "
											+ "inputted is too long for that kind of contact info.  "
		+ "Please edit the contact info until it is sharable as a file.")
		addBasicFormatting(displayString: badVCardWarning, fontSize: fontSize)
		return badVCardWarning
	}
	#if os(iOS)
	static func addBasicFormatting(displayString: NSMutableAttributedString, fontSize: CGFloat) {
		let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = NSTextAlignment.center
		var color=UIColor.white
		#if os(watchOS)
		#else
		color=UIColor.label
		#endif
		let fontAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light),
							   NSAttributedString.Key.paragraphStyle: paragraphStyle, .foregroundColor: color]

		displayString.addAttributes(fontAttributes, range: NSRange(location: 0, length: displayString.length))
	}
	#elseif os(macOS)
	static func addBasicFormatting(displayString: NSMutableAttributedString, fontSize: CGFloat) {
		let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = NSTextAlignment.center
		var color=NSColor.white
		#if os(watchOS)
		#else
		color=NSColor.labelColor
		#endif
		let fontAttributes = [ NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontSize, weight: NSFont.Weight.light),
							   NSAttributedString.Key.paragraphStyle: paragraphStyle, .foregroundColor: color]

		displayString.addAttributes(fontAttributes, range: NSRange(location: 0, length: displayString.length))
	}
	#endif
}
