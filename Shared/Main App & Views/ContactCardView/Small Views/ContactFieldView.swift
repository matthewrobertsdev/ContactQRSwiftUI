//
//  ContactFieldView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//
import SwiftUI
struct ContactFieldView: View {
	@Environment(\.openURL) var openURL
	@State var model: FieldInfoModel
#if os(watchOS)
	let fontSize = Font.TextStyle.body
#else
	let fontSize = Font.TextStyle.title2
#endif
	@ViewBuilder
	var body: some View {
		// MARK: Text
		if let url=URL(string: model.hyperlink), model.hasLink {
		VStack(alignment: .center, spacing: 5) {
			HStack {
				Spacer()
				Text(model.text).font(.system(fontSize))
				Spacer()
			}
			HStack {
				Spacer()
				Link(model.linkText, destination: url).font(.system(fontSize))
				Spacer()
			}
		}.accessibilityElement().accessibilityLabel(Text("\(model.text), \(model.linkText)")).accessibilityAction {
			openURL(url)
		}
			
		} else {
			HStack {
				Spacer()
				Text(model.text).font(.system(fontSize))
				Spacer()
			}
		}
	}
}

struct ContactFieldView_Previews: PreviewProvider {
	static var previews: some View {
		ContactFieldView(model: FieldInfoModel(hasLink: false, text: "First Name: Juan", linkText: "", hyperlink: ""))
	}
}
