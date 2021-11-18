//
//  SavedContact.swift
//  Contact Cards
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Foundation
import Contacts
struct ContactCard: Codable {
	var filename=""
	var vCardString=""
	var color=""
	init(filename: String, vCardString: String, color: String) {
		self.filename=filename
		self.vCardString=vCardString
		self.color=color
	}
}
