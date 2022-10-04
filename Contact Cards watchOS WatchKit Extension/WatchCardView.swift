//
//  WatchCardView.swift
//  Contact Cards (watchOS) WatchKit Extension
//
//  Created by Matt Roberts on 7/22/22.
//

import SwiftUI

struct WatchCardView: View {
	// MARK: Card & ViewModel
	@StateObject var card: ContactCardMO
	@StateObject var cardViewModel: WatchCardViewModel
	@Binding var selectedCard: ContactCardMO?
	// MARK: init
	init(card: ContactCardMO, selectedCard: Binding<ContactCardMO?>) {
		self._selectedCard=selectedCard
		self._card=StateObject(wrappedValue: card)
		self._cardViewModel = StateObject(wrappedValue: WatchCardViewModel(selectedCard: selectedCard))
	}
	var body: some View {
		if selectedCard==nil {
			// MARK: No Card Selected
			NoCardSelectedView()
		} else {
				Form {
					// MARK: Title and Fields
					HStack {
						Spacer()
						Text(card.filename).font(.system(.title3)).padding(.vertical, 5).foregroundColor(Color("Dark "+card.color, bundle: nil)).padding(.horizontal).multilineTextAlignment(.center)
						Spacer()
					}
					ForEach(cardViewModel.fieldInfoModels) {fieldInfo in
						ContactFieldView(model: fieldInfo).padding(.horizontal)
					}
				}.onAppear {
					cardViewModel.update(card: card)
			 }.onChange(of: card.vCardString, perform: { newValue in
				 cardViewModel.update(card: card)
			 }).onChange(of: card.filename, perform: { newValue in
				 cardViewModel.update(card: card)
			 }).onChange(of: card.color, perform: { newValue in
				 cardViewModel.update(card: card)
			 })
			
		}
	}
}

	/*
struct WatchCardView_Previews: PreviewProvider {
    static var previews: some View {
        WatchCardView()
    }
}
*/
