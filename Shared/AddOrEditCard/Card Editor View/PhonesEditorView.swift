//
//  PhoneEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct PhonesEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		Section(header: Text("Phone Numbers")) {
			Group{
			TextField("Mobile", text: $viewModel.mobilePhone)
			TextField("Work #1", text: $viewModel.workPhone1)
			TextField("Work #2", text: $viewModel.workPhone2)
			TextField("Home", text: $viewModel.homePhone)
			TextField("Other", text: $viewModel.otherPhone)
			}
#if os(macOS)
			.padding(.horizontal)
#endif
		}
    }
}

/*
struct PhoneEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneEditorView()
    }
}
*/
