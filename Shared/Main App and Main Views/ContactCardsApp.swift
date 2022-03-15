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
	@State private var showingAddCardSheet = false
	@State private var showingEditCardSheet = false
	@State private var showingEmptyTitleAlert = false

	//the body
	// MARK: Scene
    var body: some Scene {
        WindowGroup {
			//main view with access to managed object context from environment
			ContentView(selectedCard: $selectedCard, showingAddCardSheet: $showingAddCardSheet, showingEditCardSheet: $showingEditCardSheet)
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
#if os (macOS)
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
					showingAddCardSheet.toggle()
					}, label: {
						Text("Add Card")
					}).keyboardShortcut("n", modifiers: [.command]).disabled(isModal())
				Button(action: {
					showingEditCardSheet.toggle()
					}, label: {
						Text("Edit Card")
					}).disabled(isModal() || selectedCardIsNil())
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
		return showingAddCardSheet || showingEditCardSheet
	}
	func selectedCardIsNil() -> Bool {
		return selectedCard==nil
	}
}
