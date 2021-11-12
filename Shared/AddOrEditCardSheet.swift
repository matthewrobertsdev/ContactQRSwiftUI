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
    var body: some View {
#if os(macOS)
		//macOS requires custom navigation
		VStack {
			HStack {
				Button {
					//handle cancel
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Cancel")
				}
				Spacer()
				Text("Add or Edit Card")
				Spacer()
				Button {
					//handle done
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Done")
				}
			}
			CardEditorView(firstName: $firstName, lastName: $lastName, prefix: $prefix, suffix: $suffix, nickname: $nickname, company: $company, jobTitle: $jobTitle, department: $department).navigationTitle(Text("Add or Edit Card"))
		}.frame(width: 400, height: 500, alignment: .topLeading).padding()
#elseif os(iOS)
		//iOS uses standard navigation
		NavigationView {
			Text("Add or Edit Card").navigationTitle(Text("Add or Edit Card"))
			//navigation title and buttons
				.navigationBarTitleDisplayMode(.inline).navigationBarItems(leading: Button {
					//handle cancel
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Cancel")
				}, trailing: Button {
					//handle done
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Done")
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
