//
//  CardRow.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/8/21.
//
import SwiftUI
struct CardRow: View {
	var card: ContactCardMO
    var body: some View {
		HStack{
			Circle().strokeBorder(.gray, lineWidth: 0.7).background(Circle().fill(Color("Dark"+card.color, bundle: nil))).frame(width: 20, height: 20, alignment: .leading)
			Text(card.filename).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 17.5))
		}.padding(7.5)
    }
}
struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
		CardRow(card: ContactCardMO())
    }
}
