//
//  CardRow.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/8/21.
//
import SwiftUI
//a row that displays a colorful circle for a card and its filename
struct CardRow: View {
	//the card managed object
	@StateObject var card: ContactCardMO
	let circleDiameter=CGFloat(20)
	init(card: ContactCardMO) {
		_card=StateObject(wrappedValue: card)
	}
	//the body
    var body: some View {
		//horizontal row
		// MARK: Circle and Text
		HStack{
			//circle with card color (dark color from named colors in assets)
			Circle().strokeBorder(.gray, lineWidth: 0.7).background(Circle().fill(Color("Dark "+card.color, bundle: nil))).frame(width: circleDiameter, height: circleDiameter, alignment: .leading)
			//the card filename
			Text(card.filename).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(.title3))
			Spacer()
		}.padding(7.5)
#if os(iOS)
			.padding(.bottom, 7.5).padding(.top, 7.5)
#endif
    }
}
struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
		CardRow(card: ContactCardMO())
    }
}
