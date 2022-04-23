//
//  IdenitiableString.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/29/21.
//

import Foundation
import SwiftUI
// MARK: Selectable Color
struct SelectableColorModel: Identifiable {
	var string: String
	let id=UUID()
	var selected=false
}
