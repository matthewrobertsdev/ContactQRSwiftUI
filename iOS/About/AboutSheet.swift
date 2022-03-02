//
//  AboutSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 11/27/21.
//

import SwiftUI
// MARK: About Sheet
struct AboutSheet: View {
	@Binding var showingAboutSheet: Bool
	private let viewModel=AboutViewModel()
	private let imageDimension=CGFloat(100)
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .center, spacing: 7.5) {
					// MARK: General Info
					Image("Icon", bundle: nil).resizable().frame(width: imageDimension, height: imageDimension, alignment: .center).aspectRatio(contentMode: .fit)
					Text(viewModel.humanReadbleCopyright)
					Text(viewModel.versionAndBuildString)
					// MARK: Links
					if let faqUrl=URL(string: AppLinks.faqString) {
						Link("Frequently Asked Questions", destination: faqUrl)
					}
					if let homepageUrl=URL(string: AppLinks.homepageString) {
						Link("Homepage", destination: homepageUrl)
					}
					if let contactUrl=URL(string: AppLinks.contactString) {
						Link("Contact the Developer", destination: contactUrl)
					}
					if let priacyPolicuUrl=URL(string: AppLinks.privacyPolicyString) {
						Link("Privacy Policy", destination: priacyPolicuUrl)
					}
				}.padding().navigationBarTitle("About Contact Cards").navigationBarTitleDisplayMode(.inline).toolbar {
					// MARK: Toolbar
					ToolbarItem {
						Button {
							//handle done
							showingAboutSheet.toggle()
						} label: {
							Text("Done")
						}.keyboardShortcut(.defaultAction)
					}
				}
			}
		}
	}
}
struct AboutSheet_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AboutSheet(showingAboutSheet: .constant(true))
			AboutSheet(showingAboutSheet: .constant(false))
		}
	}
}
