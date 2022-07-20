//
//  SiriQRView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/30/22.
//

import SwiftUI

struct SiriQRView: View {
	@Environment(\.colorScheme) var colorScheme
	@ViewBuilder
    var body: some View {
		if let imageData = UserDefaults(suiteName: appGroupKey)?.data(forKey: SiriCardKeys.chosenCardImageData.rawValue), let colorName = UserDefaults(suiteName: appGroupKey)?.string(forKey: SiriCardKeys.chosenCardColor.rawValue) {
			Image(uiImage: getTintedForeground(image: UIImage(data: imageData) ?? UIImage(), color: UIColor(named: colorName) ?? UIColor.gray)).resizable().aspectRatio(contentMode: .fit).padding(12) .navigationBarHidden(true).accessibilityLabel("\(UserDefaults(suiteName: appGroupKey)?.string(forKey: (SiriCardKeys.chosenCardColor.rawValue)) ?? "") QR Code")
		} else {
			VStack {
				Text("Card not Chosen in App").font(.system(.largeTitle)).multilineTextAlignment(.center)
				Text("Please open Contact Cards, go to \"For Siri\", tap \"Choose Card\", and choose and save your card choice.").font(.system(.title2))
			}.navigationBarHidden(true)
		}
    }
}

struct SiriQRView_Previews: PreviewProvider {
    static var previews: some View {
        SiriQRView()
    }
}
