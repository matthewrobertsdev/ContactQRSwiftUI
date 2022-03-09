//
//  ContactCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/18/21.
//

import SwiftUI
import CoreData

struct ContactCardView: View {
	@Environment(\.managedObjectContext) private var viewContext
	// MARK: Modal State
	@State private var showingAddCardSheet = false
	@State private var showingEditCardSheet = false
	@State private var showingQrCodeSheet = false
	@State private var showingDeleteAlert = false
	@State private var showingEmptyTitleAlert = false
	@State private var showingExportPanel = false
	// MARK: Card & ViewModel
	@StateObject var card: ContactCardMO
	@StateObject var cardViewModel: CardViewModel
	@Binding var selectedCard: ContactCardMO?
	// MARK: init
	init(context: NSManagedObjectContext, card: ContactCardMO, selectedCard: Binding<ContactCardMO?>) {
		self._selectedCard=selectedCard
		self._card=StateObject(wrappedValue: card)
		self._cardViewModel = StateObject(wrappedValue: CardViewModel(context: context, selectedCard: selectedCard))
	}
	var body: some View {
		if selectedCard==nil {
			// MARK: No Card Selected
			NoCardSelectedView()
#if os(macOS)
				.toolbar{
					ToolbarItemGroup {
						// MARK: Manage Cards
						Button(action: showQrCode) {
							Label("Manage Cards", systemImage: "gearshape")
						}.accessibilityLabel("Manage Card")
					}
				}
#endif
		} else {
			Group {
#if os(macOS)
			VStack(alignment: .center, spacing: 0) {
				ScrollView{
					// MARK: Title and Fields
					VStack {
					Text(card.filename).font(.system(.largeTitle)).padding(.vertical, 5).foregroundColor(Color("Dark "+card.color, bundle: nil)).padding(.horizontal)
					ForEach(cardViewModel.fieldInfoModels) {fieldInfo in
						ContactFieldView(model: fieldInfo).padding(.horizontal)
						Spacer(minLength: 20)
					}
					}
					.frame(maxWidth: .infinity)
				}
				Button(action: cardViewModel.writeToPasteboard) {
					Text("Copy vCard")
				}.padding().accessibilityLabel("Copy vCard")

			}
#else
				Form {
					// MARK: Title and Fields
					HStack {
						Spacer()
						Text(card.filename).font(.system(.largeTitle)).padding(.vertical, 5).foregroundColor(Color("Dark "+card.color, bundle: nil)).padding(.horizontal).multilineTextAlignment(.center)
						Spacer()
					}
					ForEach(cardViewModel.fieldInfoModels) {fieldInfo in
						ContactFieldView(model: fieldInfo).padding(.horizontal)
					}
				}
#endif
			}.onAppear {
				cardViewModel.update(card: card)
			}.onChange(of: card.vCardString, perform: { newValue in
				cardViewModel.update(card: card)
			})
#if os(macOS)
			// MARK: macOS Toolbar
				.toolbar {
					ToolbarItemGroup {
						Menu (
							// MARK: Sharing
							content: {
								ForEach(NSSharingService.sharingServices(forItems: cardViewModel.cardFileArray), id: \.title) { item in
									Button(action: { item.perform(withItems: cardViewModel.cardFileArray) }) {
										Image(nsImage: item.image)
										Text(item.title)
									}
								}
							},
							label: {
								Image(systemName: "square.and.arrow.up")
							}
						)
						// MARK: Show QR
						Button(action: showQrCode) {
							Label("Show QR Code", systemImage: "qrcode")
						}.accessibilityLabel("Show QR Code")
						// MARK: Export vCard
						Button(action: showExportPanel) {
							Label("Export Card", systemImage: "doc.badge.plus")
						}.accessibilityLabel("Export Card")
						// MARK: Edit Card
						Button(action: editCard) {
							Label("Edit Card", systemImage: "pencil")
						}.accessibilityLabel("Edit Card")
						// MARK: Delete Card
						if #available(iOS 15, macOS 12.0, *) {
							Button(action: showDeleteAlert) {
								Label("Delete Card", systemImage: "trash")
							}.accessibilityLabel("Delete Card").alert("Are you sure", isPresented: $showingDeleteAlert, actions: {
								Button("Cancel", role: .cancel, action: {})
								Button("Delete", role: .destructive, action: cardViewModel.deleteCard)
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
										action: {}
									),
									secondaryButton: .destructive(
										Text("Delete"),
										action: cardViewModel.deleteCard
									)
								)})
						}
						// MARK: Manage Cards
						Button(action: showQrCode) {
							Label("Manage Cards", systemImage: "gearshape")
						}.accessibilityLabel("Manage Card")
					}
				}
				.fileExporter(
					isPresented: $showingExportPanel, document: cardViewModel.vCard, contentType: .vCard, defaultFilename: card.filename
				) { result in
					if case .success = result {
						print("Successfully saved vCard")
					} else {
						print("Failed to save vCard")
					}
				}
			// MARK: iOS Toolbar
