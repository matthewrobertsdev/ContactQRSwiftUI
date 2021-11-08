//
//  ContentView.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//
import SwiftUI
import CoreData
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ContactCardMO.filename, ascending: true)],
        animation: .default)
    private var contactCards: FetchedResults<ContactCardMO>
    var body: some View {
        NavigationView {
			List(contactCards, id: \.objectID) { card in
                    NavigationLink {
						Text(card.filename)
                    } label: {
						CardRow(card: card)
                    }
			}
            .toolbar {
                ToolbarItem {
					Button(action: addItem) {
						Label("Add Item", systemImage: "plus")
					}
                }
#if os(iOS)
				ToolbarItemGroup(placement: .bottomBar) {
					Button(action: addItem) {
						Text("For Siri")
					}
					Spacer()
					Button(action: addItem) {
						Label("Manage Cards", systemImage: "gearshape")
					}
					Spacer()
					Button(action: addItem) {
						Label("Help", systemImage: "questionmark")
					}
					Spacer()
					EditButton()
				}
#endif
			}.navigationTitle("Contact Cards")
            Text("Select an item")
		}
    }
    private func addItem() {
		/*
        withAnimation {
			
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
			 */
    }
    private func deleteItems(offsets: IndexSet) {
		/*
        withAnimation {
            offsets.map { contactCards[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
		 */
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
