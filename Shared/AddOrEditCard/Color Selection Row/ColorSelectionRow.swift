//
//  ColorSelectionRow.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/29/21.
//

import SwiftUI

struct ColorSelectionRow: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		GeometryReader { geometry in
		ScrollView(.horizontal) {
			HStack(alignment: .center) {
			// MARK: Color Slection Row
			Spacer()
			ForEach($viewModel.selectableColorModels) { $model in
				ColorSelectionCircle(color: Color("Dark \(model.string)", bundle: nil), selected: $model.selected).accessibilityElement().accessibilityLabel(Text("\(model.string), \(model.selected ? "selected" : "unselected")")).accessibilityAction {
					viewModel.deselectAllColors()
					model.selected.toggle()
					viewModel.cardColor=model.string
					//MARK: Select on Tap
				}.onTapGesture {
					viewModel.deselectAllColors()
					model.selected.toggle()
					viewModel.cardColor=model.string
				}
			}
			Spacer()
		}.frame(minWidth: geometry.size.width, idealWidth: nil, maxWidth: .infinity, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
		}.frame(minWidth: geometry.size.width, idealWidth: nil, maxWidth: .infinity, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
		}
	}
}

/*
struct ColorSelectionRow_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ColorSelectionRow(viewModel: CardEditorViewModel(viewContext: PersistenceController.shared.container.viewContext, forEditing: false, card: ContactCardMO(), showingEmptyTitleAlert: .constant(false)))
			ColorSelectionRow(viewModel: CardEditorViewModel(viewContext: PersistenceController.shared.container.viewContext, forEditing: false, card: ContactCardMO(), showingEmptyTitleAlert: .constant(true)))
		}
    }
}
*/
