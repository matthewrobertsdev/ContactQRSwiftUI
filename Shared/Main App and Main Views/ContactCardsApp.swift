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
				.frame(minWidth: 650, idealWidth: 650, maxWidth: nil, minHeight: 450, idealHeight: 450, maxHeight: nil, alignment:.center)
#endif
		}
    }
}