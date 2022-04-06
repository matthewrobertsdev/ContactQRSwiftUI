//
//  SocialProfilesEditorView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/4/22.
//

import SwiftUI

struct SocialProfilesEditor: View {
	@StateObject var viewModel: CardEditorViewModel
    var body: some View {
		Section(header: Text("Social Profiles")) {
			Group{
			TextField("Twitter", text: $viewModel.twitterUsername)
			TextField("Facebook URL", text: $viewModel.facebookUrl)
			TextField("LinkedIn URL", text: $viewModel.linkedInUrl)
			TextField("WhatsApp", text: $viewModel.whatsAppNumber)
			TextField("Instagram", text: $viewModel.instagramUsername)
			TextField("Snapchat", text: $viewModel.snapchatUsername)
			TextField("Pinterest", text: $viewModel.pinterestUsername)
			}
#if os(macOS)
			.padding(.horizontal)
#endif
		}
    }
}

/*
struct SocialProfilesEditorView_Previews: PreviewProvider {
    static var previews: some View {
        SocialProfilesEditorView()
    }
}
*/
