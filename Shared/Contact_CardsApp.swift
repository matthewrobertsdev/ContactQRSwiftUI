//
//  Contact_CardsApp.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//

import SwiftUI

@main
struct Contact_CardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
