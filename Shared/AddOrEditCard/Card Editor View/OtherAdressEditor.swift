//
//  OtherAdressEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct OtherAdressEditor: View {
	@StateObject var viewModel: CardEditorViewModel
	var body: some View {
		Section(header: Text("Other Address")) {
			Group{
			TextField("Street Address", text: $viewModel.otherStreetAddress)
			TextField("City", text: $viewModel.otherCity)
			TextField("State", text: $viewModel.otherState)
			TextField("Zip", text: $viewModel.otherZip)
			}
#if os(macOS)
			.padding(.horizontal)
#endif
		}
	}
}
/*
struct OtherAdressEditorView_Previews: PreviewProvider {
    static var previews: some View {
        OtherAdressEditorView()
    }
}
*/
