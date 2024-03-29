//
//  ContentView.swift
//  Contact Cards (watchOS) WatchKit Extension
//
//  Created by Matt Roberts on 7/17/22.
//

import SwiftUI

struct ContentView: View {
	// MARK: Cloud Kit
	//managed object context from environment
	@Environment(\.managedObjectContext) private var viewContext
	//fetch sorted by filename (will update automtaicaly)
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ContactCardMO.filename, ascending: true)],
		animation: .default)
	//the fetched cards
	private var contactCards: FetchedResults<ContactCardMO>
	@State private var selectedCard: ContactCardMO?
    var body: some View {
		mainContent()
    }

	// MARK: Main Content
	@ViewBuilder
	func mainContent() -> some View {
		if contactCards.isEmpty {
			ScrollView {
				Text("No cards loaded from the cloud yet.  Is iCloud enabled on a device with internet and have you added at least 1 card?  If so, give the watch some time with internet and check back later.")
			}.navigationTitle("My Cards")
		} else {
			ScrollViewReader { proxy in
				List() {
					Section {
						naviagtionForEach()
					} header: {
						Text("Choose card without much info for small screen:")
					}
				}.onChange(of: selectedCard) { target in
					if let target = target {
						proxy.scrollTo(target.objectID, anchor: nil)
					}
				}
			}.navigationTitle("My Cards")
		}
		// MARK: Default View
		NoCardSelectedView()
	}

	// MARK: Navigation ForEach
	@ViewBuilder
	func naviagtionForEach() -> some View {
		ForEach(contactCards, id: \.objectID) { card in
			//view upon selection by list
			NavigationLink(tag: card, selection: $selectedCard) {
				// MARK: Card View
				WatchCardQRCode(card: card, selectedCard: $selectedCard).navigationTitle(Text("Card"))
			} label: {
				Text(card.filename).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(.title3)).foregroundColor( Color("Dark "+card.color, bundle: nil)).padding()
			}
		}
	}
}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 */
