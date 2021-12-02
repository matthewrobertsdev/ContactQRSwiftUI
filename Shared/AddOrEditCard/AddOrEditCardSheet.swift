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
	//shows while true
	@Binding var showingAddOrEditCardSheet: Bool
	//view model for macOS and iOS CardEditorView
	@State var cardEditorViewModel: CardEditorViewModel
	@State private var isVisible = false
	//custom init
	init(viewContext: NSManagedObjectContext, showingAddOrEditCardSheet: Binding<Bool>, forEditing: Bool, card: ContactCardMO?, showingEmptyTitleAlert: Binding<Bool>) {
		self._showingAddOrEditCardSheet=showingAddOrEditCardSheet
		cardEditorViewModel=CardEditorViewModel(viewContext: viewContext, forEditing: forEditing, card: card, showingEmptyTitleAlert: showingEmptyTitleAlert)
	}
	//body
	var body: some View {
		// MARK: Mac Version
#if os(macOS)
		//macOS requires custom navigation
		VStack(alignment: .leading, spacing: 0) {
			//HStack for title
			HStack {
				Text(cardEditorViewModel.getTitle()).font(.system(size: 15))
				Spacer()
			}.padding(.bottom, 10)
			//HStack for fill from contact button with border
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
			CardEditorView(viewModel: cardEditorViewModel).padding().overlay(Rectangle().stroke(Color("Border", bundle: nil), lineWidth: 2))
			//HStack for cancel and save
			HStack {
				Button {
					//handle cancel
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Cancel")
				}
				Spacer()
				Button {
					//handle save
					if cardEditorViewModel.saveContact() {
						showingAddOrEditCardSheet.toggle()
					}
				} label: {
					Text("Save")
				}
			}.padding(.top, 20)
		}.frame(width: 500, height: 600, alignment: .topLeading).padding()
		// MARK: iOS Version
#elseif os(iOS)
		//iOS uses standard navigation
		NavigationView {
			//the card editor view that updates the string properties
			CardEditorView(viewModel: cardEditorViewModel).navigationTitle(Text(cardEditorViewModel.getTitle()))
			//navigation title and buttons
				.navigationBarTitleDisplayMode(.inline).navigationBarItems(leading: Button {
					//handle cancel
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Cancel")
				}, trailing: HStack {
					Button {
						//handle fill from contact
					} label: {
						Image(systemName: "person.crop.circle")
					}
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
			AddOrEditCardSheet(viewContext: PersistenceController.preview.container.viewContext, showingAddOrEditCardSheet: .constant(true), forEditing: false, card: ContactCardMO(), showingEmptyTitleAlert: .constant(true))
			AddOrEditCardSheet(viewContext: PersistenceController.preview.container.viewContext, showingAddOrEditCardSheet: .constant(false), forEditing: false, card: ContactCardMO(), showingEmptyTitleAlert: .constant(false))
		}
	}
}
