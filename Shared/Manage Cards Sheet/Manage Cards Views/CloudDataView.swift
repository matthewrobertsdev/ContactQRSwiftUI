//
//  iCloudDataView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/17/22.
//

import SwiftUI
import CoreData
struct CloudDataView: View {
	@StateObject var myCardsViewModel = MyCardsViewModel(context: PersistenceController.shared.container.viewContext)
    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 15) {
				Text("If you have sync with iCloud on for this app and have given it adequate time for it to sync over the internet, this description should accurately represent your data in iCloud for the Contact Cards app.").foregroundColor(Color.blue).padding()
				Text("[")
				ForEach(myCardsViewModel.cards, id: \.objectID) { card in
					CardDataView(card: card)
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
