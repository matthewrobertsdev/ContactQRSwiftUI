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
#if os(macOS)
	var circleDiamater=CGFloat(20)
#elseif os(iOS)
	var circleDiamater=CGFloat(20)
#endif

    var body: some View {
		
        NavigationView {
			//*
			List(contactCards, id: \.objectID) { card in
                    NavigationLink {
						Text(card.filename)
                    } label: {
						HStack{
							Circle().strokeBorder(.gray, lineWidth: 0.7).background(Circle().fill(Color("Dark"+card.color, bundle: nil))).frame(width: circleDiamater, height: circleDiamater, alignment: .leading)
							Text(card.filename).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 17.5))
						}.padding(7.5)
                    }
			}
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
				//*/
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
