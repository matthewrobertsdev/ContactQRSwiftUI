//
//  Contact_CardsApp.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//
import SwiftUI
//main app
@main
struct ContactCardsApp: App {
	//the persistence controller (contains core data including managed object context)
    let persistenceController = PersistenceController.shared
	//the body
    var body: some Scene {
        WindowGroup {
			//main view with access to managed object context from environment
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
