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
					navBar()
					ScrollView {
						VStack(alignment: .center, spacing: 20) {
							// MARK: About iCloud
							Button(aboutiCloudString) {
								if isOnMain() {
									withAnimation {
										viewModel.showingAboutiCloud=true
									}
								}
							}
							// MARK: Export Archive
							Button(exportToArchiveString) {
								if isOnMain() {
									viewModel.exportArchive()
								}
							}
							// MARK: Load Archive
							Button(loadCardsString) {
								if isOnMain() {
									viewModel.showingArchiveImporter=true
								}
							}
							// MARK: Export RTFD
							Button(exportToRTFDString) {
								if isOnMain() {
									viewModel.exportRTFD()
								}
							}
							// MARK: View Data
							Button(viewDataDescriptionString) {
								if isOnMain() {
									withAnimation {
										viewModel.showiCloudDataDescription()
									}
								}
							}
							// MARK: Restriction
							Button(restrictOrUnRestrictString) {
							}
							
							// MARK: Delete Cards
							Text(deleteMessage).foregroundColor(Color.red)
							Button(deleteString) {
							}
						}.padding(.horizontal).padding(.top)
					}
				}.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
				// MARK: About iCloud
			} else if (viewModel.showingAboutiCloud) {
				VStack {
					navBarDetail()
					AboutiCloudView()
				}.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
				// MARK: View Data
			} else if (viewModel.showingCardDataDescription) {
				VStack {
					navBarDetail()
					CloudDataView()
				}.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
			}
			Spacer()
			footer()
		}.frame(width: 475, height: 475, alignment: .top)
		// MARK: File Exporter
		.fileExporter(isPresented: $viewModel.showingMacFileExporter, document: viewModel.cardsDocument, contentType: viewModel.documentType, defaultFilename: "Contact Cards") { _ in
				
				
		// MARK: Archive Importer
		}.fileImporter(isPresented: $viewModel.showingArchiveImporter, allowedContentTypes: [.json, .plainText]) { result in
				viewModel.importArchive(result: result)
			
		// MARK: Failure Alert
		}.alert(isPresented: $viewModel.showingImportFailureAlert) {
			importFailureAlert()
		}
		// MARK: iOS
#else
		NavigationView {
			ScrollView {
				ZStack {
					// MARK: Archive
					if viewModel.showingArchiveExporter {
						SaveSheetView(fileURL: viewModel.jsonArchiveUrl, isVisible: $viewModel.showingArchiveExporter)
					}
					// MARK: RTFD
					if viewModel.showingRTFDExporter {
						SaveSheetView(fileURL: viewModel.rtfdFileURL, isVisible: $viewModel.showingRTFDExporter)
					}
					// MARK: Load Archive
					if viewModel.showingArchiveImporter {
						LoadSheetView(loadHandler: { url in
							viewModel.importArchive(url: url)
						}, isVisible: $viewModel.showingArchiveImporter)
					}
					VStack(alignment: .center, spacing: 15) {
						// MARK: About iCloud
						NavigationLink(aboutiCloudString, destination: AboutiCloudView())
						
						
						// MARK: Export Archive
						Button(exportToArchiveString) {
							if isOnMain() {
								viewModel.exportArchive()
							}
						}
						// MARK: Load Archive
						Button(loadCardsString) {
							if isOnMain() {
								viewModel.showingArchiveImporter=true
							}
						}
						// MARK: Export RTFD
						Button(exportToRTFDString) {
							if isOnMain() {
								viewModel.exportRTFD()
							}
						}
						// MARK: View Data
						NavigationLink(viewDataDescriptionString, destination: CloudDataView())
						
						
						// MARK: Restriction
						NavigationLink(restrictOrUnRestrictString, destination: EmptyView())
						
						
						// MARK: Delete Message
						Text(deleteMessage).foregroundColor(Color.red)
						
						
						// MARK: Delete Cards
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
				// MARK: Failure Alert
			}.alert(isPresented: $viewModel.showingImportFailureAlert) {
				importFailureAlert()
			}
		}
#endif
	}
	// MARK: Alerts
	func importSuccessAlert() -> Alert {
		return Alert(title: Text("Cards Archive Loaded"), message: Text("All contact cards were successfully loaded from archive."), dismissButton: .default(Text("Got it.")))
	}
	func importFailureAlert() -> Alert {
		return Alert(title: Text("Error Loading Cards Archive"), message: Text("The data from the file was not in the right format."), dismissButton: .default(Text("Got it.")))
	}
	// MARK: Mac Nav Bar
	func navBar() -> some View {
		HStack {
			Spacer()
			Text(getTitle()).font(.system(.title2)).padding(.top)
			Spacer()
		}
	}
	// MARK: Mac Nav Bar Detail
	func navBarDetail() -> some View {
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
	}
	// MARK: Mac Footer
	func footer() -> some View {
		HStack {
			Spacer()
			Button {
				//handle done
				viewModel.isVisible=false
			} label: {
				Text("Done")
			}.keyboardShortcut(.defaultAction)
		}.padding()
	}
	// MARK: Detect Nav State
	func showingDetail() -> Bool {
		return viewModel.showingAboutiCloud ||
		viewModel.showingCardDataDescription
	}
	func isOnMain() -> Bool {
		return !(showingDetail() || viewModel.showingArchiveExporter || viewModel.showingRTFDExporter || viewModel.showingMacFileExporter )
	}
	// MARK: Return to Main
	func makeNotModal() {
		viewModel.showingArchiveExporter=false
		viewModel.showingRTFDExporter=false
		viewModel.showingMacFileExporter=false
		viewModel.showingCardDataDescription=false
	}
	func back() {
		withAnimation {
			viewModel.showingAboutiCloud=false
			viewModel.showingCardDataDescription=false
		}
	}
	// MARK: Get Title
	func getTitle() -> String {
		if showingDetail()==false {
			return "Manage Cards"
		} else if viewModel.showingAboutiCloud {
			return "Cards and iCloud"
		} else if viewModel.showingCardDataDescription {
			return "Data in iCloud"
		} else {
			return "Manage Cards"
		}
	}
}

// MARK: Preview
struct ManageCardsSheet_Previews: PreviewProvider {
	static var previews: some View {
		ManageCardsSheet(isVisible: .constant(true))
	}
}
