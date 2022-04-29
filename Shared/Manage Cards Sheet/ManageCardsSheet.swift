//
//  ManageCardsSheet.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/9/22.
//

import SwiftUI
import UniformTypeIdentifiers
struct ManageCardsSheet: View {
	// MARK: Strings
	private let deleteMessage = "If you want to delete all cards from iCloud, it is recommended that you export your contact cards as an archive first so that you can restore the cards from the archive if you want.  Otherwise, when devices sync, the cards will be lost."
	private let aboutiCloudString = "About Contact Cards Use of iCloud..."
	private let exportToArchiveString = "Export Cards to Archive"
	private let loadCardsString = "Load Cards from Archive"
	private let exportToRTFDString = "Export iCloud Data as Rich Text File with Attachments"
	private let viewDataDescriptionString = "View iCloud Data Description"
	private let restrictOrUnRestrictString = "Restrict or Un-Restrict Access to iCloud"
	private let deleteString = "Delete All Cards from iCloud..."
	// MARK: View Model
	@StateObject var viewModel: ManageCardsViewModel
	init(isVisible: Binding<Bool>) {
		self._viewModel=StateObject(wrappedValue: ManageCardsViewModel(isVisible: isVisible))
	}
	var body: some View {
// MARK: Mac
#if os(macOS)
		VStack {
		// MARK: Main Navigation
		if (showingDetail()==false) {
			VStack {
				HStack {
					Spacer()
					Text(getTitle()).font(.system(.title2)).padding(.top)
					Spacer()
				}
				ScrollView {
					VStack(alignment: .center, spacing: 20) {
						// MARK: About iCloud Button
						Button(aboutiCloudString) {
							if isNotModal() {
								withAnimation {
									viewModel.showingAboutiCloud=true
								}
							}
						}
						// MARK: Export Archive Button
						Button(exportToArchiveString) {
							if isNotModal() {
								viewModel.exportArchive()
							}
						}
						// MARK: Load Archive Button
						Button(loadCardsString) {
							if isNotModal() {
								viewModel.showingArchiveImporter=true
							}
						}
						// MARK: Export RTFD Button
						Button(exportToRTFDString) {
							if isNotModal() {
								viewModel.exportRTFD()
							}
						}
						// MARK: View Data Button
						Button(viewDataDescriptionString) {
							
						}
						// MARK: Restriction Button
						Button(restrictOrUnRestrictString) {
							
						}
						// MARK: Delete Message
						Text(deleteMessage).foregroundColor(Color.red)
						Button(deleteString) {
							
						}
					}.padding(.horizontal).padding(.top)
				}
			}.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
		// MARK: About iCloud
		} else if (viewModel.showingAboutiCloud) {
				VStack {
					HStack {
						if (showingDetail()) {
							Button {
								back()
							} label: {
								Image(systemName: "chevron.backward")
							}.padding(.horizontal)
						}
						Spacer()
						Text(getTitle()).font(.system(.title2))
						Spacer()
						if (showingDetail()) {
							Button {
							} label: {
								Image(systemName: "chevron.backward")
							}.padding(.horizontal).hidden()
						}
					}.padding(.top)
					iCloudDescriptionView()
				}.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
		}
		Spacer()
		HStack {
			Spacer()
			// MARK: Done Button
			Button {
				//handle done
				viewModel.isVisible=false
			} label: {
				Text("Done")
			}.keyboardShortcut(.defaultAction)
		}.padding()
		}.frame(width: 475, height: 475, alignment: .top)
		// MARK: File Exporter
			.fileExporter(isPresented: $viewModel.showingMacFileExporter, document: viewModel.cardsDocument, contentType: viewModel.documentType, defaultFilename: "Contact Cards") { result in
				
				
	// MARK: Archive Importer
	}.fileImporter(isPresented: $viewModel.showingArchiveImporter, allowedContentTypes: [.json, .text]) { result in
		
	}
// MARK: iOS
#else
	NavigationView {
		ScrollView {
			// MARK: Main Navigation
			ZStack {
				
				
				// MARK: Archive Share Sheeet
				if viewModel.showingArchiveExporter {
					SaveSheetView(fileURL: viewModel.jsonArchiveUrl, isVisible: $viewModel.showingArchiveExporter)
				}
				
				// MARK: RTFD Share Sheeet
				if viewModel.showingRTFDExporter {
					SaveSheetView(fileURL: viewModel.rtfdFileURL, isVisible: $viewModel.showingRTFDExporter)
				}
			VStack(alignment: .center, spacing: 15) {
				// MARK: ABout iCloud Button
				NavigationLink(aboutiCloudString, destination: iCloudDescriptionView())
				
				
				// MARK: Export Archive Button
				Button(exportToArchiveString) {
					if isNotModal() {
						viewModel.exportArchive()
					}
				}
				// MARK: Load Archive Button
				Button(loadCardsString) {
					if isNotModal() {
						viewModel.showingArchiveImporter=true
					}
				}
				// MARK: Export RTFD Button
				Button(exportToRTFDString) {
					if isNotModal() {
						viewModel.exportRTFD()
					}
				}
				// MARK: Data Description Button
				NavigationLink(viewDataDescriptionString, destination: EmptyView())
				
				
				// MARK: Restriction Button
				NavigationLink(restrictOrUnRestrictString, destination: EmptyView())
				
				
				// MARK: Delete Message
				Text(deleteMessage).foregroundColor(Color.red)
				
				
				// MARK: Delete Button
				NavigationLink(deleteString, destination: EmptyView())
			}.padding()
		}
		}.navigationBarTitle("Manage Cards").navigationBarTitleDisplayMode(.inline).toolbar {
			ToolbarItem {
				// MARK: Done Button
				Button {
					viewModel.isVisible=false
				} label: {
					Text("Done")
				}.keyboardShortcut(.defaultAction)
			}
		// MARK: Archive Importer
		}.fileImporter(isPresented: $viewModel.showingArchiveImporter, allowedContentTypes: [.json, .text]) { result in
			
		}
	}
#endif
}
// MARK: Navigation Related
func showingDetail() -> Bool {
	return viewModel.showingAboutiCloud
}
func isNotModal() -> Bool {
	return !(showingDetail() || viewModel.showingArchiveExporter || viewModel.showingRTFDExporter || viewModel.showingMacFileExporter)
}
	
func makeNotModal() {
	viewModel.showingArchiveExporter=false
	viewModel.showingRTFDExporter=false
	viewModel.showingMacFileExporter=false
}
func back() {
	withAnimation {
		viewModel.showingAboutiCloud=false
	}
}
// MARK: Get Title
func getTitle() -> String {
	if showingDetail()==false {
		return "Manage Cards"
	} else if viewModel.showingAboutiCloud {
		return "Cards and iCloud"
	} else {
		return "Manage Cards"
	}
}
}

struct ManageCardsSheet_Previews: PreviewProvider {
	static var previews: some View {
		ManageCardsSheet(isVisible: .constant(true))
	}
}
