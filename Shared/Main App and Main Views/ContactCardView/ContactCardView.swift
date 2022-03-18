//
//  ContactCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/18/21.
//

import SwiftUI
import CoreData

struct ContactCardView: View {
	@EnvironmentObject var cardSharingViewModel: CardSharingViewModel
	@Environment(\.managedObjectContext) private var viewContext
	// MARK: Modal State
	@State private var showingDeleteAlert = false
	@State private var showingEmptyTitleAlert = false
	// MARK: Card & ViewModel
	@StateObject var card: ContactCardMO
	@StateObject var cardViewModel: CardViewModel
	@StateObject var modalStateViewModel: ModalStateViewModel
	@Binding var selectedCard: ContactCardMO?
	// MARK: init
	init(context: NSManagedObjectContext, card: ContactCardMO, selectedCard: Binding<ContactCardMO?>, modalStateViewModel: ModalStateViewModel) {
		self._selectedCard=selectedCard
		self._card=StateObject(wrappedValue: card)
		self._cardViewModel = StateObject(wrappedValue: CardViewModel(context: context, selectedCard: selectedCard))
		self._modalStateViewModel=StateObject(wrappedValue: modalStateViewModel)
	}
	var body: some View {
		if selectedCard==nil {
			// MARK: No Card Selected
			NoCardSelectedView()
#if os(iOS)
				.toolbar {
					ToolbarItem {
						// MARK: Add Card
						Button(action: addCard) {
							Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
						}
					}
				}
#elseif os(macOS)
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
				// MARK: Title and Fields
				Text(card.filename).font(.system(.largeTitle)).padding(.vertical, 5).foregroundColor(Color("Dark "+card.color, bundle: nil)).padding(.horizontal)
				ScrollView{
					Spacer(minLength: 20)
					ForEach(cardViewModel.fieldInfoModels) {fieldInfo in
						ContactFieldView(model: fieldInfo).padding(.horizontal)
						Spacer(minLength: 20)
					}
					.frame(maxWidth: .infinity)
				}
				Button(action: cardSharingViewModel.writeToPasteboard) {
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
#if os(iOS)
				cardSharingViewModel.update(card: card)
#endif
			}.onChange(of: card.vCardString, perform: { newValue in
				cardViewModel.update(card: card)
#if os(iOS)
				cardSharingViewModel.update(card: card)
#endif
			})
#if os(macOS)
			// MARK: macOS Toolbar
				.toolbar {
					ToolbarItemGroup {
						Menu (
							// MARK: Sharing
							content: {
								ForEach(NSSharingService.sharingServices(forItems: cardSharingViewModel.cardFileArray), id: \.title) { item in
									Button(action: { item.perform(withItems: cardSharingViewModel.cardFileArray) }) {
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
							Button(action: showDeleteAlert) {
								Label("Delete Card", systemImage: "trash")
							}.accessibilityLabel("Delete Card")
						// MARK: Manage Cards
						Button(action: showQrCode) {
							Label("Manage Cards", systemImage: "gearshape")
						}.accessibilityLabel("Manage Card")
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
							}.accessibilityLabel("Delete Card").alert("Are you sure?", isPresented: $showingDeleteAlert, actions: {
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
				.sheet(isPresented: modalStateViewModel.$showingQrCodeSheet) {
					//sheet for displaying qr code
					if let card=cardViewModel.selectedCard {
						DisplayQrCodeSheet(isVisible: modalStateViewModel.$showingQrCodeSheet, contactCard: card)
					}
				}
			// MARK: Edit Sheet
				.sheet(isPresented: modalStateViewModel.$showingEditCardSheet) {
					//sheet for editing card
					if #available(iOS 15, macOS 12.0, *) {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: modalStateViewModel.$showingEditCardSheet, forEditing: true, card: cardViewModel.selectedCard, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
							Button("Got it.", role: .none, action: {})
						}, message: {
							Text("Card title must not be blank.")
						})
					} else {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: modalStateViewModel.$showingEditCardSheet, forEditing: true, card: cardViewModel.selectedCard, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
							Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
						})
					}
				}
			// MARK: Add Sheet
				.sheet(isPresented: modalStateViewModel.$showingAddCardSheetForDetail) {
					//sheet for editing card
					if #available(iOS 15, macOS 12.0, *) {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: modalStateViewModel.$showingAddCardSheetForDetail, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
							Button("Got it.", role: .none, action: {})
						}, message: {
							Text("Card title must not be blank.")
						})
					} else {
						AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: modalStateViewModel.$showingAddCardSheetForDetail, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: cardViewModel.$selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
							Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
						})
					}
				}
		}
	}
	// MARK: Show Modals
	private func addCard() {
		modalStateViewModel.showingAddCardSheet.toggle()
	}
	private func editCard() {
		modalStateViewModel.showingEditCardSheet.toggle()
	}
	private func showQrCode() {
		modalStateViewModel.showingQrCodeSheet.toggle()
	}
	private func showDeleteAlert() {
#if os(macOS)
		modalStateViewModel.showingDeleteAlert.toggle()
#elseif os(iOS)
		showingDeleteAlert.toggle()
#endif
	}
	private func showExportPanel() {
		modalStateViewModel.showingExportPanel.toggle()
	}
	// MARK: Text for Delete
	private func getDeleteTextMessage() -> Text {
		if let card=cardViewModel.selectedCard {
			return Text("Are you sure you want to delete contact card with title \"\(card.filename)\"?")
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
