//
//  ContactCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/18/21.
//

import SwiftUI

struct ContactCardView: View {
	@StateObject var card: ContactCardMO
    var body: some View {
		// MARK: Title and Fields
		VStack(alignment: .center, spacing: 20) {
			Text(card.filename).font(.system(size: 30)).padding(.vertical, 5).foregroundColor(Color("Dark "+card.color, bundle: nil))
			ScrollView {
				ForEach(CardPreviewViewModel.makeDisplayModel(card: card)) {fieldInfo in
					ContactFieldView(model: fieldInfo).padding(.horizontal)
					Spacer(minLength: 20)
				}
			}
		}.onAppear {
			ActiveContactCard.shared.card=card
		}
		/*.onChange(of: viewModel.card) { _ in
			viewModel.makeDisplayModel()
		}
		 */
#if os(iOS)
		.navigationBarTitle("Card").navigationBarTitleDisplayMode(.inline)
#endif
	}
}

/*
struct ContactCardView_Previews: PreviewProvider {
    static var previews: some View {
		ContactCardView(viewModel: CardPreviewViewModel(card: ContactCardMO()))
    }
}
 */
