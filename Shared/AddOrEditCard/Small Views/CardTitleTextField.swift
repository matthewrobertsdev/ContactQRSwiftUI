//
//  CardTitleTextField.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/16/21.
//

import SwiftUI

struct CardTitleTextField: View {
	@Binding var text: String
    var body: some View {
		TextField("", text: $text).multilineTextAlignment(.center).frame(height: 40)
			.textFieldStyle(PlainTextFieldStyle()).padding(.horizontal, 12).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("Border", bundle: nil))).font(.system(size: 25))
    }
}

struct CardTitleTextField_Previews: PreviewProvider {
	@State static var text="Sample Card Title"
    static var previews: some View {
		CardTitleTextField(text: $text)
    }
}
