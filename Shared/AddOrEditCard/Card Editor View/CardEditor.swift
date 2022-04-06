//
//  CardEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/21.
//
import SwiftUI
struct CardEditor: View {
	@StateObject var viewModel: CardEditorViewModel
	var body: some View {
		Form {
			// MARK: Title & Color
			Group {
				CardTitleEditor(viewModel: viewModel)
				CardColorEditor(viewModel: viewModel)
			}
			
			// MARK: Name & Company
			Group {
				NameEditor(viewModel: viewModel)
				JobEditor(viewModel: viewModel)
			}
			
			// MARK: Email & Phone
			Group {
				PhonesEditor(viewModel: viewModel)
				EmailsEditor(viewModel: viewModel)
			}
			
			// MARK: Social Profiles
			Group {
				SocialProfilesEditor(viewModel: viewModel)
			}
			
			// MARK: Websites
			Group {
				WebsitesEditor(viewModel: viewModel)
			}
			
			// MARK: Addresses
			Group {
				HomeAddressEditor(viewModel: viewModel)
				WorkAddressEditor(viewModel: viewModel)
				OtherAdressEditor(viewModel: viewModel)
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
			CardEditor(viewModel: CardEditorViewModel(viewContext: PersistenceController.shared.container.viewContext, forEditing: false, card: nil, showingEmptyTitleAlert: .constant(false), selectedCard: .constant(nil)))
		}
	}
}

