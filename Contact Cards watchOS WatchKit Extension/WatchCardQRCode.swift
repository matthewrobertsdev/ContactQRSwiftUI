//
//  CardQRCode.swift
//  ShowCardSiriIntentUI
//
//  Created by Matt Roberts on 7/21/22.
//

import SwiftUI
import Combine
import CoreData
struct WatchCardQRCode: View {
	@StateObject var viewModel: WatchQRViewModel
	@State var card: ContactCardMO
	@Binding var selectedCard: ContactCardMO?
	@State private var isPresentingDetails=false
	init(card: ContactCardMO, selectedCard: Binding<ContactCardMO?>) {
		self.card=card
		self._selectedCard=selectedCard
		self._viewModel = StateObject(wrappedValue: WatchQRViewModel(selectedCard: selectedCard))
	}
    var body: some View {
		if selectedCard==nil {
			NoCardSelectedView()
		} else {
			ScrollView {
				Image(uiImage: UIImage(data: viewModel.qrData) ?? UIImage()).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color.black).background(Color("Light "+(viewModel.color), bundle: nil)).padding().accessibilityLabel("\(viewModel.color) QR Code")
				Button {
					isPresentingDetails=true
				} label: {
					Text("Details").foregroundColor(Color.accentColor)
				}

			}.onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange), perform: { _ in
				viewModel.update(selectedCard: $selectedCard)
			}).fullScreenCover(isPresented: $isPresentingDetails) {
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
