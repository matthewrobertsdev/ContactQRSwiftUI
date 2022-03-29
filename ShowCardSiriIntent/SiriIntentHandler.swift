//
//  IntentHandler.swift
//  ShowCardSiriIntent
//
//  Created by Matt Roberts on 3/28/22.
//

import Intents

class SiriIntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return ShowCardIntentHandler()
    }
    
}
