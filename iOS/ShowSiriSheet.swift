//
//  ShowSiriSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/22/22.
//

import SwiftUI
import UIKit
import CoreData
struct ShowSiriSheet: View {
	let viewContext=PersistenceController.shared.container.viewContext
	@State var selectedCardID: NSManagedObjectID?=nil
	//fetch sorted by filename (will update automtaicaly)
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ContactCardMO.filename, ascending: true)],
		animation: .default)
	//the fetched cards
	private var contactCards: FetchedResults<ContactCardMO>
	
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	@Binding var isVisible: Bool
	var body: some View {
		NavigationView(content: {
			Form {
				Section(header: Text("Chosen card")) {
					Picker(selection: $selectedCardID) {
						NoCardChosenRow().tag(nil as NSManagedObjectID?)
						ForEach(contactCards, id: \.objectID) { card in
							CardRow(card: card).tag(card.objectID as NSManagedObjectID?)
						}
					} label: {
						Text("Card").font(.system(.title3))
					}
					if selectedCardID != nil {
						HStack{
							Spacer()
							Button("Remove Card from Siri") {
								withAnimation {
									selectedCardID=nil
								}
							}.padding(7.5)
							Spacer()
						}
					}
				}
				Section(header: Text("Shortcut for Siri")) {
					HStack{
						Text("Show a chosen card's qr code with Siri.").font(.system(.title3))
						Spacer()
					}
					HStack{
						Spacer()
						SiriShortcutButton().padding(7.5)
						Spacer()
					}
				}
			}
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Button(action: dismiss) {
						Text("Done")
					}
				}
			}.navigationTitle("For Siri")
		})
	}
	
	func dismiss() {
		isVisible=false
	}
}

class ShowSiriUIHostingController: UIHostingController<ShowSiriSheet> {
	
}

final class ShowSiriUIViewControllerRepresentable: UIViewControllerRepresentable {
	
	@Environment(\.managedObjectContext) private var viewContext
	
	@Binding var isVisible: Bool
	
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	
	func makeUIViewController(context: Context) -> ShowSiriUIHostingController {
		let controller=ShowSiriUIHostingController(rootView: ShowSiriSheet(isVisible: $isVisible))
		return controller
	}
	
	func updateUIViewController(_ uiViewController:  ShowSiriUIHostingController, context: Context) {
	}
}

/*
 struct ShowSiriSheet_Previews: PreviewProvider {
 static var previews: some View {
 ShowSiriSheet()
 }
 }
 */
