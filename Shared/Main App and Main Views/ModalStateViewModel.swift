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
	@Binding var showingShareSheet: Bool
	@Binding var showingSiriSheet: Bool
	@Binding var showingManageCardsSheet: Bool
	
	init(showingAddCardSheet: Binding<Bool>, showingAddCardSheetForDetail: Binding<Bool>,
		 showingEditCardSheet: Binding<Bool>, showingDeleteAlert: Binding<Bool>, showingExportPanel: Binding<Bool>, showingQrCodeSheet: Binding<Bool>, showingShareSheet: Binding<Bool>, showingSiriSheet: Binding<Bool>,showingManageCardsSheet: Binding<Bool>) {
		self._showingAddCardSheet=showingAddCardSheet
		self._showingAddCardSheetForDetail=showingAddCardSheetForDetail
		self._showingEditCardSheet=showingEditCardSheet
		self._showingDeleteAlert=showingDeleteAlert
		self._showingExportPanel=showingExportPanel
		self._showingQrCodeSheet=showingQrCodeSheet
		self._showingShareSheet=showingShareSheet
		self._showingSiriSheet=showingSiriSheet
		self._showingManageCardsSheet=showingManageCardsSheet
	}
}
