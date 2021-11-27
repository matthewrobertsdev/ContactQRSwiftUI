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
	let minDetailWidthMacOS=CGFloat(350)
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
	@State private var showingAddCardSheet = false
	@State private var showingEditCardSheet = false
	@State private var showingQrCodeSheet = false
	@State private var showingDeleteAlert = false
	// MARK: Body
	//body
	var body: some View {
		NavigationView {
			// MARK: List
			List {
				ForEach(contactCards, id: \.objectID) { card in
					//view upon selection by list
					NavigationLink {
						/*ContactCardView(viewModel: CardPreviewViewModel(card: card))
						 */
						ContactCardView(card: card)
						// MARK: macOS Toolbar
#if os(macOS)
							.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center).toolbar {
								ToolbarItemGroup {
									Button(action: addCard) {
										Label("Share Card", systemImage: "square.and.arrow.up")
									}.accessibilityLabel("Share Card")
									Button(action: showQrCode) {
										Label("Show QR Code", systemImage: "qrcode")
									}.accessibilityLabel("Show QR Code")
									Button(action: addCard) {
										Label("Export Card", systemImage: "doc.badge.plus")
									}.accessibilityLabel("Export Card")
									Button(action: editCard) {
										Label("Edit Card", systemImage: "pencil")
									}.accessibilityLabel("Edit Card")
									if #available(iOS 15, macOS 12.0, *) {
										Button(action: showDeleteAlert) {
											Label("Delete Card", systemImage: "trash")
										}.accessibilityLabel("Delete Card").alert("Are you sure", isPresented: $showingDeleteAlert, actions: {
											Button("Cancel", role: .cancel, action: {})
											Button("Delete", role: .destructive, action: deleteActiveContact)
										}, message: {
											getDeleteTextMessage()
										})
									} else {
										
										Button(action: showDeleteAlert) {
											Label("Delete Card", systemImage: "trash")
										}.accessibilityLabel("Delete Card").alert(isPresented: $showingDeleteAlert, content: {
											Alert(
												
												title: Text("Are you sure?"),
												message: getDeleteTextMessage(),
												primaryButton: .default(
													Text("Cancel"),
													action: nil
												),
												secondaryButton: .destructive(
													Text("Delete"),
													action: deleteActiveContact
												)
											)})
										
									}
									Button(action: addCard) {
										Label("Manage Cards", systemImage: "gearshape")
									}.accessibilityLabel("Manage Card")
								}
							}
						// MARK: iOS Toolbar
#elseif os(iOS)
							.toolbar {
								ToolbarItem {
									Button(action: showQrCode) {
										Label("Show QR Code", systemImage: "qrcode").accessibilityLabel("Show QR Code")
									}
								}
								ToolbarItemGroup(placement: .bottomBar) {
									Button(action: editCard) {
										Text("Edit").accessibilityLabel("Edit Card")
									}
									Spacer()
									if #available(iOS 15, macOS 12.0, *) {
										Button(action: showDeleteAlert) {
											Text("Delete").accessibilityLabel("Delete Card").foregroundColor(Color.red)
										}.accessibilityLabel("Delete Card").alert("Are you sure", isPresented: $showingDeleteAlert, actions: {
											Button("Cancel", role: .cancel, action: {})
											Button("Delete", role: .destructive, action: deleteActiveContact)
										}, message: {
											getDeleteTextMessage()
										})
									} else {
										Button(action: showDeleteAlert) {
											Text("Delete").accessibilityLabel("Delete Card").foregroundColor(Color.red)
										}.accessibilityLabel("Delete Card").alert(isPresented: $showingDeleteAlert, content: {
											Alert(
												
												title: Text("Are you sure?"),
												message: getDeleteTextMessage(),
												primaryButton: .default(
													Text("Cancel"),
													action: nil
												),
												secondaryButton: .destructive(
													Text("Delete"),
													action: deleteActiveContact
												)
											)})
										
									}
								}
							}
#endif
						// MARK: Label
					} label: {
						//card row: the label (with title and circluar color)
						CardRow(card: card)
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
						Label("Help", systemImage: "questionmark").accessibilityLabel("Help")
					}
					Button(action: addCard) {
						Label("Manage Cards", systemImage: "gearshape").accessibilityLabel("Manage Cards")
					}
				}
#endif
			}.navigationTitle("Contact Cards")
			//if no card is selected, central view is just this text
			Text("No Contact Card Selected").font(.system(size: 18))
			// MARK: macOS Toolbar
#if os(macOS)
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
			AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddCardSheet, forEditing: false, card: nil).environment(\.managedObjectContext, viewContext)
		}
		// MARK: QR Code Sheet
		.sheet(isPresented: $showingQrCodeSheet) {
			//sheet for displaying qr code
			DisplayQrCodeSheet(isVisible: $showingQrCodeSheet)
		}
		// MARK: Edit Sheet
		.sheet(isPresented: $showingEditCardSheet) {
			//sheet for adding or editing card
			AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingEditCardSheet, forEditing: true, card: ActiveContactCard.shared.card).environment(\.managedObjectContext, viewContext)
		}
	}
	// MARK: Show Modals
	//show add or edit card sheet in add mode
	private func addCard() {
		showingAddCardSheet.toggle()
	}
	private func editCard() {
		showingEditCardSheet.toggle()
	}
	private func showQrCode() {
		showingQrCodeSheet.toggle()
	}
	private func showDeleteAlert() {
		showingDeleteAlert.toggle()
	}
	// MARK: Delete Contact
	private func deleteActiveContact() {
		if let card=ActiveContactCard.shared.card {
			viewContext.delete(card)
			ActiveContactCard.shared.card=nil
			do {
				try viewContext.save()
			} catch {
				viewContext.rollback()
				print("Error trying to save deletion of contact card.")
			}
		}
	}
	private func getDeleteTextMessage() -> Text {
		if let card=ActiveContactCard.shared.card {
			return Text("Are you sure you want to delete contact card with title \(card.filename)?")
		} else {
			return Text("Are you sure you want to delete a contact card")
		}
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
}
// MARK: Preview
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
