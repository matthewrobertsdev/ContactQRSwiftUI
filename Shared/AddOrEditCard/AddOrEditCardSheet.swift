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
	//name
	@State private var firstName=""
	@State private var lastName=""
	@State private var prefix=""
	@State private var suffix=""
	@State private var nickname=""
	//company
	@State private var company=""
	@State private var jobTitle=""
	@State private var department=""
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
						//handle done
						showingAddOrEditCardSheet.toggle()
					} label: {
						Text("Save")
					}
				}
				Text("Add or Edit Card").font(.system(size: 20))
			}
			//the card editor view that updates the string properties
			CardEditorView(firstName: $firstName, lastName: $lastName, prefix: $prefix, suffix: $suffix, nickname: $nickname, company: $company, jobTitle: $jobTitle, department: $department).navigationTitle(Text("Add or Edit Card"))
		}.frame(width: 500, height: 600, alignment: .topLeading).padding()
		//iOS version
#elseif os(iOS)
		//iOS uses standard navigation
		NavigationView {
			//the card editor view that updates the string properties
			CardEditorView(firstName: $firstName, lastName: $lastName, prefix: $prefix, suffix: $suffix, nickname: $nickname, company: $company, jobTitle: $jobTitle, department: $department).navigationTitle(Text("Add or Edit Card"))
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
						//handle done
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
