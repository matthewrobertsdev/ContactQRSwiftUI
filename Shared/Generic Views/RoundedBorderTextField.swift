//
//  RoundedBorderTextField.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/12/21.
//
import SwiftUI
struct RoundedBorderTextField: View {
	@Binding var text: String
	// MARK: RoundedBorderTextField
    var body: some View {
		TextField("", text: $text).textFieldStyle(.roundedBorder)
    }
}
struct RoundedBorderTextField_Previews: PreviewProvider {
	@State static var text="Text typed in here"
    static var previews: some View {
		RoundedBorderTextField(text: $text)
    }
}
