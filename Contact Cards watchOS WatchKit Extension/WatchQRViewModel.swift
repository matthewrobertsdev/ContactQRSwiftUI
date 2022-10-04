//
//  WatchQRViewModel.swift
//  Contact Cards watchOS WatchKit Extension
//
//  Created by Matt Roberts on 10/3/22.
//
import Foundation
import SwiftUI
class WatchQRViewModel: ObservableObject {
	@Published var qrData = Data()
	@Published var color = ""
	@Binding var selectedCard: ContactCardMO?
	init(selectedCard: Binding<ContactCardMO?>) {
		_selectedCard = selectedCard
		qrData = selectedCard.wrappedValue?.qrCodeImage ?? Data()
		color = selectedCard.wrappedValue?.color ?? ""
	}
	
	func update(selectedCard: Binding<ContactCardMO?>) {
		_selectedCard = selectedCard
		qrData = selectedCard.wrappedValue?.qrCodeImage ?? Data()
		color = selectedCard.wrappedValue?.color ?? ""
	}
	
}
