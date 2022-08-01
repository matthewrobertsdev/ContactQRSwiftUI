//
//  CardQRCode.swift
//  ShowCardSiriIntentUI
//
//  Created by Matt Roberts on 7/21/22.
//

import SwiftUI

struct WatchCardQRCode: View {
	@State var card: ContactCardMO
	@Binding var selectedCard: ContactCardMO?
	@State private var isPresentingDetails=false
	init(card: ContactCardMO, selectedCard: Binding<ContactCardMO?>) {
		self.card=card
		self._selectedCard=selectedCard
	}
    var body: some View {
		if selectedCard==nil {
			NoCardSelectedView()
		} else {
			ScrollView {
			Image(uiImage: UIImage(data: card.qrCodeImage ?? Data()) ?? UIImage()).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color.black).background(Color("Light "+card.color, bundle: nil)).padding().accessibilityLabel("\(card.color) QR Code")
				Button {
					isPresentingDetails=true
				} label: {
					Text("Details").foregroundColor(Color.accentColor)
				}

			}.fullScreenCover(isPresented: $isPresentingDetails) {
				WatchCardView(card: card, selectedCard: $selectedCard).toolbar(content: {
					ToolbarItem(placement: .cancellationAction) {
						Button("Close") {
							isPresentingDetails = false
						}.foregroundColor(Color.accentColor)
					}
				})
			}
		}
    }
}

/*
struct CardQRCode_Previews: PreviewProvider {
    static var previews: some View {
        CardQRCode()
    }
}
*/
