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
	// MARK: Body
	var body: some View {
		ScrollView {
			Group {
				Group {
					// MARK: Name
					Group {
						CardEditorTitle(text: "Name")
						VStack(alignment: .leading) {
							Text("First name")
							RoundedBorderTextField(text: $viewModel.firstName)
							Text("Last name")
							RoundedBorderTextField(text: $viewModel.lastName)
						}
					}
					Group {
						//  MARK: Name Details
						VStack(alignment: .leading) {
							Text("Prefix")
							RoundedBorderTextField(text: $viewModel.prefix)
							Text("Suffix")
							RoundedBorderTextField(text: $viewModel.suffix)
							Text("Nickname")
							RoundedBorderTextField(text: $viewModel.nickname)
						}
					}
				}
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
			}.padding(.leading, horizontalPadding).padding(.trailing, horizontalPadding)
		}.padding(.bottom).padding(.top)
	}
}
// MARK: Previews
struct CardEditorView_Previews: PreviewProvider {
	static var previews: some View {
		CardEditorView(viewModel: CardEditorViewModel())
	}
}