#elseif os(iOS)
				.toolbar {
					ToolbarItem {
						// MARK: Add Card
						Button(action: addCard) {
							Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
						}
					}
					ToolbarItemGroup(placement: .bottomBar) {
						// MARK: Delete Card
						if #available(iOS 15, macOS 12.0, *) {
							Button(action: showDeleteAlert) {
								Text("Delete").accessibilityLabel("Delete Card").foregroundColor(Color.red)
							}.accessibilityLabel("Delete Card").alert("Are you sure", isPresented: $showingDeleteAlert, actions: {
								Button("Cancel", role: .cancel, action: {})
								Button("Delete", role: .destructive, action: cardViewModel.deleteCard)
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
										action: cardViewModel.deleteCard
									)
								)})
							
						}
						Spacer()
						// MARK: Show QR
						Button(action: showQrCode) {
							Label("Show QR Code", systemImage: "qrcode").accessibilityLabel("Show QR Code")
						}
						Spacer()
						// MARK: Share
						Button(action: showQrCode) {
							Label("Share Card", systemImage: "square.and.arrow.up").accessibilityLabel("Share Card")
						}
						Spacer()
						// MARK: Edit Card
						Button(action: editCard) {
							Text("Edit").accessibilityLabel("Edit Card")
						}
					}
				}
				.navigationBarTitle("Card")
#endif
			// MARK: QR Code Sheet
				.sheet(isPresented: $showingQrCodeSheet) {
					//sheet for displaying qr code
					if let card=cardViewModel.selectedCard {
						DisplayQrCodeSheet(isVisible: $showingQrCodeSheet, contactCard: card)
					}
				}
			// MARK: Edit Sheet
				.sheet(isPresented: $showingEditCardSheet) {
					//sheet for editing card
					if #available(iOS 15, macOS 12.0, *) {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingEditCardSheet, forEditing: true, card: cardViewModel.selectedCard, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
							Button("Got it.", role: .none, action: {})
						}, message: {
							Text("Card title must not be blank.")
						})
					} else {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingEditCardSheet, forEditing: true, card: cardViewModel.selectedCard, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
							Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
						})
					}
				}
			// MARK: Add Sheet
				.sheet(isPresented: $showingAddCardSheet) {
					//sheet for editing card
					if #available(iOS 15, macOS 12.0, *) {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
							Button("Got it.", role: .none, action: {})
						}, message: {
							Text("Card title must not be blank.")
						})
					} else {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
							Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
						})
					}
				}
		}
	}
	// MARK: Show Modals
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
	private func showExportPanel() {
		showingExportPanel.toggle()
	}
	// MARK: Text for Delete
	private func getDeleteTextMessage() -> Text {
		if let card=cardViewModel.selectedCard {
			return Text("Are you sure you want to delete contact card with title \(card.filename)?")
		} else {
			return Text("Are you sure you want to delete a contact card?")
		}
	}
}

/*
 struct ContactCardView_Previews: PreviewProvider {
 static var previews: some View {
 ContactCardView(viewModel: CardPreviewViewModel(card: ContactCardMO()))
 }
 }
 */
