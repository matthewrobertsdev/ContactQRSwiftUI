//
//  ColorSelectionViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/29/21.
//

import Foundation
import SwiftUI
class ColorSelectionViewModel: ObservableObject {
	// MARK: Selectable Color Models
	@Published var selectableColorModels=[SelectableColorModel(string: "Contrasting Color"), SelectableColorModel(string: "Gray"), SelectableColorModel(string: "Red"), SelectableColorModel(string: "Orange"), SelectableColorModel(string: "Yellow"), SelectableColorModel(string: "Green"), SelectableColorModel(string: "Blue"), SelectableColorModel(string: "Purple"), SelectableColorModel(string: "Pink"),
					  SelectableColorModel(string: "Brown")]
	// MARK: Deslect All
	public func deselectAllColors() {
		selectableColorModels.indices.forEach {
			selectableColorModels[$0].selected = false
		}

	}
}
