//
//  HomeAddressEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct HomeAddressEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
	var body: some View {
		Section(header: Text("Home Address")) {
			Group{
			TextField("Street Address", text: $viewModel.homeStreetAddress)
			TextField("City", text: $viewModel.homeCity)
			TextField("State", text: $viewModel.homeState)
			TextField("Zip", text: $viewModel.homeZip)
			}
#if os(macOS)
			.padding(.horizontal)
#endif
		}
	}
}
/*
struct HomeAddressEditorView_Previews: PreviewProvider {
	static var previews: some View {
		WebsitesEditorView()
	}
}
*/
