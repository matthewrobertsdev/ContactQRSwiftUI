//
//  SiriDescriptionView.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/25/22.
//

import SwiftUI

struct SiriDescriptionView: View {
	var iOSPadding=CGFloat(0)
	init() {
#if os(iOS)
		if UIDevice.current.userInterfaceIdiom == .phone {
			iOSPadding=7.5
		}
#endif
	}
    var body: some View {
		HStack{
			Text("Show a chosen card's QR code with Siri.").font(.system(.title3))
			Spacer()
		}.padding(7.5).padding(.bottom, iOSPadding).padding(.top, iOSPadding)
    }
}

struct SiriDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SiriDescriptionView()
    }
}
