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
		VStack(alignment: .center, spacing: 5) {
			Text(model.text).font(.system(size: fontSize))
			if let url=URL(string: model.hyperlink), model.hasLink {
				Link(model.hyperlink, destination: url).font(.system(size: fontSize))
			}
		}
	}
}

struct ContactFieldView_Previews: PreviewProvider {
	static var previews: some View {
		ContactFieldView(model: FieldInfoModel(hasLink: false, text: "First Name: Juan", hyperlink: ""))
	}
}
