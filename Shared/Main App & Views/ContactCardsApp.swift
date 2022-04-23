//
//  Contact_CardsApp.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//
#if os(macOS)
import AppKit
#endif
import SwiftUI
@main
struct ContactCardsApp: App {
	// MARK: macOS App Delegate
#if os(macOS)
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
	//the persistence controller (contains core data including managed object context)
	// MARK: Model
	let persistenceController = PersistenceController.shared
	@StateObject var cardSharingViewModel=CardSharingViewModel()
	@State var selectedCard: ContactCardMO?
	// MARK: Modal State
	@State private var showingAddCardSheet = false
	@State private var showingAddCardSheetForDetail = false
	@State private var showingEditCardSheet = false
	@State private var showingDeleteAlert = false
	@State private var showingExportPanel = false
	@State private var showingQrCodeSheet = false
	@State private var showingShareSheet = false
	@State private var showingSiriSheet = false
	@State private var showingManageCardsSheet = false
#if os(macOS)
	@State private var sharingDelegate=SharingServiceDelegate()
#endif
	//the body
	// MARK: Scene
	var body: some Scene {
		WindowGroup {
			//main view with access to managed object context from environment
			// MARK: iOS Main View
#if os(iOS)
			mainView()
#elseif os(macOS)
			if #available(iOS 15, macOS 12.0, *) {
				// MARK: macOS Main View new
				macOSMainView()
					.alert("Are you sure?", isPresented: $showingDeleteAlert, actions: {
						Button("Cancel", role: .cancel, action: {})
						Button("Delete", role: .destructive, action: deleteCard
						)}, message: {
							getDeleteTextMessage()
						})
			} else {
				// MARK: macOS Main View old
				macOSMainView()
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
			}
#endif
		}.commands {
			// MARK: Sidebar Commands
			SidebarCommands()
#if os(macOS)
			CommandMenu("Cards") {
				// MARK: Add Card Item
				Button(action: {
					showingAddCardSheet.toggle()
				}, label: {
					Text("Add Card")
				}).disabled(isModal())
				Divider()
				// MARK: Edit & Delete Items
				editMenuItems()
				Divider()
				Group{
					// MARK: Export Item
					Button(action: {
						showingExportPanel.toggle()
					}, label: {
						Text("Export as vCard...")
					}).disabled(isModal() || selectedCardIsNil())
					// MARK: Share Cards Menu
					Menu("Share Card") {
						if NSSharingService.sharingServices(forItems: cardSharingViewModel.cardFileArray).count==0 {
							Button(action: {
								
							}, label: {
								Text("No card selected")
							}).disabled(true)
						} else {
							ForEach(cardSharingViewModel.sharingItems, id: \.title) { item in
								Button(action: {
									item.delegate=sharingDelegate
									item.perform(withItems: cardSharingViewModel.cardFileArray) }) {
									Image(nsImage: item.image)
									Text(item.title)
								}
							}
						}
					}.disabled(isModal() || selectedCardIsNil())
					// MARK: QR Code Item
					Button(action: {
						showingQrCodeSheet.toggle()
					}, label: {
						Text("Show QR Code")
					}).keyboardShortcut("1", modifiers: [.command]).disabled(isModal() || selectedCardIsNil())
				}
				Divider()
				// MARK: Manage Cards Item
				Button(action: {
					showingManageCardsSheet=true
				}, label: {
					Text("Manage Cards...")
				}).disabled(isModal())
				
			}
			
			// MARK: Help Menu Items
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
			// MARK: Edit & Delete Menu Items
			CommandGroup(before: .undoRedo) {
				editMenuItems()
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
					showingManageCardsSheet.toggle()
				}, label: {
					Text("Manage Cards...")
				}).disabled(isModal())
			}
#endif
		}
	}
	// MARK: Main Content View
	func mainView() -> some View {
		ContentView(selectedCard: $selectedCard, modalStateViewModel: ModalStateViewModel(showingAddCardSheet: $showingAddCardSheet, showingAddCardSheetForDetail: $showingAddCardSheetForDetail, showingEditCardSheet: $showingEditCardSheet, showingDeleteAlert: $showingDeleteAlert, showingExportPanel: $showingExportPanel, showingQrCodeSheet: $showingQrCodeSheet, showingShareSheet: $showingShareSheet, showingSiriSheet: $showingSiriSheet, showingManageCardsSheet: $showingManageCardsSheet))
			.environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(cardSharingViewModel)
	}
#if os(macOS)
	// MARK: macOS Main Content View
	func macOSMainView() -> some View {
		mainView()
		// MARK: Export Selected Card
			.fileExporter(
				isPresented: $showingExportPanel, document: cardSharingViewModel.vCard, contentType: .vCard, defaultFilename: getFilename()
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

	// MARK: Edit Menu Items
	func editMenuItems() -> some View {
		Group{
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
			Button(action: {
				cardSharingViewModel.writeToPasteboard()
			}, label: {
				Text("Copy vCard")
			}).disabled(isModal() || selectedCardIsNil())
		}
	}
	// MARK: Menu Item Checks
	func isModal() -> Bool {
		return showingAddCardSheet || showingAddCardSheetForDetail ||  showingEditCardSheet || showingDeleteAlert || showingExportPanel || showingQrCodeSheet || showingManageCardsSheet
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
	func getFilename() -> String {
		if let card=selectedCard {
			return card.filename
		} else {
			return ""
		}
	}
#endif
}
#if os(macOS)
class SharingServiceDelegate: NSObject, NSSharingServiceDelegate {
	func sharingService(_ sharingService: NSSharingService,
	   sourceWindowForShareItems items: [Any],
						sharingContentScope: UnsafeMutablePointer<NSSharingService.SharingContentScope>) -> NSWindow? {
		return NSApp.windows.first
	}
}
#endif
