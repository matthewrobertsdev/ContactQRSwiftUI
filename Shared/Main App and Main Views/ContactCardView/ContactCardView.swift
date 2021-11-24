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
		// MARK: Ttitle and Fields
		VStack(alignment: .center, spacing: 20) {
			Text(viewModel.card.filename).font(.system(size: 30)).padding(.vertical, 5).foregroundColor(Color("Dark "+viewModel.card.color, bundle: nil))
			ScrollView {
				ForEach(viewModel.displayModel) {fieldInfo in
					ContactFieldView(model: fieldInfo)
					Spacer(minLength: 20)
				}
			}
		}.onChange(of: viewModel.card) { _ in
			viewModel.makeDisplayModel()
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
