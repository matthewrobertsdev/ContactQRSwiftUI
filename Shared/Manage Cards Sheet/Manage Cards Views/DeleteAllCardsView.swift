//
//  DeleteAllCardsView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/26/22.
//

import SwiftUI

struct DeleteAllCardsView: View {
	let deleteWarning = """
	Once you delete cards from iCloud, you will not be able to get \
	them back.  Confirm deleting by typing the word \"delete\" below \
	and then delete the cards by using the \"Delete All Cards From \
	iCloud\" button.  Please note that if your iCloud account is \
	restricted, the cards will not be deleted from iCloud until \
	you un-restrict access to iCloud and the app has time to sync \
	with iCloud.
	"""
	@StateObject var viewModel: DeleteAllCardsViewModel
	init(deleteAllCardsViewModel: DeleteAllCardsViewModel) {
		_viewModel=StateObject(wrappedValue: deleteAllCardsViewModel)
	}
    var body: some View {
#if os(macOS)
		deleteAllCardsView().padding(.horizontal)
#else
		deleteAllCardsView()
			.navigationBarTitle("Delete All Cards")
#endif
    }
	func deleteAllCardsView() -> some View{
		ScrollView {
			VStack(alignment: .center, spacing: 20, content: {
				Text(deleteWarning).foregroundColor(.red)
				TextField("", text: $viewModel.deleteTextFieldText).frame(width: 200).foregroundColor(.red).multilineTextAlignment(.center).textFieldStyle(.roundedBorder)
				Button("Delete All Cards From iCloud") {
					viewModel.tryToDeleteAllCards()
				}
			}).padding()
		}
	}
}

/*
struct DeleteAllCardsView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAllCardsView()
    }
}
*/
