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
		VStack {
			Text(card.filename).font(.system(size: 30)).padding(.vertical).foregroundColor(Color("Dark "+card.color, bundle: nil))
			Spacer()
		}
#if os(iOS)
		.navigationBarTitle("Card").navigationBarTitleDisplayMode(.inline)
#endif
    }
}

struct ContactCardView_Previews: PreviewProvider {
    static var previews: some View {
		ContactCardView(card: ContactCardMO())
    }
}
