//
//  CardEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//

import SwiftUI

struct CardEditorView: View {
	//name
	@Binding var firstName: String
	@Binding var lastName: String
	@Binding var prefix: String
	@Binding var suffix: String
	@Binding var nickname: String
	//company
	@Binding var company: String
	@Binding var jobTitle: String
	@Binding var department: String
	//horizontal padding for views in scroll view
	let horizontalPadding=CGFloat(3)
	//body
    var body: some View {
		ScrollView {
			Group {
				//name
				CardEditorTitle(text: "Name")
				VStack(alignment: .leading) {
					Text("First name")
					TextField("", text: $firstName).textFieldStyle(.roundedBorder)
					Text("Last name")
					TextField("", text: $lastName).textFieldStyle(.roundedBorder)
				}
			}.padding(.leading, horizontalPadding).padding(.trailing, horizontalPadding)
			Group {
				//name details
				VStack(alignment: .leading) {
					Text("Prefix")
					TextField("", text: $prefix).textFieldStyle(.roundedBorder)
					Text("Suffix")
					TextField("", text: $suffix).textFieldStyle(.roundedBorder)
					Text("Nickname")
					TextField("", text: $nickname).textFieldStyle(.roundedBorder)
				}
			}.padding(.leading, horizontalPadding).padding(.trailing, horizontalPadding)
			Group {
				//job
				CardEditorTitle(text: "Job")
				VStack(alignment: .leading) {
					Text("Company")
					TextField("", text: $company).textFieldStyle(.roundedBorder)
					Text("Job Title")
					TextField("", text: $jobTitle).textFieldStyle(.roundedBorder)
					Text("Department")
					TextField("", text: $department).textFieldStyle(.roundedBorder)
				}
			}.padding(.leading, horizontalPadding).padding(.trailing, horizontalPadding)
		}.padding(.bottom).padding(.top)
    }
}

struct CardEditorView_Previews: PreviewProvider {
	//name
	@State private static var firstName=""
	@State private static var lastName=""
	@State private static var prefix=""
	@State private static var suffix=""
	@State private static var nickname=""
	//compnay
	@State private static var company=""
	@State private static var jobTitle=""
	@State private static var department=""
    static var previews: some View {
		CardEditorView(firstName: $firstName, lastName: $lastName, prefix: $prefix, suffix: $suffix, nickname: $nickname, company: $company, jobTitle: $jobTitle, department: $department)
    }
}
