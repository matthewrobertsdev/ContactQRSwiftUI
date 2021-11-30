//
//  ValidateUrl.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/13/21.
//
import Foundation
//give url a start of https if http/https are not present
// MARK: Validate URL
func validateUrl(proposedURL: String) -> String {
	var validURL=proposedURL
	if !(proposedURL.starts(with: "http://")) && !(proposedURL.starts(with: "https://")) {
		validURL="https://"+proposedURL
	}
	return validURL
}
