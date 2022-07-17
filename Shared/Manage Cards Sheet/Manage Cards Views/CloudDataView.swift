//
//  iCloudDataView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/17/22.
//

import SwiftUI
import CoreData
struct CloudDataView: View {
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ContactCardMO.filename, ascending: true)],
		animation: .default)
	//the fetched cards
	private var contactCards: FetchedResults<ContactCardMO>
	init() {
	}
    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 15) {
				Text("[")
				ForEach(0..<contactCards.count) { index in
					CardDataView(card: contactCards[index], withComma: index<contactCards.count-1)
				}
				Text("]")
			}.frame(maxWidth: .infinity).padding()
		}.frame(maxWidth: .infinity)
#if os(iOS)
			.navigationBarTitle("Data in iCloud")
#endif
    }
}

struct iCloudDataView_Previews: PreviewProvider {
    static var previews: some View {
        CloudDataView()
    }
}
