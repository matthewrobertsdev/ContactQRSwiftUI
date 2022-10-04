//
//  ContactCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/18/21.
//

import SwiftUI
import CoreData
import Combine


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
#if os(macOS)
	@State private var sharingDelegate=SharingServiceDelegate()
#endif
	@Binding var selectedCard: ContactCardMO?
	// MARK: init
	init(context: NSManagedObjectContext, card: ContactCardMO, selectedCard: Binding<ContactCardMO?>, modalStateViewModel: ModalStateViewModel) {
		print("Constructor")
		self._selectedCard=selectedCard
		self._card=StateObject(wrappedValue: card)
		self._cardViewModel = StateObject(wrappedValue: CardViewModel(context: context, selectedCard: selectedCard))
		self._modalStateViewModel=StateObject(wrappedValue: modalStateViewModel)
	}
	var body: some View {
		if selectedCard==nil {
			// MARK: No Card Selected
			NoCardSelectedView()
#if os(macOS)
				.toolbar{
					ToolbarItem(placement: .primaryAction) {
						// MARK: Manage Cards
						Button(action: showManageCardsSheet) {
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
				Text(cardViewModel.filename).font(.system(.largeTitle)).padding(.vertical, 5).foregroundColor(Color("Dark "+cardViewModel.color, bundle: nil)).padding(.horizontal)
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
						Text(cardViewModel.filename).font(.system(.largeTitle)).padding(.vertical, 5).foregroundColor(Color("Dark "+cardViewModel.color, bundle: nil)).padding(.horizontal).multilineTextAlignment(.center)
						Spacer()
					}
					ForEach(cardViewModel.fieldInfoModels) {fieldInfo in
						ContactFieldView(model: fieldInfo).padding(.horizontal)
					}
				}
#endif
			}.onReceive(NotificationCenter.default.publisher(for: .cardChanged), perform: { _ in
				modalStateViewModel.showingDetail=true
				cardSharingViewModel.update(card: selectedCard)
				cardViewModel.update(card: $selectedCard)
			}).onAppear {
				modalStateViewModel.showingDetail=true
				cardSharingViewModel.update(card: selectedCard)
				cardViewModel.update(card: $selectedCard)
			}.onChange(of: selectedCard?.vCardString, perform: { newValue in
				cardSharingViewModel.update(card: selectedCard)
				cardViewModel.update(card: $selectedCard)
			}).onChange(of: selectedCard?.filename, perform: { newValue in
				cardSharingViewModel.update(card: selectedCard)
				cardViewModel.update(card: $selectedCard)
			}).onChange(of: selectedCard?.color, perform: { newValue in
				cardSharingViewModel.update(card: selectedCard)
				cardViewModel.update(card: $selectedCard)
			})
			.onDisappear {
				modalStateViewModel.showingDetail=false
			}
#if os(macOS)
			// MARK: macOS Toolbar
				.toolbar {
					ToolbarItem(placement: .primaryAction) {
						Menu (
							// MARK: Sharing
							content: {
								ForEach(cardSharingViewModel.sharingItems, id: \.title) { item in
									Button(action: {
										item.delegate=sharingDelegate
										item.perform(withItems: cardSharingViewModel.cardFileArray) }) {
											Image(nsImage: item.image)
											Text(item.title)
										}
								}
							},
							label: {
								Image(systemName: "square.and.arrow.up")
							}
						)
					}
					ToolbarItem(placement: .primaryAction) {
						// MARK: Show QR
						Button(action: showQrCode) {
							Label("Show QR Code", systemImage: "qrcode")
						}.accessibilityLabel("Show QR Code")
					}
					ToolbarItem(placement: .primaryAction) {
						// MARK: Export vCard
						Button(action: showExportPanel) {
							Label("Export Card", systemImage: "doc.badge.plus")
						}.accessibilityLabel("Export Card")
					}
					ToolbarItem(placement: .primaryAction) {
						// MARK: Edit Card
						Button(action: editCard) {
							Label("Edit Card", systemImage: "pencil")
						}.accessibilityLabel("Edit Card")
					}
					ToolbarItem(placement: .primaryAction) {
						// MARK: Delete Card
						Button(action: showDeleteAlert) {
							Label("Delete Card", systemImage: "trash")
						}.accessibilityLabel("Delete Card")
					}
					ToolbarItem(placement: .primaryAction) {
						// MARK: Manage Cards
						Button(action: showManageCardsSheet) {
							Label("Manage Cards", systemImage: "gearshape")
						}.accessibilityLabel("Manage Card")
					}
				}
			// MARK: iOS Toolbar
#elseif os(iOS)
				.toolbar {
						// MARK: Delete Card
					ToolbarItem(placement: .destructiveAction) {
						if #available(iOS 15, macOS 12.0, *) {
							Button(action: showDeleteAlert) {
								Text("Delete").accessibilityLabel("Delete Card").foregroundColor(Color.red)
							}.accessibilityLabel("Delete Card").alert("Are you sure?", isPresented: $showingDeleteAlert, actions: {
								Button("Cancel", role: .cancel, action: {})
								Button("Delete", role: .destructive, action: cardViewModel.deleteCard)
							}, message: {
								getDeleteTextMessage()
							})
						}
						
						else {
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
					}
					ToolbarItem(placement: .primaryAction) {
						// MARK: Show QR
						Button(action: showQrCode) {
							Label("Show QR Code", systemImage: "qrcode").accessibilityLabel("Show QR Code")
						}.keyboardShortcut("1", modifiers: [.command])
					}
					ToolbarItem(placement: .primaryAction) {
						// MARK: Share
						Button(action: showShareSheet) {
							Label("Share Card", systemImage: "square.and.arrow.up").accessibilityLabel("Share Card")
						}
					}
					ToolbarItem(placement: .primaryAction) {
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
			#if os(macOS)
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
			#elseif os(iOS)
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
				.sheet(isPresented: modalStateViewModel.$showingShareSheet) {
					ShareSheet(activityItems: cardSharingViewModel.cardFileArray)
				}
			#endif
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
	private func showShareSheet() {
		modalStateViewModel.showingShareSheet.toggle()
	}
	private func showManageCardsSheet() {
		modalStateViewModel.showingManageCardsSheet.toggle()
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

extension NSNotification.Name {
	static let cardChanged = Notification.Name("cardChanged")
}
