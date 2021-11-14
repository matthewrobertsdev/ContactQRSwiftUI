//
//  ValidateUrl.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/13/21.
//
import Foundation
func validateUrl(proposedURL: String) -> String {
	var validURL=proposedURL
	if !(proposedURL.starts(with: "http://")) && !(proposedURL.starts(with: "https://")) {
		validURL="http://"+proposedURL
	}
	return validURL
}
