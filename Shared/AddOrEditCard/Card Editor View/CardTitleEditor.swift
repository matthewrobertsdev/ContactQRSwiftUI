//
//  CardTitleEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct CardTitleEditor: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		Section(header: Text("Card Title")) {
			TextField(viewModel.getTitleTextFieldLabel(), text:  $viewModel.cardTitle).font(.system(size: 25)).foregroundColor(Color("Dark \(viewModel.cardColor)", bundle: nil))
#if os(macOS)
				.padding(.horizontal)
#endif
		}
    }
}

/*
struct CardTitleEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CardTitleEditorView()
    }
}
*/
