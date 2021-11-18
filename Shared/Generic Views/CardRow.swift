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
	@ObservedObject var card: ContactCardMO
	//the body
    var body: some View {
		//horizontal row
		HStack{
			//circle with card color (dark color from named colors in assets)
			Circle().strokeBorder(.gray, lineWidth: 0.7).background(Circle().fill(Color("Dark "+card.color, bundle: nil))).frame(width: 20, height: 20, alignment: .leading)
			//the card filename
			Text(card.filename).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 17.5))
		}.padding(7.5)
    }
}
struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
		CardRow(card: ContactCardMO())
    }
}
