//
//  AddOrEditCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//
import SwiftUI
import CoreData
//to add or edit a card
struct AddOrEditCardSheet: View {
	//managed object context from environment
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.presentationMode) private var presentationMode
	//shows while true
	@Binding var showingAddOrEditCardSheet: Bool
	//view model for macOS and iOS CardEditorView
	@StateObject var cardEditorViewModel: CardEditorViewModel
	@State private var isVisible = false
	//custom init
	init(viewContext: NSManagedObjectContext, showingAddOrEditCardSheet: Binding<Bool>, forEditing: Bool, card: ContactCardMO?, showingEmptyTitleAlert: Binding<Bool>, selectedCard: Binding<ContactCardMO?>) {
		self._showingAddOrEditCardSheet=showingAddOrEditCardSheet
		self._cardEditorViewModel=StateObject(wrappedValue: CardEditorViewModel(viewContext: viewContext, forEditing: forEditing, card: card, showingEmptyTitleAlert: showingEmptyTitleAlert, selectedCard: selectedCard))
	}
	//body
	var body: some View {
		// MARK: Mac Version
#if os(macOS)
		//macOS requires custom navigation
		VStack(alignment: .leading, spacing: 0) {
			//HStack for title
			// MARK: Title
			HStack {
				Text(cardEditorViewModel.getTitle()).font(.system(size: 15))
				Spacer()
			}.padding(.bottom, 10)
			//HStack for fill from contact button with border
			// MARK: Fill Card
			HStack {
				Spacer()
				Button {
					isVisible.toggle()
					//handle fill from contact
				} label: {
					Text("Fill from Contact")
					//Image(systemName: "person.crop.circle")
				}.background(NSContactPickerPopoverView(isVisible: $isVisible) {
					Text("Placeholder View")
		 .padding()
				}).padding(2.5)
			}.overlay(Rectangle().stroke(Color("Border", bundle: nil), lineWidth: 2))
			//the card editor view that updates the string properties with border
			//MARK: Card Editor View
			CardEditorView(viewModel: cardEditorViewModel).overlay(Rectangle().stroke(Color("Border", bundle: nil), lineWidth: 2))
			//HStack for cancel and save
			HStack {
				//MARK: Cancel
				Button {
					//handle cancel
					showingAddOrEditCardSheet=false
				} label: {
					Text("Cancel")
				}
				Spacer()
				//MARK: Save
				Button {
					//handle save
					if cardEditorViewModel.saveContact() {
						showingAddOrEditCardSheet=false
					}
				} label: {
					Text("Save")
				}
			}.padding(.top, 20)
		}.frame(width: 450, height: 500, alignment: .topLeading).padding()
		// MARK: iOS Version
#elseif os(iOS)
		//iOS uses standard navigation
		NavigationView {
			//the card editor view that updates the string properties
			//MARK: Card Editor View
			CardEditorView(viewModel: cardEditorViewModel).navigationTitle(Text(cardEditorViewModel.getTitle()))
			//navigation title and buttons
				.navigationBarTitleDisplayMode(.inline).navigationBarItems(leading: Button {
					//MARK: Cancel
					//handle cancel
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Cancel")
				}, trailing: HStack {
					//MARK: Fill Card
					Button {
						//handle fill from contact
					} label: {
						Image(systemName: "person.crop.circle")
					}
					//MARK: Save
					Button {
						//handle save
						if cardEditorViewModel.saveContact() {
							showingAddOrEditCardSheet.toggle()
						}
					} label: {
						Text("Save")
					}
				})
		}

#endif
	}
}
// MARK: Previews
struct AddOrEditCardSheet_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AddOrEditCardSheet(viewContext: PersistenceController.preview.container.viewContext, showingAddOrEditCardSheet: .constant(true), forEditing: false, card: nil, showingEmptyTitleAlert: .constant(false), selectedCard: .constant(nil))
			
		}
	}
}

