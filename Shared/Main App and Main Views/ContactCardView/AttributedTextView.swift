//
//  AttributedTextView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//

import SwiftUI

struct AttributedTextView: View  {
	@State var size: CGSize = .zero
	var attributedString: NSAttributedString

	var body: some View {
		#if os(macOS)
		NSTextViewRepresentable(attributedString: attributedString, size: $size)
			.frame(width: size.width, height: size.height)
		#elseif os(iOS)
		Text("Placeholder View")
		#endif
	}
}

struct AttributedTextView_Previews: PreviewProvider {
    static var previews: some View {
		AttributedTextView(size: .zero, attributedString: NSAttributedString(string: "Sample String"))
    }
}
