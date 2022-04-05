//
//  CardEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//
import SwiftUI
struct CardEditorView: View {
	@StateObject var viewModel: CardEditorViewModel
	//horizontal padding for views in scroll view
	let horizontalPadding=CGFloat(3)
	//body
	var body: some View {
		Form {
			// MARK: Title and Color
			Group {
				CardTitleEditorView(viewModel: viewModel)
				CardColorEditorView(viewModel: viewModel)
			}
			
			// MARK: Name & Company
			Group {
				NameEditorView(viewModel: viewModel)
				CompanyEditorView(viewModel: viewModel)
			}
			
			// MARK: Email & Phone
			Group {
				PhonesEditorView(viewModel: viewModel)
				EmailsEditorView(viewModel: viewModel)
			}
			
			// MARK: Social & Websites
			Group {
				SocialProfilesEditorView(viewModel: viewModel)
				WebsitesEditorView(viewModel: viewModel)
			}
			
			// MARK: Addresses
			Group {
				HomeAddressEditorView(viewModel: viewModel)
				WorkAddressEditorView(viewModel: viewModel)
				OtherAdressEditorView(viewModel: viewModel)
			}
		}
#if os(iOS)
		.onAppear {
			UIScrollView.appearance().keyboardDismissMode = .onDrag
		}
#endif
	}
}



// MARK: Previews
struct CardEditorView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			CardEditorView(viewModel: CardEditorViewModel(viewContext: PersistenceController.shared.container.viewContext, forEditing: false, card: nil, showingEmptyTitleAlert: .constant(false), selectedCard: .constant(nil)))
			CardEditorView(viewModel: CardEditorViewModel(viewContext: PersistenceController.shared.container.viewContext, forEditing: false, card: nil, showingEmptyTitleAlert: .constant(true), selectedCard: .constant(nil)))
		}
	}
}

