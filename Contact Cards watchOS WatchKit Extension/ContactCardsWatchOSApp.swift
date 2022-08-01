//
//  Contact_CardsApp.swift
//  Contact Cards (watchOS) WatchKit Extension
//
//  Created by Matt Roberts on 7/17/22.
//

import SwiftUI

@main
struct ContactCardsWatchOSApp: App {
	let persistenceController = PersistenceController.shared
    @SceneBuilder var body: some Scene {
        WindowGroup {
			NavigationView {
				ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
			}
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
