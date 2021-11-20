//
//  ContactCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/18/21.
//

import SwiftUI

struct ContactCardView: View {
	@StateObject var viewModel: CardPreviewViewModel
    var body: some View {
		VStack(alignment: .center, spacing: 20) {
			Text(viewModel.card.filename).font(.system(size: 30)).padding(.vertical, 5).foregroundColor(Color("Dark "+viewModel.card.color, bundle: nil))
			ScrollView {
				VStack(alignment: .center, spacing: 20) {
					ContactFieldView(model: FieldInfoModel(hasLink: false, text: "First Name: Juan", hyperlink: ""))
					ContactFieldView(model: FieldInfoModel(hasLink: true, text: "Work URL:", hyperlink: "https://www.apple.com"))
					ContactFieldView(model: FieldInfoModel(hasLink: true, text: "Work URL:", hyperlink: "https://matthewrobertsdev.github.io/celeritasapps/#/"))
				}
			}
		}
#if os(iOS)
		.navigationBarTitle("Card").navigationBarTitleDisplayMode(.inline)
#endif
	}
}

struct ContactCardView_Previews: PreviewProvider {
    static var previews: some View {
		ContactCardView(viewModel: CardPreviewViewModel(card: ContactCardMO()))
    }
}
