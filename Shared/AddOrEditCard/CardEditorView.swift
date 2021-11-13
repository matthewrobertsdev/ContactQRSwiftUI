//
//  CardEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//

import SwiftUI

struct CardEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
	//horizontal padding for views in scroll view
	let horizontalPadding=CGFloat(3)
	//body
	var body: some View {
		ScrollView {
			Group {
				Group {
					//name
					CardEditorTitle(text: "Name")
					VStack(alignment: .leading) {
						Text("First name")
						RoundedBorderTextField(text: $viewModel.firstName)
						Text("Last name")
						RoundedBorderTextField(text: $viewModel.lastName)
					}
				}
				Group {
					//name details
					VStack(alignment: .leading) {
						Text("Prefix")
						RoundedBorderTextField(text: $viewModel.prefix)
						Text("Suffix")
						RoundedBorderTextField(text: $viewModel.suffix)
						Text("Nickname")
						RoundedBorderTextField(text: $viewModel.nickname)
					}
				}
				Group {
					//job
					CardEditorTitle(text: "Job")
					VStack(alignment: .leading) {
						Text("Company")
						RoundedBorderTextField(text: $viewModel.company)
						Text("Job Title")
						RoundedBorderTextField(text: $viewModel.jobTitle)
						Text("Department")
						RoundedBorderTextField(text: $viewModel.department)
					}
				}
			}.padding(.leading, horizontalPadding).padding(.trailing, horizontalPadding)
		}.padding(.bottom).padding(.top)
	}
}

struct CardEditorView_Previews: PreviewProvider {
	static var previews: some View {
		CardEditorView(viewModel: CardEditorViewModel())
	}
}
