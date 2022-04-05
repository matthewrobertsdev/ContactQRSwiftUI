//
//  WorkAddressEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct WorkAddressEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
	var body: some View {
		Section(header: Text("Work Address")) {
			Group{
			TextField("Street Address", text: $viewModel.workStreetAddress)
			TextField("City", text: $viewModel.workCity)
			TextField("State", text: $viewModel.workState)
			TextField("Zip", text: $viewModel.workZip)
			}
#if os(macOS)
			.padding(.horizontal)
#endif
		}
	}
}

/*
struct WorkAddressEditorView_Previews: PreviewProvider {
    static var previews: some View {
        WorkAddressEditorView()
    }
}
 */
