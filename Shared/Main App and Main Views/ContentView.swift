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
	init(selectedCard: Binding<ContactCardMO?>, showingAddCardSheet: Binding<Bool>, showingEditCardSheet: Binding<Bool>) {
		self._selectedCard=selectedCard
		self._showingAddCardSheet=showingAddCardSheet
		self._showingEditCardSheet=showingEditCardSheet
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
	@Binding private var showingAddCardSheet: Bool
	@Binding private var showingEditCardSheet: Bool
	@State private var showingAboutSheet = false
	@Binding private var selectedCard: ContactCardMO?
	// MARK: Min Detail Width
	let minDetailWidthMacOS=CGFloat(500)
	//body
	var body: some View {
		// MARK: macOS
#if os(macOS)
		mainContent()
			.sheet(isPresented: $showingAddCardSheet) {
				addSheet()
			}
#else
		if UIDevice.current.userInterfaceIdiom == .phone {
		// MARK: Compact Width
		mainContent()
			.navigationViewStyle(StackNavigationViewStyle())
			.sheet(isPresented: $showingAddCardSheet) {
				addSheet()
			}
			.sheet(isPresented: $showingAboutSheet) {
				//sheet for about modal
				AboutSheet(showingAboutSheet: $showingAboutSheet)
			}
		} else {
			mainContent()
				.sheet(isPresented: $showingAddCardSheet) {
					addSheet()
				}
				.sheet(isPresented: $showingAboutSheet) {
					//sheet for about modal
					AboutSheet(showingAboutSheet: $showingAboutSheet)
				}
		}
#endif
	}
	
	// MARK: Main Content
	@ViewBuilder
	func mainContent() -> some View {
		NavigationView {
			ScrollViewReader { proxy in
				List() {
					
#if os(macOS)
					Section(header:
								Text("Cards")) {
						naviagtionForEach(proxy: proxy)
					}
#else
					naviagtionForEach(proxy: proxy)
#endif
				}.onChange(of: selectedCard) { target in
					if let target = target {
						proxy.scrollTo(target.objectID, anchor: nil)
						
					}
				}
			}.toolbar {
				// MARK: Add Card
				ToolbarItem {
					Button(action: addCard) {
						Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
					}
				}
#if os(macOS)
				// MARK: Toggle Sidebar
				ToolbarItem(placement: .navigation) {
					Button(action: toggleSidebar, label: {
						Label("Toggle Sidebar", systemImage: "sidebar.leading").accessibilityLabel("Toggle Sidebar")
					})
				}
#endif
				// MARK: iOS Toolbar
#if os(iOS)
				//iOS bottom toolbar item group
				ToolbarItemGroup(placement: .bottomBar) {
					// MARK: For Siri
					Button(action: addCard) {
						Text("For Siri").accessibilityLabel("For Siri")
					}
					Spacer()
					// MARK: Manage Cards
					Button(action: addCard) {
						Label("Manage Cards", systemImage: "gearshape").accessibilityLabel("Manage Cards")
					}
					// MARK: About
					Spacer()
					Button(action: showAboutSheet) {
						Label("About", systemImage: "questionmark").accessibilityLabel("About")
					}
					Spacer()
					// MARK: Edit
					EditButton()
				}
#endif
			}.navigationTitle("Contact Cards")
			// MARK: Default View
			NoCardSelectedView()
#if os(macOS)
				.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center).toolbar {
					// MARK: Add Card
					ToolbarItemGroup {
						Button(action: addCard) {
							Label("Manage Cards", systemImage: "gearshape").accessibilityLabel("Manage Card")
						}
					}
				}
#else
				.toolbar{
					// MARK: Add Card
					ToolbarItem {
						Button(action: addCard) {
							Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
						}
					}
				}
#endif
		}
	}
	
	// MARK: Navigation ForEach
	@ViewBuilder
	func naviagtionForEach(proxy: ScrollViewProxy) -> some View {
		ForEach(contactCards, id: \.objectID) { card in
			//view upon selection by list
			NavigationLink(tag: card, selection: $selectedCard) {
				// MARK: Card View
				ContactCardView(context: viewContext, card: card, selectedCard: $selectedCard, showingEditCardSheet: $showingEditCardSheet).environment(\.managedObjectContext, viewContext)
#if os(macOS)
					.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center)
#endif
			} label: {
				// MARK: Card Row
				//card row: the label (with title and circluar color)
				CardRow(card: card)
			}
			// MARK: Delete Card
		}.onDelete { offsets in
			withAnimation {
				offsets.map { contactCards[$0] }.forEach(viewContext.delete)
				do {
					try viewContext.save()
				} catch {
					print("Failed to delete one or more cards")
				}
			}
		}
	}
	
	
	// MARK: Add Sheet
	@ViewBuilder
	func addSheet() -> some View {
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
	// MARK: Show Modals
	//show add or edit card sheet in add mode
	private func addCard() {
		showingAddCardSheet.toggle()
	}
	private func showAboutSheet() {
		showingAboutSheet.toggle()
	}
	// MARK: Toggle Sidebar
	private func toggleSidebar() { // 2
#if os(macOS)
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
#endif
	}
}
/*
 // MARK: Preview
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
 }
 }
 */
