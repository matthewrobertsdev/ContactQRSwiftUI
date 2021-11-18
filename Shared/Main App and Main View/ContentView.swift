//
//  ContentView.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//
import SwiftUI
import CoreData
//main view
struct ContentView: View {
	// MARK: Cloud Kit
	//managed object context from environment
	@Environment(\.managedObjectContext) private var viewContext
	//fetch sorted by filename (will update automtaicaly)
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ContactCardMO.filename, ascending: true)],
		animation: .default)
	//the fetched cards
	private var contactCards: FetchedResults<ContactCardMO>
	//observe insertions, updates, and deletions so that Siri card and widgets can be updated accordingly
	// MARK: Init
	init() {
		NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: nil, queue: .main) { notification in
			if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
				print("Inserted Objects: "+insertedObjects.description)
			}
			if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {
				print("Updated Objects: "+updatedObjects.description)
			}
			if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletedObjects.isEmpty {
				print("Deleted Objects: "+deletedObjects.description)
			}
		}
	}
	//state for showing/hiding sheets
	@State private var showingAddOrEditCardSheet = false
	// MARK: Body
	//body
	var body: some View {
		NavigationView {
			//list of cards
			List(contactCards, id: \.objectID) { card in
				//view upon selection by list
				NavigationLink {
					Text(card.filename)
				} label: {
					//card row: the label (with title and circluar color)
					CardRow(card: card)
				}
			}
			.toolbar {
				//top toolbar add button
				ToolbarItem {
					Button(action: addItem) {
						Label("Add Item", systemImage: "plus")
					}
				}
#if os(iOS)
				//iOS bottom toolbar item group
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
			//if no card is selected, central view is just this text
			Text("No Contact Card Selected").font(.system(size: 18))
		}.sheet(isPresented: $showingAddOrEditCardSheet) {
			//sheet for adding or editing card
			AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddOrEditCardSheet).environment(\.managedObjectContext, viewContext)
		}
	}
	// MARK: Functions
	//show add or edit card sheet in add mode
	private func addItem() {
		showingAddOrEditCardSheet.toggle()
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
// MARK: Preview
//preview
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
