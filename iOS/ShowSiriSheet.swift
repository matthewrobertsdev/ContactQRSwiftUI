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
	@State var selectedCardID: NSManagedObjectID?=nil
	@State var showingAddShortcutViewController=false
	@State var showingEditShortcutViewController=false
	@StateObject var shortcutDelegate=ShortcutDelegate()
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
		NavigationView {
			VStack {
				NavigationLink(destination: AddShortcutView(addShortcutViewController: shortcutDelegate.addShortcutViewController).navigationBarTitleDisplayMode(.inline), isActive: $shortcutDelegate.showingAddShortcutViewController) { EmptyView() }
				NavigationLink(destination: EditShortcutView(editShortCutViewController: shortcutDelegate.editShortcutViewController).navigationBarTitleDisplayMode(.inline), isActive: $shortcutDelegate.showingEditShortcutViewController) { EmptyView() }
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
