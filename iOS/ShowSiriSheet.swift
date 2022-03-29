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
	var navigationController: UINavigationController?
	let viewContext=PersistenceController.shared.container.viewContext
	@State var selectedCardID: NSManagedObjectID?=nil
	//fetch sorted by filename (will update automtaicaly)
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ContactCardMO.filename, ascending: true)],
		animation: .default)
	//the fetched cards
	private var contactCards: FetchedResults<ContactCardMO>
	
	init(isVisible: Binding<Bool>, navigationController: UINavigationController) {
		self._isVisible=isVisible
		self.navigationController=navigationController
	}
	@Binding var isVisible: Bool
	var body: some View {
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
						SiriShortcutButton(navigationController: navigationController).padding(7.5)
						Spacer()
					}
				}
			}
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
	
	func makeUIViewController(context: Context) -> UINavigationController {
		let controller=UINavigationController()
		let siriViewController=ShowSiriUIHostingController(rootView: ShowSiriSheet(isVisible: $isVisible, navigationController: controller))
		siriViewController.navigationItem.title="For Siri"
		siriViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction(handler: { _ in controller.dismiss(animated: true)}), menu: nil)
		controller.setViewControllers([siriViewController], animated: false)
		return controller
	}
	
	func updateUIViewController(_ uiViewController:  UINavigationController, context: Context) {
	}
}

/*
 struct ShowSiriSheet_Previews: PreviewProvider {
	 static var previews: some View {
		 ShowSiriSheet(isVisible: .constant(true))
			 
	 }
 }
*/
