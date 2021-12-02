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
	@State private var showingEmptyTitleAlert = false
	// MARK: Card
	@StateObject var card: ContactCardMO
	@State private var isVisible = false
	@State private var cardFileArray = [URL]()
	@State private var fileUrl: URL?
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
			Button(action: writeToPasteboard) {
				Text("Copy vCard")
			}.padding().accessibilityLabel("Copy vCard")
		}.onAppear {
			ActiveContactCard.shared.card=card
			cardFileArray=[URL]()
			DispatchQueue.main.async {
				self.assignSharingFile()
			}
		}
#if os(macOS)
		.toolbar {
			// MARK: macOS Toolbar
			ToolbarItemGroup {
				Menu (
					content: {
						ForEach(NSSharingService.sharingServices(forItems: cardFileArray), id: \.title) { item in
							Button(action: { item.perform(withItems: cardFileArray) }) {
								Image(nsImage: item.image)
								Text(item.title)
							}
						}
					},
					label: {
						Image(systemName: "square.and.arrow.up")
					}
				)
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
			//sheet for editing card
			if #available(iOS 15, macOS 12.0, *) {
				AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingEditCardSheet, forEditing: true, card: ActiveContactCard.shared.card, showingEmptyTitleAlert: $showingEmptyTitleAlert).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
					Button("Got it.", role: .none, action: {})
				}, message: {
					Text("Card title must not be blank.")
				})
			} else {
				AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingEditCardSheet, forEditing: true, card: ActiveContactCard.shared.card, showingEmptyTitleAlert: $showingEmptyTitleAlert).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
					Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
				})
			}
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
	
	// MARK: Sharing vCard
	private func assignSharingFile() {
		guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return
			}
		fileUrl=ContactDataConverter.writeTemporaryFile(contactCard: card, directoryURL: directoryURL, useCardName: false)
		guard let fileURL=fileUrl else {
			return
		}
		cardFileArray=[fileURL]
	}
	
	// MARK: Copying vCard
	private func writeToPasteboard() {
		NSPasteboard.general.clearContents()
		guard let fileUrl=fileUrl else {
			return
		}
		NSPasteboard.general.setData(fileUrl.dataRepresentation, forType: .fileURL)
	}
}

/*
 struct ContactCardView_Previews: PreviewProvider {
 static var previews: some View {
 ContactCardView(viewModel: CardPreviewViewModel(card: ContactCardMO()))
 }
 }
 */
