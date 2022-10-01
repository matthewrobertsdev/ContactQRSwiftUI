//
//  DisplayQRCodeSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 11/24/21.
//

import SwiftUI
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
struct DisplayQrCodeSheet: View {
	@Environment(\.colorScheme) var colorScheme
	@Binding private var isVisible: Bool
	private var contactCard: ContactCardMO
	init(isVisible: Binding<Bool>, contactCard: ContactCardMO) {
		self._isVisible=isVisible
		self.contactCard=contactCard
	}
	var body: some View {
#if os(macOS)
		//MARK: macOS QR Sheet
		VStack(alignment: .center, spacing: 0) {
			Text("Card QR Code").font(.system(.title2)).padding(.top)
			if let card=contactCard {
				// MARK: QR Code
				Image(nsImage: (ContactDataConverter.makeQRCode(string: card.vCardString) ?? NSImage() )).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color(card.color, bundle: nil)).background(Color("QR Background")).padding(20)
			}
			HStack {
				Spacer()
				// MARK: Done
				Button {
					//handle done
					isVisible.toggle()
				} label: {
					Text("Done")
				}.keyboardShortcut(.defaultAction)
			}.padding(.bottom).padding(.horizontal)
		}.frame(width: 475, height: 550, alignment: .center)
#elseif os(iOS)
		//MARK: iOS QR Sheet
		if #available(iOS 16, *) {
			NavigationStack {
				iOSContents()
			}
		} else {
			NavigationView {
				iOSContents()
			}
		}
#endif
	}

#if os(iOS)
	func iOSContents() -> some View {
		VStack {
			if UIDevice.current.userInterfaceIdiom == .phone {
				Text("To help focus on QR Code, tap on screen of camera app or scanner app.")
			}
			Spacer()
			if let card=contactCard {
				// MARK: QR Code
				Image(uiImage: ContactDataConverter.makeQRCode(string: card.vCardString) ?? UIImage()).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color("QR Background", bundle: nil)).background(Color(card.color, bundle: nil)).padding().accessibilityLabel("\(card.color) QR Code")
			}
			Spacer()
		}.padding().navigationBarTitle("Card QR Code").toolbar {
			ToolbarItem {
				// MARK: Done
				Button {
					//handle done
					isVisible.toggle()
				} label: {
					Text("Done")
				}.keyboardShortcut(.defaultAction)
			}
		}
	}
#endif
}


struct DisplayQRCodeSheet_Previews: PreviewProvider {
	static let managedObjectContext=setUpInMemoryManagedObjectContext()
	static var previews: some View {
		Group {
			DisplayQrCodeSheet(isVisible: .constant(true), contactCard: mockContactCardMO(context: managedObjectContext, color: "Blue", filename: "Professional"))
		}
	}
}
 
