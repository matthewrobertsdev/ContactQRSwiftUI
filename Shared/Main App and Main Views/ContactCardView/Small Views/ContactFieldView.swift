//
//  ContactFieldView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//
import SwiftUI
struct ContactFieldView: View {
	@State var model: FieldInfoModel
	let fontSize=CGFloat(20)
	@ViewBuilder
	var body: some View {
#if os(macOS)
		// MARK: Text
		VStack(alignment: .center, spacing: 5) {
			Text(model.text).font(.system(size: fontSize))
			if let url=URL(string: model.hyperlink), model.hasLink {
				// MARK: Link
				Link(model.linkText, destination: url).font(.system(size: fontSize))
			}
		}
#else
		// MARK: Text
		Group {
			HStack {
				Spacer()
				Text(model.text).font(.system(size: fontSize))
				Spacer()
			}
			if let url=URL(string: model.hyperlink), model.hasLink {
				// MARK: Link
				HStack {
					Spacer()
					Link(model.linkText, destination: url).font(.system(size: fontSize))
					Spacer()
				}
			}
		}
#endif
	}
}

struct ContactFieldView_Previews: PreviewProvider {
	static var previews: some View {
		ContactFieldView(model: FieldInfoModel(hasLink: false, text: "First Name: Juan", linkText: "", hyperlink: ""))
	}
}
