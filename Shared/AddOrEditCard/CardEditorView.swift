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
			// MARK: Card Title
				Section(header: Text("Card Title")) {
				TextField(getTitleTextFieldLabel(), text:  $viewModel.cardTitle).font(.system(size: 25)).foregroundColor(Color("Dark \(viewModel.cardColor)", bundle: nil))
#if os(macOS)
				.frame(maxWidth: 350)
#endif
			}
				Section(header: Text("Card Color")) {
					ColorSelectionRow(viewModel: viewModel)
#if os(iOS)
						.padding(.top, 5)
#else
						.padding(.bottom)
#endif
			}
			Group {
				// MARK: Name
				NameEditorView(viewModel: viewModel)
				Group {
					// MARK: Job
					CardEditorTitle(text: "Job")
					VStack(alignment: .leading) {
						Text("Company")
						RoundedBorderTextField(text: $viewModel.company)
						Text("Job Title")
						RoundedBorderTextField(text: $viewModel.jobTitle)
						Text("Department")
						RoundedBorderTextField(text: $viewModel.department)
					}
				}
				Group {
					// MARK: Phone
					CardEditorTitle(text: "Phone Numbers")
					VStack(alignment: .leading) {
						Text("Mobile phone:")
						RoundedBorderTextField(text: $viewModel.mobilePhone)
						Text("Work phone #1:")
						RoundedBorderTextField(text: $viewModel.workPhone1)
						Text("Work phone #2:")
						RoundedBorderTextField(text: $viewModel.workPhone2)
						Text("Home phone:")
						RoundedBorderTextField(text: $viewModel.homePhone)
						Text("Phone (other):")
						RoundedBorderTextField(text: $viewModel.otherPhone)
					}
				}
				Group {
					// MARK: Email
					CardEditorTitle(text: "Email Addresses")
					VStack(alignment: .leading) {
						Text("Home email:")
						RoundedBorderTextField(text: $viewModel.homeEmail)
						Text("Work email #1:")
						RoundedBorderTextField(text: $viewModel.workEmail1)
						Text("Work email #2:")
						RoundedBorderTextField(text: $viewModel.workEmail2)
						Text("Email (other):")
						RoundedBorderTextField(text: $viewModel.otherEmail)
					}
				}
				Group {
					// MARK: Social Profiles
					CardEditorTitle(text: "Social Profiles")
					VStack(alignment: .leading) {
						Group {
							Text("Twitter username:")
							RoundedBorderTextField(text: $viewModel.twitterUsername)
							Text("Facebook URL:")
							RoundedBorderTextField(text: $viewModel.facebookUrl)
							Text("LinkedIn URL:")
							RoundedBorderTextField(text: $viewModel.linkedInUrl)
						}
						Group {
							Text("WhatsApp number")
							RoundedBorderTextField(text: $viewModel.whatsAppNumber)
							Text("Instagram username")
							RoundedBorderTextField(text: $viewModel.instagramUsername)
							Text("Snapchat username")
							RoundedBorderTextField(text: $viewModel.snapchatUsername)
							Text("Pinterest username")
							RoundedBorderTextField(text: $viewModel.pinterestUsername)
						}
					}
					Group {
						// MARK: Websites
						CardEditorTitle(text: "Websites")
						VStack(alignment: .leading) {
							Text("URL (home):")
							RoundedBorderTextField(text: $viewModel.homeUrl)
							Text("Work URL #1:")
							RoundedBorderTextField(text: $viewModel.workUrl1)
							Text("Work URL #2:")
							RoundedBorderTextField(text: $viewModel.workUrl2)
							Text("URL (other) #1:")
							RoundedBorderTextField(text: $viewModel.otherUrl1)
							Text("URL (other) #2:")
							RoundedBorderTextField(text: $viewModel.otherUrl2)
						}
					}
					Group {
						// MARK: Home
						CardEditorTitle(text: "Home Address")
						VStack(alignment: .leading) {
							Group {
								Text("Street address (home):")
								RoundedBorderTextField(text: $viewModel.homeStreetAddress)
								Text("City (home):")
								RoundedBorderTextField(text: $viewModel.homeCity)
								Text("State (home):")
								RoundedBorderTextField(text: $viewModel.homeState)
								Text("Zip (home)")
								RoundedBorderTextField(text: $viewModel.homeZip)
							}
						}
						// MARK: Work
						CardEditorTitle(text: "Work Address")
						VStack(alignment: .leading) {
							Group {
								Text("Street address (work):")
								RoundedBorderTextField(text: $viewModel.workStreetAddress)
								Text("City (work):")
								RoundedBorderTextField(text: $viewModel.workCity)
								Text("State (work):")
								RoundedBorderTextField(text: $viewModel.workState
								)
								Text("Zip (work)")
								RoundedBorderTextField(text: $viewModel.workZip)
							}
						}
						// MARK: Other
						CardEditorTitle(text: "Other Address")
						VStack(alignment: .leading) {
							Group {
								Text("Street address (other):")
								RoundedBorderTextField(text: $viewModel.otherStreetAddress)
								Text("City (other):")
								RoundedBorderTextField(text: $viewModel.otherCity)
								Text("State (other):")
								RoundedBorderTextField(text: $viewModel.otherState)
								Text("Zip (other):")
								RoundedBorderTextField(text: $viewModel.otherZip)
						}
					}
				}
			}
			}
		}
#if os(macOS)
		.padding()
#endif
		.onAppear {
#if os(iOS)
			UIScrollView.appearance().keyboardDismissMode = .onDrag
#endif
		}
	}
	
	func getTitleTextFieldLabel() -> String {
#if os(iOS)
		return "Card Title"
#else
		return ""
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

