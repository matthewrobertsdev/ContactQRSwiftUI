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
	#if os(macOS)
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	#endif
	//the persistence controller (contains core data including managed object context)
    let persistenceController = PersistenceController.shared
	@State var selectedCard: ContactCardMO?
	@State private var showingMenuAddCardSheet = false
	@State private var showingAddCardSheet = false
	@State private var showingEmptyTitleAlert = false

	//the body
	// MARK: Scene
    var body: some Scene {
        WindowGroup {
			//main view with access to managed object context from environment
			ContentView(selectedCard: $selectedCard, showingAddCardSheet: $showingAddCardSheet)
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
#if os (macOS)
				.sheet(isPresented: $showingMenuAddCardSheet) {
					//sheet for editing card
					if #available(iOS 15, macOS 12.0, *) {
						AddOrEditCardSheet(viewContext: persistenceController.container.viewContext, showingAddOrEditCardSheet: $showingMenuAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, persistenceController.container.viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
							Button("Got it.", role: .none, action: {})
						}, message: {
							Text("Card title must not be blank.")
						})
					} else {
						AddOrEditCardSheet(viewContext: persistenceController.container.viewContext, showingAddOrEditCardSheet: $showingMenuAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, persistenceController.container.viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
							Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
						})
					}
				}
				// MARK: macOS Frame
				.frame(minWidth: 700, idealWidth: 800, maxWidth: nil, minHeight: 450, idealHeight: 450, maxHeight: nil, alignment:.center).onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
 }
#endif
		}.commands {
			SidebarCommands()
#if os(macOS)
			// MARK: Commands
			CommandMenu("Cards") {
				Button(action: {
					showingMenuAddCardSheet.toggle()
					}, label: {
						Text("Add Card")
					}).keyboardShortcut("n", modifiers: [.command]).disabled(isModal())
				Button(action: {
					
					}, label: {
						Text("Edit Card")
					})
				Button(action: {
					
					}, label: {
						Text("Delete Card")
					})
				Divider()
				Button(action: {
					
					}, label: {
						Text("Export as vCard...")
					}).keyboardShortcut("e", modifiers: [.command])
				Button(action: {
					
					}, label: {
						Text("Share Card")
					})
				Divider()
				Button(action: {
					
					}, label: {
						Text("Show QR Code")
					}).keyboardShortcut("1", modifiers: [.command])
				Divider()
				Button(action: {
					
					}, label: {
						Text("Manage Cards...")
					})
			}
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
	
	func isModal() -> Bool {
		return showingMenuAddCardSheet || showingAddCardSheet
	}
}
