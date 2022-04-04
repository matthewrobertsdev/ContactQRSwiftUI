//
//  AboutSheet.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 11/27/21.
//

import SwiftUI
// MARK: About Sheet
struct AboutSheet: View {
	@Environment(\.verticalSizeClass) var verticalSizeClass
	@Binding var showingAboutSheet: Bool
	private let viewModel=AboutViewModel()
	private let imageDimension=CGFloat(100)
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .center, spacing: 15) {
					// MARK: General Info
					Image("Icon", bundle: nil).resizable().frame(width: imageDimension, height: imageDimension, alignment: .center).aspectRatio(contentMode: .fit)
					Text("Contact Cards").font(.system(.title))
					Text(viewModel.versionAndBuildString)
					Text(viewModel.humanReadbleCopyright).multilineTextAlignment(.center)
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
					if let priacyPolicyUrl=URL(string: AppLinks.privacyPolicyString) {
						Link("Privacy Policy", destination: priacyPolicyUrl)
					}
				}.padding(.leading).padding(.trailing).padding(.bottom).navigationBarTitle("About").navigationBarTitleDisplayMode(.inline).toolbar {
					ToolbarItem {
						// MARK: Done
						Button {
							//handle done
							showingAboutSheet.toggle()
						} label: {
							Text("Done")
						}.keyboardShortcut(.defaultAction)
					}
				}.frame(maxWidth: .infinity)
			}
		}
	}
}
struct AboutSheet_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AboutSheet(showingAboutSheet: .constant(true))
		}
	}
}
