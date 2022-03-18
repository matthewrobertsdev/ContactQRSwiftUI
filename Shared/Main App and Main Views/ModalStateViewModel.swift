//
//  ModalStateViewModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/16/22.
//

import SwiftUI

class ModalStateViewModel: ObservableObject {
	@Binding var showingAddCardSheet: Bool
	@Binding var showingAddCardSheetForDetail: Bool
	@Binding var showingEditCardSheet: Bool
	@Binding var showingDeleteAlert: Bool
	@Binding var showingExportPanel: Bool
	@Binding var showingQrCodeSheet: Bool
	
	init(showingAddCardSheet: Binding<Bool>, showingAddCardSheetForDetail: Binding<Bool>,
		 showingEditCardSheet: Binding<Bool>, showingDeleteAlert: Binding<Bool>, showingExportPanel: Binding<Bool>, showingQrCodeSheet: Binding<Bool>) {
		self._showingAddCardSheet=showingAddCardSheet
		self._showingAddCardSheetForDetail=showingAddCardSheetForDetail
		self._showingEditCardSheet=showingEditCardSheet
		self._showingDeleteAlert=showingDeleteAlert
		self._showingExportPanel=showingExportPanel
		self._showingQrCodeSheet=showingQrCodeSheet
	}
}
