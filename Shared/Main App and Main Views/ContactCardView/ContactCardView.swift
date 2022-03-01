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
	@State private var showingAddCardSheet = false
	@State private var showingEditCardSheet = false
	@State private var showingQrCodeSheet = false
	@State private var showingDeleteAlert = false
	@State private var showingEmptyTitleAlert = false
	@State private var showingExportPanel = false
	// MARK: Card & ViewModel
	@StateObject var card: ContactCardMO
	@StateObject var cardPreviewViewModel=CardPreviewViewModel()
	@State private var cardFileArray = [URL]()
	@State private var fileUrl: URL?
	@State private var vCard: VCardDocument?
	@Binding var selectedCard: ContactCardMO?
	var body: some View {
		if selectedCard==nil {
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
		VStack(alignment: .center, spacing: 20) {
			// MARK: Title and Fields
			Text(card.filename).font(.system(size: 30)).padding(.vertical, 5).foregroundColor(Color("Dark "+card.color, bundle: nil))
			ScrollView {
				ForEach(cardPreviewViewModel.fieldInfoModels) {fieldInfo in
					ContactFieldView(model: fieldInfo).padding(.horizontal)
					Spacer(minLength: 20)
				}
			}
#if os(macOS)
			Button(action: writeToPasteboard) {
				Text("Copy vCard")
			}.padding().accessibilityLabel("Copy vCard")
#endif
		}.onAppear {
			cardPreviewViewModel.update(card: card)
			cardFileArray=[URL]()
			DispatchQueue.main.async {
				self.assignSharingFile()
			}
			vCard=VCardDocument(vCard: card.vCardString)
		}.onChange(of: card.vCardString, perform: { newValue in
			cardFileArray=[URL]()
			cardPreviewViewModel.update(card: card)
			DispatchQueue.main.async {
				self.assignSharingFile()
			}
			vCard=VCardDocument(vCard: card.vCardString)
		}).onChange(of: card.filename, perform: { newValue in
			cardFileArray=[URL]()
			DispatchQueue.main.async {
				self.assignSharingFile()
			}
		})
#if os(macOS)
		// MARK: macOS Toolbar
		.toolbar {
			ToolbarItemGroup {
				Menu (
					// MARK: Sharing Menu
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
				// MARK: Show QR Code
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
				// MARK: Manage Cards
				Button(action: showQrCode) {
					Label("Manage Cards", systemImage: "gearshape")
				}.accessibilityLabel("Manage Card")
			}
		}
		.fileExporter(
			isPresented: $showingExportPanel, document: vCard, contentType: .vCard, defaultFilename: card.filename
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
				Button(action: addCard) {
					Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
				}
			}
			ToolbarItemGroup(placement: .bottomBar) {
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
				Spacer()
				Button(action: showQrCode) {
					Label("Show QR Code", systemImage: "qrcode").accessibilityLabel("Show QR Code")
				}
				Spacer()
				Button(action: showQrCode) {
					Label("Share Card", systemImage: "square.and.arrow.up").accessibilityLabel("Share Card")
				}
				Spacer()
				Button(action: editCard) {
					Text("Edit").accessibilityLabel("Edit Card")
				}
			}
		}
		.navigationBarTitle("Card").navigationBarTitleDisplayMode(.inline)
#endif
		// MARK: QR Code Sheet
		.sheet(isPresented: $showingQrCodeSheet) {
			//sheet for displaying qr code
			if let card=selectedCard {
				DisplayQrCodeSheet(isVisible: $showingQrCodeSheet, contactCard: card)
			}
		}
		// MARK: Edit Sheet
		.sheet(isPresented: $showingEditCardSheet) {
			//sheet for editing card
			if #available(iOS 15, macOS 12.0, *) {
				AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingEditCardSheet, forEditing: true, card: selectedCard, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
					Button("Got it.", role: .none, action: {})
				}, message: {
					Text("Card title must not be blank.")
				})
			} else {
				AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingEditCardSheet, forEditing: true, card: selectedCard, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
					Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
				})
			}
		}
			// MARK: Edit Sheet
			.sheet(isPresented: $showingAddCardSheet) {
				//sheet for editing card
				if #available(iOS 15, macOS 12.0, *) {
					AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
						Button("Got it.", role: .none, action: {})
					}, message: {
						Text("Card title must not be blank.")
					})
				} else {
					AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: $showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
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
	// MARK: Delete Contact
	private func deleteActiveContact() {
		//if let card=ActiveContactCard.shared.card {
			viewContext.delete(card)
			do {
				try viewContext.save()
			} catch {
				viewContext.rollback()
				print("Error trying to save deletion of contact card.")
			}
			selectedCard=nil
		//}
	}
	private func getDeleteTextMessage() -> Text {
		if let card=selectedCard {
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
	
#if os(macOS)
	// MARK: Copying vCard
	private func writeToPasteboard() {
		NSPasteboard.general.clearContents()
		guard let fileUrl=fileUrl else {
			return
		}
		NSPasteboard.general.setData(fileUrl.dataRepresentation, forType: .fileURL)
	}
#endif
}

/*
 struct ContactCardView_Previews: PreviewProvider {
 static var previews: some View {
 ContactCardView(viewModel: CardPreviewViewModel(card: ContactCardMO()))
 }
 }
 */
