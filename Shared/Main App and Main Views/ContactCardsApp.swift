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
	@StateObject var vCardViewModel=VCardViewModel()
	@State var selectedCard: ContactCardMO?
	// MARK: Modal State
	@State private var showingAddCardSheet = false
	@State private var showingAddCardSheetForDetail = false
	@State private var showingEditCardSheet = false
	@State private var showingDeleteAlert = false
	@State private var showingExportPanel = false
	@State private var showingQrCodeSheet = false

	//the body
	// MARK: Scene
    var body: some Scene {
        WindowGroup {
			//main view with access to managed object context from environment\
#if os(iOS)
			ContentView(selectedCard: $selectedCard, modalStateViewModel: ModalStateViewModel(showingAddCardSheet: $showingAddCardSheet, showingAddCardSheetForDetail: $showingAddCardSheetForDetail, showingEditCardSheet: $showingEditCardSheet, showingDeleteAlert: $showingDeleteAlert, showingExportPanel: $showingExportPanel, showingQrCodeSheet: $showingQrCodeSheet))
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
#elseif os(macOS)
			if #available(iOS 15, macOS 12.0, *) {
				ContentView(selectedCard: $selectedCard, modalStateViewModel: ModalStateViewModel(showingAddCardSheet: $showingAddCardSheet, showingAddCardSheetForDetail: $showingAddCardSheetForDetail, showingEditCardSheet: $showingEditCardSheet, showingDeleteAlert: $showingDeleteAlert, showingExportPanel: $showingExportPanel, showingQrCodeSheet: $showingQrCodeSheet))
					.environment(\.managedObjectContext, persistenceController.container.viewContext).onChange(of: selectedCard?.vCardString, perform: { _ in
						vCardViewModel.update(card: selectedCard)
					}).onChange(of: selectedCard?.filename, perform: { _ in
						vCardViewModel.update(card: selectedCard)
					})
					.alert("Are you sure?", isPresented: $showingDeleteAlert, actions: {
					Button("Cancel", role: .cancel, action: {})
					Button("Delete", role: .destructive, action: deleteCard
				)}, message: {
					getDeleteTextMessage()
					})
	.fileExporter(
		isPresented: $showingExportPanel, document: vCardViewModel.vCard, contentType: .vCard, defaultFilename: vCardViewModel.filename
	) { result in
		if case .success = result {
			print("Successfully saved vCard")
		} else {
			print("Failed to save vCard")
		}
	}
					.navigationTitle("Card")
					// MARK: macOS Frame
					.frame(minWidth: 700, idealWidth: 700, maxWidth: nil, minHeight: 450, idealHeight: 450, maxHeight: nil, alignment:.center).onAppear {
						NSWindow.allowsAutomaticWindowTabbing = false
					}
			} else {
				ContentView(selectedCard: $selectedCard, modalStateViewModel: ModalStateViewModel(showingAddCardSheet: $showingAddCardSheet, showingAddCardSheetForDetail: $showingAddCardSheetForDetail, showingEditCardSheet: $showingEditCardSheet, showingDeleteAlert: $showingDeleteAlert, showingExportPanel: $showingExportPanel, showingQrCodeSheet: $showingQrCodeSheet)).onChange(of: selectedCard?.vCardString, perform: { _ in
					vCardViewModel.update(card: selectedCard)
				   })
					.onChange(of: selectedCard?.filename, perform: { _ in
						vCardViewModel.update(card: selectedCard)
					   })
					.alert(isPresented: $showingDeleteAlert, content: {
					Alert(
						
						title: Text("Are you sure?"),
						message: getDeleteTextMessage(),
						primaryButton: .default(
							Text("Cancel"),
							action: {}
						),
						secondaryButton: .destructive(
							Text("Delete"),
							action: deleteCard
						)
					)
				})
					.fileExporter(
						isPresented: $showingExportPanel, document: vCardViewModel.vCard, contentType: .vCard, defaultFilename: vCardViewModel.filename
					) { result in
						if case .success = result {
							print("Successfully saved vCard")
						} else {
							print("Failed to save vCard")
						}
					}
					.navigationTitle("Card")
					// MARK: macOS Frame
					.frame(minWidth: 700, idealWidth: 700, maxWidth: nil, minHeight: 450, idealHeight: 450, maxHeight: nil, alignment:.center).onAppear {
						NSWindow.allowsAutomaticWindowTabbing = false
					}
			}
#endif
		}.commands {
			SidebarCommands()
#if os(macOS)
			// MARK: Cards Menu
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
					showingDeleteAlert.toggle()
					}, label: {
						Text("Delete Card")
					}).disabled(isModal() || selectedCardIsNil())
				Divider()
				Button(action: {
					showingExportPanel.toggle()
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
			// MARK: Help Links
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
			// MARK: Edit & Delete
			CommandGroup(before: .undoRedo) {
				Button(action: {
					showingEditCardSheet.toggle()
					}, label: {
						Text("Edit Card")
					}).disabled(isModal() || selectedCardIsNil())
				Button(action: {
					showingDeleteAlert.toggle()
					}, label: {
						Text("Delete Card")
					}).disabled(isModal() || selectedCardIsNil())
				Divider()
			}
			// MARK: File Menu Items
			CommandGroup(replacing: .newItem) {
				Button(action: {
					showingAddCardSheet.toggle()
					}, label: {
						Text("Add Card")
					}).disabled(isModal())
				Divider()
				Button(action: {
					showingExportPanel.toggle()
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
		return showingAddCardSheet || showingAddCardSheetForDetail ||  showingEditCardSheet || showingDeleteAlert || showingExportPanel || showingQrCodeSheet
	}
	func selectedCardIsNil() -> Bool {
		return selectedCard==nil
	}
	// MARK: Text for Delete
	private func getDeleteTextMessage() -> Text {
		if let card=selectedCard {
			return Text("Are you sure you want to delete contact card with title \"\(card.filename)\"?")
		} else {
			return Text("Are you sure you want to delete a contact card?")
		}
	}
	func deleteCard() {
		NotificationCenter.default.post(name: .deleteCard, object: nil)
	}
}
