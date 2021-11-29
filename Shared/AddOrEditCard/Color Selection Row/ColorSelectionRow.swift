//
//  ColorSelectionRow.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/29/21.
//

import SwiftUI

struct ColorSelectionRow: View {
	@StateObject var viewModel: ColorSelectionViewModel
    var body: some View {
		HStack {
			ForEach($viewModel.selectableColorModels) { $model in
				ColorSelectionCircle(color: Color("Dark \(model.string)", bundle: nil), selected: $model.selected).onTapGesture {
					viewModel.deselectAllColors()
					model.selected.toggle()
				}
			}
		}
    }
}

struct ColorSelectionRow_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectionRow(viewModel: ColorSelectionViewModel())
    }
}
