//
//  iCloudDescriptionView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/10/22.
//

import SwiftUI

struct AboutiCloudView: View {
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
		var iCloudString = "If you are signed into iCloud on your device and haven’t turned it off for Contact Cards, your cards created with the app should sync with iCloud.  If you do not want this, you should turn iCloud off for Contact Cards in the "
#if os(macOS)
		iCloudString+="System Preferences app under Apple ID>iCloud>iCloud Drive Options>Contact Cards."
#else
		iCloudString+="Settings app under Apple ID>iCloud>Contact Cards."
#endif
		iCloudString+="  If you already have cards created and you have iCloud on for Contact Cards, you can delete them from iCloud by using the back button and following the steps described on the manage cards interface.  Once devices sync, the cards will be lost unless you first export them to an archive from the manage cards interface so that it can be loaded into Contact Cards at a later time."
		return iCloudString
	}
}

struct iCloudDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AboutiCloudView()
    }
}
