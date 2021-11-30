//
//  ColorSelectionCircleView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/29/21.
//

import SwiftUI

struct ColorSelectionCircle: View {
	private var color: Color
	private let outerCircleDiameter=CGFloat(20)
	private let innerCircleDimater=CGFloat(9.3)
	init(color: Color, selected: Binding<Bool>) {
		self.color=color
		self._selected=selected
	}
	@Binding var selected: Bool
	@ViewBuilder
    var body: some View {
		ZStack(alignment: .center) {
			// MARK: Selectable Color Cicle
			Circle().strokeBorder(.gray, lineWidth: 0.7).background(Circle().fill(color)).frame(width: outerCircleDiameter, height: outerCircleDiameter, alignment: .leading)
			if selected {
				Circle().strokeBorder(Color("Matching Color", bundle: nil), lineWidth: 0.7).background(Circle().fill(Color("Matching Color", bundle: nil))).frame(width: innerCircleDimater, height: innerCircleDimater, alignment: .center)
			}
		}
	}
}

struct ColorSelectionCircleView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ColorSelectionCircle(color: Color.red, selected: .constant(true))
			ColorSelectionCircle(color: Color.red, selected: .constant(false))
		}
    }
}
