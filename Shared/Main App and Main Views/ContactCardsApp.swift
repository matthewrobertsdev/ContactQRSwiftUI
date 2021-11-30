//
//  Contact_CardsApp.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//
import SwiftUI
// MARK: Main App
@main
struct ContactCardsApp: App {
	//the persistence controller (contains core data including managed object context)
    let persistenceController = PersistenceController.shared
	//the body
	// MARK: Scene
    var body: some Scene {
        WindowGroup {
			//main view with access to managed object context from environment
            ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				// MARK: macOS Frame
#if os(macOS)
				.frame(minWidth: 750, idealWidth: 750, maxWidth: nil, minHeight: 450, idealHeight: 450, maxHeight: nil, alignment:.center).onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
 }
#endif
		}.commands {
#if os(macOS)
			// MARK: macOS Commands
			CommandGroup(replacing: .help) {
				Button("Frequently Asked Questions") {
					if let url = URL(string: AppLinks.faqString) {
						NSWorkspace.shared.open(url)
					}
				}
				Button("Homepage") {
					if let url = URL(string: AppLinks.homepageString) {
						NSWorkspace.shared.open(url)
					}
				}
				Button("Contact the Developer") {
					if let url = URL(string: AppLinks.contactString) {
						NSWorkspace.shared.open(url)
					}
				}
				Button("Privacy Policy") {
					if let url = URL(string: AppLinks.privacyPolicyString) {
						NSWorkspace.shared.open(url)
					}
				}
			}
			CommandGroup(replacing: .newItem) {
				//no new item
			}
#endif
		}
    }
}
