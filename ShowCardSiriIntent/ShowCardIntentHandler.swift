//
//  ShowCardIntentHandler.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/28/22.
//

import Foundation
class ShowCardIntentHandler: NSObject, ShowCardIntentHandling {
	func handle(intent: ShowCardIntent, completion: @escaping (ShowCardIntentResponse) -> Void) {
		completion(ShowCardIntentResponse(code: .success, userActivity: nil))
	}
	func confirm(intent: ShowCardIntent, completion: @escaping (ShowCardIntentResponse) -> Void) {
		completion(ShowCardIntentResponse(code: .success, userActivity: nil))
	}
}
