//
//  iCloudDescriptionView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/10/22.
//

import SwiftUI

struct iCloudDescriptionView: View {
    var body: some View {
#if os(macOS)
		iCloudDescriptionText().padding(.horizontal)
#else
		iCloudDescriptionText()
			.navigationBarTitle("Cards and iCloud")
#endif
    }
	func iCloudDescriptionText() -> some View {
		ScrollView {
			Text(getiCloudDescriptionString()).foregroundColor(Color.blue).padding()
		}
	}
	func getiCloudDescriptionString() -> String {
		var iCloudString = "If you are signed into iCloud on your device and haven’t turned it off for Contact Cards, your cards created with the app should sync with iCloud.  If you do not want this, you should turn iCloud off for Contact Cards "
#if os(macOS)
		iCloudString+="in the System Preferences app under Apple ID>iCloud>iCloud Drive Options>Contact Cards.  If you already have cards created, you can delete them from iCloud "
#else
		iCloudString+="in the Settings app under Apple ID>iCloud>Contact Cards.  If you already have cards created, you can delete them from iCloud "
#endif
		iCloudString+="by using the back button and following the steps described on the manage cards interface.  Once devices sync, the cards will be lost unless you first export them to an archive that can be loaded into Contact Cards at a later time."
		return iCloudString
	}
}

struct iCloudDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        iCloudDescriptionView()
    }
}
