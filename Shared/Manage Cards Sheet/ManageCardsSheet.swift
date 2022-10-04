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
										viewModel.showingAboutiCloudView=true
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
								if isOnMain() {
									withAnimation {
										viewModel.showingManageiCloudView=true
									}
								}
							}
							// MARK: Delete Cards
							Text(deleteMessage).foregroundColor(Color.red)
							Button(deleteString) {
								if isOnMain() {
									withAnimation {
										viewModel.showingDeleteAllCardsView=true
									}
								}
							}
						}.padding(.horizontal).padding(.top)
					}
				}.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
				// MARK: About iCloud
			} else if (viewModel.showingAboutiCloudView) {
				VStack {
					navBarDetail()
					AboutiCloudView()
				}.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
				// MARK: View Data
			} else if (viewModel.showingCardDataDescription) {
				VStack(alignment: .center, spacing: 15, content: {
					navBarDetail()
					CloudDataView().overlay(Rectangle().stroke(Color("Border", bundle: nil), lineWidth: 2)).padding(.horizontal).padding(.bottom, 10)
				}).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
			} else if (viewModel.showingDeleteAllCardsView) {
				VStack {
					navBarDetail()
					deleteAllCardsView()
				}.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
			} else if (viewModel.showingManageiCloudView) {
				VStack {
					navBarDetail()
					manageiCloudView()
				}.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
			}
			footer()
		}.frame(width: 475, height: 475, alignment: .top)
		// MARK: File Exporter
		.fileExporter(isPresented: $viewModel.showingMacFileExporter, document: viewModel.cardsDocument, contentType: viewModel.documentType, defaultFilename: "Contact Cards") { _ in
				
				
		// MARK: Archive Importer
		}.fileImporter(isPresented: $viewModel.showingArchiveImporter, allowedContentTypes: [.json, .plainText]) { result in
				viewModel.importArchive(result: result)
			
		// MARK: Failure Alert
		}.alert(isPresented: $viewModel.showingAlert) {
			alert()
		}
		// MARK: iOS
#else
		if #available(iOS 16, *) {
			NavigationStack {
				iOSContents()
			}
		} else {
			NavigationView {
				iOSContents()
			}
		}
#endif
	}
	func deleteAllCardsView() -> some View {
		DeleteAllCardsView(deleteAllCardsViewModel: DeleteAllCardsViewModel(showingAlert: $viewModel.showingAlert, alertType: $viewModel.alertType))
	}
	func manageiCloudView() -> some View {
		ManageiCloudView(manageiCloudViewModel: ManageiCloudViewModel(showingAlert: $viewModel.showingAlert, alertType: $viewModel.alertType))
	}
	// MARK: Alerts
	func alert() -> Alert {
		switch viewModel.alertType {
		case .errorLoadingCardsArchive:
			return alert(title: "Error Loading Cards Archive", message: "Error loading cards from archive as the data was in the wrong format.")
		case .errorLoadingCards:
			return alert(title: "Error Loading Cards", message: "Error loading one or more cards from archive.")
		case .successfullyLoadedCards:
			return alert(title: "Successfully Loaded Cards", message: "Sucessfully loaded all cards from archive.")
		case .deleteNotConfirmed:
			return alert(title: "Not Confirmed", message: "You have not confirmed that you want to delete all cards by typing \"delete\".")
		case .cardsDeleted:
			return alert(title: "Cards Deleted", message: "All cards successully deleted.  Once app syncs with iCloud, they will be gone from iCloud too.")
		case .deletionError:
			return alert(title: "Error", message: "Failed to delete cards.")
		case .restrictNotConfirmed:
			return alert(title: "Not Confirmed", message: "You have not confirmed that you want to restrict access to iCloud for Contact Cards by typing \"restrict\".")
		case .unRestrictNotConfirmed:
			return alert(title: "Not Confirmed", message: "You have not confirmed that you want to un-restrict access to iCloud for Contact Cards by typing \"un-restrict\".")
		case .failedToRestrict:
			return alert(title: "Attempt to Restrict Failed", message: "Failed to restrict Contact Cards' access to iCloud.  Maybe you don't have internet, or have already restricted it?")
		case .failedToUnRestrict:
			return alert(title: "Attempt to Un-Restrict Failed", message: "Failed to un-restrict Contact Cards' access to iCloud.  Maybe you don't have internet, or it was aready un-restricted?")
		case .restrictionSucceded:
			return alert(title: "Restriction Succeeeded.", message: "Your iCloud access for Contact Cards is now restricted.  Use the un-restrict button to allow access again at any time.")
		case .unRestrictionSucceded:
			return alert(title: "iCloud Access Un-Restricted", message: "Please relaunch Contact Cards wherever it is running on your devices so that it will sync with iCloud again.")
		default:
			return alert(title: "", message: "")
		}
	}
	func alert(title: String, message: String) -> Alert {
		Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("Got it.")))
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
		}.padding(.horizontal).padding(.bottom)
	}
	// MARK: Detect Nav State
	func showingDetail() -> Bool {
		return viewModel.showingAboutiCloudView ||
		viewModel.showingCardDataDescription ||
		viewModel.showingDeleteAllCardsView ||
		viewModel.showingManageiCloudView
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
		viewModel.showingDeleteAllCardsView=false
		viewModel.showingManageiCloudView=false
	}
	func back() {
		withAnimation {
			viewModel.showingAboutiCloudView=false
			viewModel.showingCardDataDescription=false
			viewModel.showingDeleteAllCardsView=false
			viewModel.showingManageiCloudView=false
		}
	}
	// MARK: Get Title
	func getTitle() -> String {
		if showingDetail()==false {
			return "Manage Cards"
		} else if viewModel.showingAboutiCloudView {
			return "Cards and iCloud"
		} else if viewModel.showingCardDataDescription {
			return "Data in iCloud"
		} else if viewModel.showingDeleteAllCardsView {
			return "Delete All Cards"
		} else if viewModel.showingManageiCloudView {
			return "Manage iCloud Access"
		} else {
			return "Manage Cards"
		}
	}
#if os(iOS)
	func iOSContents() -> some View {
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
					NavigationLink(restrictOrUnRestrictString, destination: manageiCloudView())
					
					
					// MARK: Delete Message
					Text(deleteMessage).foregroundColor(Color.red)
					
					
					// MARK: Delete Cards
					NavigationLink(deleteString, destination: deleteAllCardsView())
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
		}.alert(isPresented: $viewModel.showingAlert) {
			alert()
		}
	}
#endif
}

// MARK: Preview
struct ManageCardsSheet_Previews: PreviewProvider {
	static var previews: some View {
		ManageCardsSheet(isVisible: .constant(true))
	}
}

enum ManageCardsAlertType {
	case errorLoadingCardsArchive
	case errorLoadingCards
	case successfullyLoadedCards
	case deleteNotConfirmed
	case cardsDeleted
	case deletionError
	case restrictNotConfirmed
	case unRestrictNotConfirmed
	case failedToRestrict
	case failedToUnRestrict
	case restrictionSucceded
	case unRestrictionSucceded
}
