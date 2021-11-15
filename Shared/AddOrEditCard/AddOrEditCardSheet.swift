//
//  AddOrEditCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//
import SwiftUI
//to add or edit a card
struct AddOrEditCardSheet: View {
	//shows while true
	@Binding var showingAddOrEditCardSheet: Bool
	//view model for macOS and iOS CardEditorView
	@State var cardEditorViewModel: CardEditorViewModel
	
	@State private var isVisible = false
	//custom init
	init(showingAddOrEditCardSheet: Binding<Bool>) {
		self._showingAddOrEditCardSheet=showingAddOrEditCardSheet
		cardEditorViewModel=CardEditorViewModel()
	}
	let verticalSpacing=CGFloat(20)
	//body
	var body: some View {
		// MARK: Mac Version
#if os(macOS)
		//macOS requires custom navigation
		VStack(alignment: .leading, spacing: 0) {
			//HStack for title
			HStack {
				Text("Add or Edit Card:").font(.system(size: 15))
				Spacer()
			}.padding(.bottom, verticalSpacing)
			//HStack for fill from contact button with border
			HStack {
				Spacer()
				Button {
					isVisible.toggle()
					//handle fill from contact
				} label: {
					Image(systemName: "person.crop.circle")
				}.background(NSContactPickerPopoverView(isVisible: $isVisible) {
					Text("I'm in NSPopover")
		 .padding()
 })
			}.overlay(Rectangle().stroke(Color("Border", bundle: nil), lineWidth: 2))
			//the card editor view that updates the string properties with border
			CardEditorView(viewModel: cardEditorViewModel).navigationTitle(Text("Add or Edit Card")).padding().overlay(Rectangle().stroke(Color("Border", bundle: nil), lineWidth: 2))
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
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Save")
				}
			}.padding(.top, verticalSpacing)
		}.frame(width: 500, height: 600, alignment: .topLeading).padding()
		// MARK: iOS Version
#elseif os(iOS)
		//iOS uses standard navigation
		NavigationView {
			//the card editor view that updates the string properties
			CardEditorView(viewModel: cardEditorViewModel).navigationTitle(Text("Add or Edit Card"))
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
						showingAddOrEditCardSheet.toggle()
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
			AddOrEditCardSheet(showingAddOrEditCardSheet: .constant(true))
			AddOrEditCardSheet(showingAddOrEditCardSheet: .constant(false))
		}
	}
}
