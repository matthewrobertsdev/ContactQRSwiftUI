//
//  AddOrEditCardView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//

import SwiftUI

struct AddOrEditCardSheet: View {
	@Binding var showingAddOrEditCardSheet: Bool
    var body: some View {
#if os(macOS)
		Text("Add or Edit Card").navigationTitle(Text("Add or Edit Card"))
#elseif os(iOS)
		NavigationView {
			Text("Add or Edit Card").navigationTitle(Text("Add or Edit Card"))

				.navigationBarTitleDisplayMode(.inline).navigationBarItems(leading: Button {
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Cancel")
				}, trailing: Button {
					showingAddOrEditCardSheet.toggle()
				} label: {
					Text("Done")
				})
		}
#endif
	}
}

struct AddOrEditCardSheet_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			AddOrEditCardSheet(showingAddOrEditCardSheet: .constant(true))
			AddOrEditCardSheet(showingAddOrEditCardSheet: .constant(false))
				  }
    }
}
