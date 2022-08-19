//
//  NoCardSelectedView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 2/24/22.
//

import SwiftUI
struct NoCardSelectedView: View {
    var body: some View {
		//MARK: Not Selected Text
		Text("No Contact Card Selected").font(.system(.title2))
    }
}

struct NoCardSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        NoCardSelectedView()
    }
}
