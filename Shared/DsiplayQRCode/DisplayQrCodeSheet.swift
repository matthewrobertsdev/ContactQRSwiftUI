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
	private var contactCard=ActiveContactCard.shared.card
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	var body: some View {
#if os(macOS)
		VStack {
			Text("Contact Card QR Code").font(.system(size: 25)).padding(.top)
			Image(nsImage: (ContactDataConverter.makeQRCode(string: contactCard.vCardString) ?? NSImage() )).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color(contactCard.color, bundle: nil)).padding()
			HStack {
				Spacer()
				Button {
					//handle done
					isVisible.toggle()
				} label: {
					Text("Done")
				}.keyboardShortcut(.defaultAction)
			}.padding(.bottom).padding(.horizontal)
		}.frame(width: 600, height: 650, alignment: .center)
#elseif os(iOS)
		NavigationView {
			VStack {
				Text("To help focus on QR Code, tap on screen of camera app or scanner app.")
				Spacer()
				Image(uiImage: ContactDataConverter.makeQRCode(string: contactCard.vCardString) ?? UIImage()).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color(contactCard.color, bundle: nil)).padding()
				Spacer()
			}.padding().navigationBarTitle("Contact Card QR Code").navigationBarTitleDisplayMode(.inline).toolbar {
				ToolbarItem {
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

struct DisplayQRCodeSheet_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			DisplayQrCodeSheet(isVisible: .constant(true))
			DisplayQrCodeSheet(isVisible: .constant(false))
		}
	}
}
