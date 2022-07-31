//
//  ShowSiriSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/22/22.
//

import SwiftUI
import UIKit
import CoreData
import IntentsUI
struct ShowSiriSheet: View {
	let viewContext=PersistenceController.shared.container.viewContext
	@AppStorage(SiriCardKeys.chosenCardObjectID.rawValue, store: UserDefaults(suiteName: appGroupKey)) var selectedCardIDString: String?
	@StateObject var shortcutDelegate=ShortcutDelegate()
	//fetch sorted by filename (will update automtaicaly)
	@StateObject var myCardsViewModel = MyCardsViewModel(context: PersistenceController.shared.container.viewContext)
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	@Binding var isVisible: Bool
	var body: some View {
		NavigationView {
			ZStack {
				if shortcutDelegate.showingAddShortcutViewController { AddShortcutView(addShortcutViewController: shortcutDelegate.addShortcutViewController).navigationBarTitleDisplayMode(.inline)
				}
				if shortcutDelegate.showingEditShortcutViewController { EditShortcutView(editShortcutViewController: shortcutDelegate.editShortcutViewController).navigationBarTitleDisplayMode(.inline)
				}
			Form {
				Section(header: Text("Chosen card")) {
					Picker(selection: $selectedCardIDString) {
						NoCardChosenRow().tag(nil as String?)
						ForEach(myCardsViewModel.cards, id: \.objectID) { card in
							CardRow(card: card, selected: false).tag(card.objectID.uriRepresentation().absoluteString as String?)
						}
					} label: {
						Text("Card").font(.system(.title3))
					}
					if selectedCardIDString != nil {
						HStack{
							Spacer()
							Button("Remove Card from Siri") {
								withAnimation {
									selectedCardIDString=nil
								}
							}.padding(7.5)
							Spacer()
						}
					}
				}
				Section(header: Text("Shortcut for Siri")) {
					SiriDescriptionView()
					HStack{
						Spacer()
						SiriShortcutButton(shortcutDelegate: shortcutDelegate).padding(7.5)
						Spacer()
					}
				}
			}
			}.navigationBarTitle("For Siri").navigationBarTitleDisplayMode(.large).toolbar {
				ToolbarItem {
				 Button("Done") {
					 dismiss()
				 }
			 }
		 }
		}.onChange(of: selectedCardIDString) { _ in
			let contactCardMO=myCardsViewModel.cards.first(where: { (contactCardMO) -> Bool in
				return selectedCardIDString==contactCardMO.objectID.uriRepresentation().absoluteString
			})
			updateSiriCard(contactCard: contactCardMO)
		}
	}
	
	func dismiss() {
		isVisible=false
	}
}

 struct ShowSiriSheet_Previews: PreviewProvider {
	 static var previews: some View {
		 ShowSiriSheet(isVisible: .constant(true))
			 
	 }
 }
