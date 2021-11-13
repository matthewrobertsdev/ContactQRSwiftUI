//
//  CardEditorViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/12/21.
//
import Foundation
//view model for card editor
class CardEditorViewModel: ObservableObject {
	//name
	@Published var firstName=""
	@Published var lastName=""
	@Published var prefix=""
	@Published var suffix=""
	@Published var nickname=""
	//company
	@Published var company=""
	@Published var jobTitle=""
	@Published var department=""
	//phones
	@Published var mobilePhone=""
	@Published var workPhone1=""
	@Published var workPhone2=""
	@Published var homePhone=""
	@Published var otherPhone=""
	//emails
	@Published var homeEmail=""
	@Published var workEmail1=""
	@Published var workEmail2=""
	@Published var otherEmail=""
	//social profiles
	@Published var twitterUsername=""
	@Published var facebookUrl=""
	@Published var linkedInUrl=""
	@Published var whatsAppNumber=""
	@Published var instagramUsername=""
	@Published var snapchatUsername=""
	@Published var pinterestUsername=""
	//urls
	@Published var homeUrl=""
	@Published var workUrl1=""
	@Published var workUrl2=""
	@Published var otherUrl1=""
	@Published var otherUrl2=""
	//addresses
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
}
