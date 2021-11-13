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
	//custom init
	init(showingAddOrEditCardSheet: Binding<Bool>) {
		self._showingAddOrEditCardSheet=showingAddOrEditCardSheet
		cardEditorViewModel=CardEditorViewModel()
	}
	//body
	var body: some View {
		//mac version
#if os(macOS)
		//macOS requires custom navigation
		VStack {
			ZStack {
				HStack {
					Button {
						//handle cancel
						showingAddOrEditCardSheet.toggle()
					} label: {
						Text("Cancel")
					}
					Spacer()
					Button {
						//handle fill from contact
						
					} label: {
						Image(systemName: "person.crop.circle")
					}
					Button {
						//handle save
						print(cardEditorViewModel.firstName)
						showingAddOrEditCardSheet.toggle()
					} label: {
						Text("Save")
					}
				}
				Text("Add or Edit Card").font(.system(size: 20))
			}
			//the card editor view that updates the string properties
			CardEditorView(viewModel: cardEditorViewModel).navigationTitle(Text("Add or Edit Card"))
		}.frame(width: 500, height: 600, alignment: .topLeading).padding()
		//iOS version
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

struct AddOrEditCardSheet_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AddOrEditCardSheet(showingAddOrEditCardSheet: .constant(true))
			AddOrEditCardSheet(showingAddOrEditCardSheet: .constant(false))
		}
	}
}
