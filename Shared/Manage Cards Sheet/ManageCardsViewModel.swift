//
//  ManageCardsViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/20/22.
//
import Foundation
import SwiftUI
class ManageCardsViewModel: ObservableObject {
	
	@Published var showingAboutiCloud=false
	@Published var showingArchiveExporter=false
	@Published var showingRTFDExporter=false
	@Published var showingMacFileExporter=false
	@Published var showingArchiveImporter=false
	@Binding var isVisible: Bool
	init(isVisible: Binding<Bool>) {
		self._isVisible=isVisible
	}
}
