//
//  AppDelegate.swift
//  Contact Cards (macOS)
//
//  Created by Matt Roberts on 3/14/22.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
}
