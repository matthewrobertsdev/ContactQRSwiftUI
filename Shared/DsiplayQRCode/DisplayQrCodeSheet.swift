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
		Image(nsImage: (ContactDataConverter.makeQRCode(string: contactCard.vCardString) ?? NSImage() )).resizable().aspectRatio(contentMode: .fit).colorMultiply(Color(contactCard.color, bundle: nil)).padding()
#elseif os(iOS)
		Image(uiImage: ContactDataConverter.makeQRCode(string: contactCard.vCardString ?? UIImage)).resizable().aspectRatio(contentMode: .fit).padding()
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
