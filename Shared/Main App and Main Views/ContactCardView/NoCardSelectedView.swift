//
//  NoCardSelectedView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 2/24/22.
//

import SwiftUI

struct NoCardSelectedView: View {
    var body: some View {
		//if no card is selected, central view is just this text
		Text("No Contact Card Selected").font(.system(size: 18))
    }
}

struct NoCardSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        NoCardSelectedView()
    }
}
