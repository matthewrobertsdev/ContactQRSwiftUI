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
	@Binding private var isVisible: Bool
	private var contactCard: ContactCardMO
	init(isVisible: Binding<Bool>, contactCard: ContactCardMO) {
		self._isVisible=isVisible
		self.contactCard=contactCard
	}
	var body: some View {
#if os(macOS)
		//MARK: macOS QR Sheet
		VStack {
			Text("Contact Card QR Code").font(.system(size: 18)).padding(.top)
			if let card=contactCard {
				// MARK: QR Code
				Image(nsImage: (ContactDataConverter.makeQRCode(string: card.vCardString) ?? NSImage() )).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color(card.color, bundle: nil)).padding()
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
		}.frame(width: 550, height: 650, alignment: .center)
#elseif os(iOS)
		//MARK: iOS QR Sheet
		NavigationView {
			VStack {
				Text("To help focus on QR Code, tap on screen of camera app or scanner app.")
				Spacer()
				if let card=contactCard {
					// MARK: QR Code
					Image(uiImage: ContactDataConverter.makeQRCode(string: card.vCardString) ?? UIImage()).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color(card.color, bundle: nil)).padding()
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
}

/*
struct DisplayQRCodeSheet_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			DisplayQrCodeSheet(isVisible: .constant(true))
			DisplayQrCodeSheet(isVisible: .constant(false))
		}
	}
}
 */
