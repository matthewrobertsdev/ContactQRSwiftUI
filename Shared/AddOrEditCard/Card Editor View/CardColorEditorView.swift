//
//  CardColorEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct CardColorEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		Section(header: Text("Card Color")) {
			ColorSelectionRow(viewModel: viewModel)
#if os(iOS)
				.padding(.top, 5)
#else
				.padding(.bottom)
#endif
    }
	}
}

	/*
struct CardColorEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CardColorEditorView()
    }
}
	 */
