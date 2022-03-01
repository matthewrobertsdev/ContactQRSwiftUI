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
	@State private var showingEmptyTitleAlert = false
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
	// MARK: Modal State
	//state for showing/hiding sheets
	@State private var showingAddCardSheet = false
	@State private var showingAboutSheet = false
	@State private var selectedCard: ContactCardMO?
	// MARK: Min Detail Width
	let minDetailWidthMacOS=CGFloat(450)
	// MARK: Body
	//body
	var body: some View {
		NavigationView {
			// MARK: List
			ScrollViewReader { proxy in
				List() {
				ForEach(contactCards, id: \.objectID) { card in
					//view upon selection by list
				//*
				NavigationLink(tag: card, selection: $selectedCard) {
					// MARK: Contact Card View
					ContactCardView(card: card, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext)
#if os(macOS)
						.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center)
#endif
				} label: {
					// MARK: Label
					//card row: the label (with title and circluar color)
					CardRow(card: card)
				}
				}
				}.listStyle(SidebarListStyle()).onChange(of: selectedCard) { target in
					if let target = target {
						proxy.scrollTo(target.objectID, anchor: nil)
				
			}
				}
	}.toolbar {
				//top toolbar add button
				ToolbarItem {
					Button(action: addCard) {
						Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
					}
				}
				// MARK: iOS Toolbar
#if os(iOS)
				//iOS bottom toolbar item group
				ToolbarItemGroup(placement: .bottomBar) {
					Button(action: addCard) {
						Text("For Siri").accessibilityLabel("For Siri")
					}
					Spacer()
					Button(action: addCard) {
						Label("Manage Cards", systemImage: "gearshape").accessibilityLabel("Manage Cards")
					}
					Spacer()
					Button(action: showAboutSheet) {
						Label("About", systemImage: "questionmark").accessibilityLabel("About")
					}
					Spacer()
					EditButton()
				}
#endif
			}.navigationTitle("Contact Cards")
			// MARK: Default View
			NoCardSelectedView()
#if os(macOS)
			// MARK: macOS Toolbar
				.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center).toolbar {
					ToolbarItemGroup {
						Button(action: addCard) {
							Label("Manage Cards", systemImage: "gearshape").accessibilityLabel("Manage Card")
						}
					}
				}
#endif
		}
		// MARK: Add Sheet
		.sheet(isPresented: $showingAddCardSheet) {
			//sheet for adding or editing card
			if #available(iOS 15, macOS 12.0, *) {
				AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
					Button("Got it.", role: .none, action: {})
				}, message: {
					Text("Card title must not be blank.")
				})
			} else {
				AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
					Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
				})
			}
		}
#if os(iOS)
		// MARK: About Sheet
		.sheet(isPresented: $showingAboutSheet) {
			//sheet for about modal
			AboutSheet(showingAboutSheet: $showingAboutSheet)
		}
#endif
	}
	
	
	// MARK: Show Modals
	//show add or edit card sheet in add mode
	private func addCard() {
		showingAddCardSheet.toggle()
	}
	private func showAboutSheet() {
		showingAboutSheet.toggle()
	}
	/*
	 private func deleteCards(offsets: IndexSet) {
	 withAnimation {
	 offsets.map { contactCards[$0] }.forEach(viewContext.delete)
	 do {
	 try viewContext.save()
	 } catch {
	 print("Failed to delete one or more cards")
	 }
	 }
	 }
	 */
	/*
	private func selectCard() {
		selectedCard=contactCards.first
	}
	 */
}
// MARK: Preview
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
