//
//  ColorSelectionRow.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/29/21.
//

import SwiftUI

// MARK: Color Slection Row
struct ColorSelectionRow: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		HStack {
			ForEach($viewModel.selectableColorModels) { $model in
				ColorSelectionCircle(color: Color("Dark \(model.string)", bundle: nil), selected: $model.selected).onTapGesture {
					viewModel.deselectAllColors()
					model.selected.toggle()
					viewModel.cardColor=model.string
				}
			}
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
