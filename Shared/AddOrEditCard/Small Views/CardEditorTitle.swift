//
//  CardEditorTitle.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//
import SwiftUI
struct CardEditorTitle: View {
	//the text
	var text: String=""
	// MARK: CardEditorTitle
    var body: some View {
		Text(text).font(.system(.title)).padding()
    }
}
// MARK: Previews
struct CardEditorTitle_Previews: PreviewProvider {
    static var previews: some View {
        CardEditorTitle()
    }
}
