//
//  ManageiCloudView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/27/22.
//

import SwiftUI

struct ManageiCloudView: View {
	@State private var restrictTextFieldText = ""
	@State private var unrestrictTextFieldText = ""
	let restrictExplanation = """
	If you want to restrict access to iCloud, type "restrict" below \
	and then use the restrict button below.
	"""
	let unrestrictExplanation = """
	If you are trying to un-restrict access to iCloud, type \
	"un-restrict" below and then use the un-restrict button below.
	"""
	var body: some View {
#if os(macOS)
		manageiCloudView().padding(.horizontal)
#else
		manageiCloudView()
			.navigationBarTitle("Manage iCloud Access")
#endif
	}
	func manageiCloudView() -> some View{
		ScrollView {
			VStack(alignment: .center, spacing: 20, content: {
				Text(restrictExplanation).foregroundColor(.red)
				TextField("", text: $restrictTextFieldText).frame(width: 200).foregroundColor(.red).multilineTextAlignment(.center).textFieldStyle(.roundedBorder)
				Button("Restrict") {
					
				}
				Text(unrestrictExplanation).foregroundColor(.green)
				TextField("", text: $restrictTextFieldText).frame(width: 200).foregroundColor(.green).multilineTextAlignment(.center).textFieldStyle(.roundedBorder)
				Button("Un-Restrict") {
					
				}
			}).padding()
		}
	}
}

struct ManageiCloudView_Previews: PreviewProvider {
    static var previews: some View {
        ManageiCloudView()
    }
}
