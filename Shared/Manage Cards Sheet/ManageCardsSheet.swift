//
//  ManageCardsSheet.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/9/22.
//

import SwiftUI

struct ManageCardsSheet: View {
	private let deleteMessage = "If you want to delete all cards from iCloud, it is recommended that you export your contact cards as an archive first so that you can restore the cards from the archive if you want.  Otherwise, when devices sync, the cards will be lost."
	private let aboutiCloudString = "About Contact Cards Use of iCloud..."
	private let exportToArchiveString = "Export Cards to Archive"
	private let loadCardsString = "Load Cards from Archive"
	private let exportToRTFString = "Export iCloud Data as Rich Text File"
	private let viewDataDescriptionString = "View iCloud Data Description"
	private let restrictOrUnRestrictString = "Restrict or Un-Restrict Access to iCloud"
	private let deleteString = "Delete All Cards from iCloud..."
	@Binding private var isVisible: Bool
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	var body: some View {
#if os(macOS)
		VStack {
			Text("Manage Cards ").font(.system(.title2)).padding(.top)
			VStack(alignment: .center, spacing: 20) {
				Button(aboutiCloudString) {
					
				}
				Button(exportToArchiveString) {
					
				}
				Button(loadCardsString) {
					
				}
				Button(exportToRTFString) {
					
				}
				Button(viewDataDescriptionString) {
					
				}
				Button(restrictOrUnRestrictString) {
					
				}
				Text(deleteMessage).foregroundColor(Color.red)
				Button(deleteString) {
					
				}
			}.padding(.horizontal).padding()
			Spacer()
			HStack {
				Spacer()
				// MARK: Done
				Button {
					//handle done
					isVisible=false
				} label: {
					Text("Done")
				}.keyboardShortcut(.defaultAction)
			}.padding()
		}.frame(width: 475, height: 550, alignment: .top)
#else
		NavigationView {
			ScrollView {
				VStack(alignment: .center, spacing: 15) {
					NavigationLink(aboutiCloudString, destination: EmptyView())
					NavigationLink(exportToArchiveString, destination: EmptyView())
					NavigationLink(loadCardsString, destination: EmptyView())
					NavigationLink(exportToRTFString, destination: EmptyView())
					NavigationLink(viewDataDescriptionString, destination: EmptyView())
					NavigationLink(restrictOrUnRestrictString, destination: EmptyView())
					Text(deleteMessage).foregroundColor(Color.red)
					NavigationLink(deleteString, destination: EmptyView())
				}
			}.padding().navigationBarTitle("Manage Cards").toolbar {
				ToolbarItem {
					Button {
						isVisible=false
					} label: {
						Text("Done")
					}.keyboardShortcut(.defaultAction)
				}
			}
		}
#endif
	}
}

struct ManageCardsSheet_Previews: PreviewProvider {
	static var previews: some View {
		ManageCardsSheet(isVisible: .constant(true))
	}
}
