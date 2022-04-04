//
//  NameEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/2/22.
//

import SwiftUI

struct NameEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		Section(header: Text("Name")) {
			TextField("First", text: $viewModel.firstName)
			TextField("Last", text: $viewModel.lastName)
			TextField("Prefix", text: $viewModel.prefixString)
			TextField("Suffix", text: $viewModel.suffix)
			TextField("Nickname", text: $viewModel.nickname)
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
