//
//  ContactCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/18/21.
//

import SwiftUI

struct ContactCardView: View {
	@Environment(\.managedObjectContext) private var viewContext
	// MARK: Modal State
	@State private var showingEditCardSheet = false
	@State private var showingQrCodeSheet = false
	@State private var showingDeleteAlert = false
	// MARK: Card
	@StateObject var card: ContactCardMO
	var body: some View {
		VStack(alignment: .center, spacing: 20) {
			// MARK: Title and Fields
			Text(card.filename).font(.system(size: 30)).padding(.vertical, 5).foregroundColor(Color("Dark "+card.color, bundle: nil))
			ScrollView {
				ForEach(CardPreviewViewModel.makeDisplayModel(card: card)) {fieldInfo in
					ContactFieldView(model: fieldInfo).padding(.horizontal)
					Spacer(minLength: 20)
				}
			}
		}.onAppear {
			ActiveContactCard.shared.card=card
		}
#if os(macOS)
		.toolbar {
			// MARK: macOS Toolbar
			ToolbarItemGroup {
				Button(action: showQrCode) {
					Label("Share Card", systemImage: "square.and.arrow.up")
				}.accessibilityLabel("Share Card")
				Button(action: showQrCode) {
					Label("Show QR Code", systemImage: "qrcode")
				}.accessibilityLabel("Show QR Code")
				Button(action: showQrCode) {
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
								action: {}
							),
							secondaryButton: .destructive(
								Text("Delete"),
								action: deleteActiveContact
							)
						)})
					
				}
				Button(action: showQrCode) {
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
		.navigationBarTitle("Card").navigationBarTitleDisplayMode(.inline)
#endif
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
}

/*
 struct ContactCardView_Previews: PreviewProvider {
 static var previews: some View {
 ContactCardView(viewModel: CardPreviewViewModel(card: ContactCardMO()))
 }
 }
 */
