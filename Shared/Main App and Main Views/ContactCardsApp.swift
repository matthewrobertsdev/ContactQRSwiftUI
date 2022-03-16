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
	@State private var showingAddCardSheetForDetail = false
	@State private var showingEditCardSheet = false
	@State private var showingQrCodeSheet = false
	@State private var showingEmptyTitleAlert = false

	//the body
	// MARK: Scene
    var body: some Scene {
        WindowGroup {
			//main view with access to managed object context from environment
			ContentView(selectedCard: $selectedCard, modalStateViewModel: ModalStateViewModel(showingAddCardSheet: $showingAddCardSheet, showingAddCardSheetForDetail: $showingAddCardSheetForDetail, showingEditCardSheet: $showingEditCardSheet, showingQrCodeSheet: $showingQrCodeSheet))
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
#if os (macOS)
				.navigationTitle("Card")
				// MARK: macOS Frame
				.frame(minWidth: 700, idealWidth: 700, maxWidth: nil, minHeight: 450, idealHeight: 450, maxHeight: nil, alignment:.center).onAppear {
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
					}).disabled(isModal())
				Divider()
				Button(action: {
					showingEditCardSheet.toggle()
					}, label: {
						Text("Edit Card")
					}).disabled(isModal() || selectedCardIsNil())
				Button(action: {
					
					}, label: {
						Text("Delete Card")
					}).disabled(isModal() || selectedCardIsNil())
				Divider()
				Button(action: {
					
					}, label: {
						Text("Export as vCard...")
					}).disabled(isModal() || selectedCardIsNil())
				Button(action: {
					
					}, label: {
						Text("Share Card")
					}).disabled(isModal() || selectedCardIsNil())
				Button(action: {
					showingQrCodeSheet.toggle()
					}, label: {
						Text("Show QR Code")
					}).keyboardShortcut("1", modifiers: [.command]).disabled(isModal() || selectedCardIsNil())
				Divider()
				Button(action: {
					
					}, label: {
						Text("Manage Cards...")
					}).disabled(isModal())
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
			CommandGroup(before: .undoRedo) {
				Button(action: {
					showingEditCardSheet.toggle()
					}, label: {
						Text("Edit Card")
					}).disabled(isModal() || selectedCardIsNil())
				Button(action: {
					
					}, label: {
						Text("Delete Card")
					}).disabled(isModal() || selectedCardIsNil())
				Divider()
			}
			CommandGroup(replacing: .newItem) {
				Button(action: {
					showingAddCardSheet.toggle()
					}, label: {
						Text("Add Card")
					}).disabled(isModal())
				Divider()
				Button(action: {
					
					}, label: {
						Text("Export as vCard...")
					}).disabled(isModal() || selectedCardIsNil())
				Divider()
				Button(action: {
					
					}, label: {
						Text("Manage Cards...")
					}).disabled(isModal())
			}
#endif
		}
    }
	
	func isModal() -> Bool {
		return showingAddCardSheet || showingAddCardSheetForDetail || showingEditCardSheet || showingQrCodeSheet
	}
	func selectedCardIsNil() -> Bool {
		return selectedCard==nil
	}
}
