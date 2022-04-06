//
//  NameEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/2/22.
//

import SwiftUI

struct JobEditor: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		Section(header: Text("Job")) {
			Group{
				TextField("Company", text: $viewModel.company)
				TextField("Title", text: $viewModel.jobTitle)
				TextField("Department", text: $viewModel.department)
			}
#if os(macOS)
				.padding(.horizontal)
#endif
		}
    }
}

/*
struct NameEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NameEditorView()
    }
}
*/
