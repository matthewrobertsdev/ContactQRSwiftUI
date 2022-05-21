//
//  CardDataView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/16/22.
//

import SwiftUI
struct CardDataView: View {
	@State private var card: ContactCardMO
	@State private var withComma: Bool
	private let imageLength=CGFloat(225)
	init(card: ContactCardMO, withComma: Bool) {
		self.card=card
		self.withComma=withComma
	}
    var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			Text("{").padding(.leading)
		VStack(alignment: .leading, spacing: 15) {
			Text("title: \(card.filename)").fixedSize(horizontal: false, vertical: true)
			Text("color: \(card.color)").fixedSize(horizontal: false, vertical: true)
			Text("vCard: \(card.vCardString)").fixedSize(horizontal: false, vertical: true)
#if os(iOS)
			if let qrCodeImage=card.qrCodeImage {
				Text("image:")
				Image(uiImage: getTintedForeground(image: UIImage(data: qrCodeImage) ?? UIImage(), color: UIColor.gray)).resizable().frame(width: imageLength, height: imageLength)
			}
#elseif os(macOS)
			if let qrCodeImage=card.qrCodeImage {
				Text("image:")
				Image(nsImage: getTintedForeground(image: NSImage(data: qrCodeImage) ?? NSImage(), color: NSColor.gray)).resizable().frame(width: imageLength, height: imageLength)
			}
#endif
		}.padding(.leading).padding(.leading)
			if withComma {
				Text("},").padding(.leading)
			} else {
				Text("}").padding(.leading)
			}
		}
    }
}

struct CardDataView_Previews: PreviewProvider {
	static let managedObjectContext=setUpInMemoryManagedObjectContext()
    static var previews: some View {
		CardDataView(card: mockContactCardMO(context: managedObjectContext, color: "Blue", filename: "Professional"), withComma: true)
    }
}
