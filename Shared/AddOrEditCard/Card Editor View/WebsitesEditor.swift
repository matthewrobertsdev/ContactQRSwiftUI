//
//  WebsitesEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct WebsitesEditor: View {
	@StateObject var viewModel: CardEditorViewModel
	var body: some View {
		Section(header: Text("Websites")) {
			Group{
			TextField("Home", text: $viewModel.homeUrl)
			TextField("Work #1", text: $viewModel.workUrl1)
			TextField("Work #2", text: $viewModel.workUrl2)
			TextField("Other #1", text: $viewModel.otherUrl1)
			TextField("Other #2", text: $viewModel.otherUrl2)
			}
#if os(macOS)
			.padding(.horizontal)
#endif
		}
	}
}
/*
struct WebsitesEditorView_Previews: PreviewProvider {
    static var previews: some View {
        WebsitesEditorView()
    }
}
*/
