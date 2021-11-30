//
//  AboutViewModel.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 11/27/21.
//

import Foundation

struct AboutViewModel {
	var versionAndBuildString=""
	var humanReadbleCopyright=""
	// MARK: Copyright and Build
	init() {
		guard let copyrightString = Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String else {
			return
		}
		guard let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return
		}
		guard let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
			return
		}
		humanReadbleCopyright=copyrightString
		versionAndBuildString="Version \(versionString) (\(buildString))"
	}
}
