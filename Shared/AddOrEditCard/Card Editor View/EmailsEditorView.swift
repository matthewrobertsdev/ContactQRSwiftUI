//
//  EmailAddressesEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct EmailsEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		Section(header: Text("Email Addresses")) {
			Group{
			TextField("Home", text: $viewModel.homeEmail)
			TextField("Work #1", text: $viewModel.workEmail1)
			TextField("Work #2", text: $viewModel.workEmail2)
			TextField("Other", text: $viewModel.otherEmail)
			}
#if os(macOS)
			.padding(.horizontal)
#endif
		}
    }
}
/*
struct EmailAddressesEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAddressesEditorView()
    }
}
*/
