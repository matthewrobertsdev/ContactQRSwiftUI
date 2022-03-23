//
//  ShowSiriSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/22/22.
//

import SwiftUI
import UIKit

struct ShowSiriSheet: View {
	@Binding var isVisible: Bool
    var body: some View {
		NavigationView(content: {
			ScrollView {
				VStack {
					NavigationLink("Choose Card") {
						Text("Choose Card Here").navigationTitle("Card for Siri")
					}
				}
			}.toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
				 Button(action: dismiss) {
					 Text("Done")
				 }
			 }
		 }.navigationTitle("Set-up for Siri")
		})
    }
	
	func dismiss() {
		isVisible=false
	}
}

class ShowSiriUIHostingController: UIHostingController<ShowSiriSheet> {
	
}

final class ShowSiriUIViewControllerRepresentable: UIViewControllerRepresentable {
	
	@Binding var isVisible: Bool
	
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
	
	func makeUIViewController(context: Context) -> ShowSiriUIHostingController {
		let controller=ShowSiriUIHostingController(rootView: ShowSiriSheet(isVisible: $isVisible))
		return controller
	}
	
	func updateUIViewController(_ uiViewController:  ShowSiriUIHostingController, context: Context) {
	}
}

/*
struct ShowSiriSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShowSiriSheet()
    }
}
*/
