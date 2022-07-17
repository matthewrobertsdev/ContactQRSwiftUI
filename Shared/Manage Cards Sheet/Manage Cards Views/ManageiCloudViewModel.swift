//
//  ManageiCloudViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/29/22.
//
import SwiftUI
import CloudKit
import CoreData
class ManageiCloudViewModel: ObservableObject {
	@Published var restrictTextFieldText = ""
	@Published var unRestrictTextFieldText = ""
	@Binding var showingAlert: Bool
	@Binding var alertType: ManageCardsAlertType?
	init(showingAlert: Binding<Bool>, alertType: Binding<ManageCardsAlertType?>) {
		_showingAlert=showingAlert
		_alertType=alertType
	}
	func tryToRestrictiCloud() {
		if restrictTextFieldText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()=="restrict" {
			restrictOrUnRestrictiCloud(restrict: true)
		} else {
			alertType = .restrictNotConfirmed
			showingAlert=true
		}
	}
	func tryToUnRestrictiCloud() {
		if unRestrictTextFieldText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()=="un-restrict" {
			restrictOrUnRestrictiCloud(restrict: false)
		} else {
			alertType = .unRestrictNotConfirmed
			showingAlert=true
		}
	}
	func restrictOrUnRestrictiCloud(restrict: Bool) {
		let container=CKContainer(identifier: "iCloud.com.apps.celeritas.ContactCards")
		let apiToken="5065dbfcc540600ae42664510115173f5d7a048169cf55f27d948246adba737a"
			let fetchAuthorization = CKFetchWebAuthTokenOperation(apiToken: apiToken)
			fetchAuthorization.fetchWebAuthTokenCompletionBlock = { [weak self] webToken, error in
				guard let strongSelf = self else {
					return
				}
				guard let webToken = webToken, error == nil else {
					print("No web token")
					return
				}
				strongSelf.restrict(container: container, apiToken: apiToken, webToken: webToken, restrict: restrict) { error in
					if let error=error {
						print("Operation failed. Reason: ", error)
						DispatchQueue.main.async {
							//strongSelf.stopAndHideActivityIndicator()
							if restrict {
								strongSelf.alertType = .failedToRestrict
							} else {
								strongSelf.alertType = .failedToUnRestrict
							}
							strongSelf.showingAlert=true
						}
					} else {
						//strongSelf.stopAndHideActivityIndicator()
						if restrict {
							strongSelf.alertType = .restrictionSucceded
						} else {
							strongSelf.alertType = .unRestrictionSucceded
						}
						strongSelf.showingAlert=true
					}
				}
			}
			container.privateCloudDatabase.add(fetchAuthorization)
	}
	func restrictOrUnrestrict(url: URL, completionHandler: @escaping (Error?) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completionHandler(error)
				return
			}
			guard let httpResponse = response as? HTTPURLResponse,
				(200...299).contains(httpResponse.statusCode) else {
					completionHandler(RestrictError.failure)
					return
			}
			print("Restrict result", httpResponse)
			if data != nil {
				completionHandler(nil)
			} else {
				completionHandler(RestrictError.failure)
			}
		}
		task.resume()
	}
	// A utility function that percent encodes a token for URL requests.
	func encodeToken(_ token: String) -> String {
		return token.addingPercentEncoding(
			withAllowedCharacters: CharacterSet(charactersIn: "+/=").inverted
		) ?? token
	}
	enum RestrictError: Error {
		case failure
	}
	func restrict(container: CKContainer, apiToken: String, webToken: String, restrict: Bool, completionHandler: @escaping (Error?) -> Void) {
		let webToken = encodeToken(webToken)
		let identifier = container.containerIdentifier!
		let env = "development" // Use "development" during development.
		let baseURL = "https://api.apple-cloudkit.com/database/1/"
		var apiPath = "\(identifier)/\(env)/private/users/restrict"
		if restrict==false {
			apiPath = "\(identifier)/\(env)/private/users/unrestrict"
		}
		let query = "?ckAPIToken=\(apiToken)&ckWebAuthToken=\(webToken)"
		let url = URL(string: "\(baseURL)\(apiPath)\(query)")!
		restrictOrUnrestrict(url: url, completionHandler: completionHandler)
	}
}
