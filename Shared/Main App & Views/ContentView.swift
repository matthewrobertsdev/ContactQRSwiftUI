//
//  ContentView.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//
import SwiftUI
import CoreData
//main view
struct ContentView: View {
	@EnvironmentObject var cardSharingViewModel: CardSharingViewModel
	// MARK: Cloud Kit
	let viewContext: NSManagedObjectContext
	//fetch sorted by filename (will update automtaicaly)
	@StateObject private var conntentViewModel: MyCardsViewModel
	@State private var showingEmptyTitleAlert = false
	@State private var showingNoCardsAlert = false
	//observe insertions, updates, and deletions so that Siri card and widgets can be updated accordingly
	// MARK: Init
	init(selectedCard: Binding<ContactCardMO?>, modalStateViewModel: ModalStateViewModel, context: NSManagedObjectContext) {
		self._conntentViewModel=StateObject(wrappedValue: MyCardsViewModel(context: context))
		self._selectedCard=selectedCard
		self._modalStateViewModel=StateObject(wrappedValue: modalStateViewModel)
		self.viewContext=context
	}
	// MARK: Modal State
	//state for showing/hiding sheets
	@StateObject private var modalStateViewModel: ModalStateViewModel
	@State private var showingAboutSheet = false
	@Binding private var selectedCard: ContactCardMO?
	// MARK: Min Detail Width
	let minDetailWidthMacOS=CGFloat(540)
	//body
	var body: some View {
		// MARK: macOS
#if os(macOS)
		mainContent()
			.sheet(isPresented: modalStateViewModel.$showingAddCardSheet) {
				addSheet()
			}.sheet(isPresented: modalStateViewModel.$showingManageCardsSheet) {
				ManageCardsSheet(isVisible: modalStateViewModel.$showingManageCardsSheet)
			}
#else
		if UIDevice.current.userInterfaceIdiom == .phone {
			if #available(iOS 16, *) {
				// MARK: Compact Width
				mainContent()
					.sheet(isPresented: modalStateViewModel.$showingAddCardSheet) {
						addSheet()
					}.sheet(isPresented: $showingAboutSheet) {
						//sheet for about modal
						AboutSheet(showingAboutSheet: $showingAboutSheet)
					}.sheet(isPresented: modalStateViewModel.$showingSiriSheet) {
						ShowSiriSheet(isVisible: modalStateViewModel.$showingSiriSheet)
					}.sheet(isPresented: modalStateViewModel.$showingManageCardsSheet) {
						ManageCardsSheet(isVisible: modalStateViewModel.$showingManageCardsSheet)
					}
			} else {
				// MARK: Compact Width
				mainContent()
					.navigationViewStyle(StackNavigationViewStyle())
					.sheet(isPresented: modalStateViewModel.$showingAddCardSheet) {
						addSheet()
					}.sheet(isPresented: $showingAboutSheet) {
						//sheet for about modal
						AboutSheet(showingAboutSheet: $showingAboutSheet)
					}.sheet(isPresented: modalStateViewModel.$showingSiriSheet) {
						ShowSiriSheet(isVisible: modalStateViewModel.$showingSiriSheet)
					}.sheet(isPresented: modalStateViewModel.$showingManageCardsSheet) {
						ManageCardsSheet(isVisible: modalStateViewModel.$showingManageCardsSheet)
					}
			}
			
		} else {
			mainContent()
				.sheet(isPresented: modalStateViewModel.$showingAddCardSheet) {
					addSheet()
				}.sheet(isPresented: $showingAboutSheet) {
					//sheet for about modal
					AboutSheet(showingAboutSheet: $showingAboutSheet)
				}.sheet(isPresented: modalStateViewModel.$showingSiriSheet) {
					ShowSiriSheet(isVisible: modalStateViewModel.$showingSiriSheet)
				}.sheet(isPresented: modalStateViewModel.$showingManageCardsSheet) {
					ManageCardsSheet(isVisible: modalStateViewModel.$showingManageCardsSheet)
				}
		}
#endif
	}
	
	// MARK: Main Content
	@ViewBuilder
	func mainContent() -> some View {
		if #available(iOS 16, macOS 13, *) {
#if os(iOS)
			navigationSplitViewMain()
#else
			Rectangle()
#endif
		} else {
			NavigationView {
				ScrollViewReader { proxy in
					List() {
						naviagtionForEach(proxy: proxy)
					}.onChange(of: selectedCard) { target in
						if let target = target {
							proxy.scrollTo(target.objectID, anchor: nil)
							
						}
					}.onAppear() {
						if conntentViewModel.cards.isEmpty {
							showingNoCardsAlert = true
						}
					}.alert(isPresented: $showingNoCardsAlert, content: {
#if os(macOS)
						let addACardMessage="To create a contact card, click the plus button in the top of the sidebar or open the Cards menu and click \"Add Card\"."
#else
						var addACardMessage="To create a contact card, tap the plus button."
						if UIDevice.current.userInterfaceIdiom == .pad {
							addACardMessage="To create a contact card, go to the \"My Cards\" list and tap the plus button at the top."
						}
#endif
						return Alert(title: Text("Create a Card"), message: Text(addACardMessage), dismissButton: .default(Text("Got it.")))
					})
				}
#if os(macOS)
				.frame(minWidth: nil, idealWidth: 150, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil)
#endif
				.toolbar {
					// MARK: Add Card
					ToolbarItem(placement: .primaryAction) {
						Button(action: addCard) {
							Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
						}
					}
#if os(macOS)
					// MARK: Toggle Sidebar
					ToolbarItem(placement: .navigation) {
						Button(action: toggleSidebar, label: {
							Label("Toggle Sidebar", systemImage: "sidebar.leading").accessibilityLabel("Toggle Sidebar")
						})
					}
#endif
					// MARK: iOS Toolbar
#if os(iOS)
					//iOS bottom toolbar item group
					ToolbarItemGroup(placement: .bottomBar) {
						// MARK: For Siri
						Button(action: showSiriSheet) {
							Text("For Siri").accessibilityLabel("For Siri")
						}
						Spacer()
						// MARK: Manage Cards
						Button(action: showManageCardsSheet) {
							Label("Manage Cards", systemImage: "gearshape").accessibilityLabel("Manage Cards")
						}
						// MARK: About
						Spacer()
						Button(action: showAboutSheet) {
							Label("About", systemImage: "questionmark").accessibilityLabel("About")
						}
						Spacer()
						// MARK: Edit
						EditButton()
					}
#endif
				}.navigationTitle("My Cards")
				// MARK: Default View
				NoCardSelectedView()
			}
#if os(macOS)
			.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center).toolbar {
				// MARK: Add Card
			}
#endif
		}
	}
	
#if os(iOS)
	@available(iOS 16, *)
	func navigationSplitViewMain() -> some View {
		NavigationSplitView {
			ScrollViewReader { proxy in
				List(selection: $selectedCard) {
					ForEach(conntentViewModel.cards, id: \.objectID) {
						card in
						if let selectedCard = selectedCard {
							if selectedCard.objectID==card.objectID {
								CardRow(card: card, selected: true).tag(card)
							} else {
								CardRow(card: card, selected: false).tag(card)
							}
						} else {
							CardRow(card: card, selected: false).tag(card)
						}
					}.onDelete(perform: { offsets in
						withAnimation {
							offsets.map { conntentViewModel.cards[$0] }.forEach(viewContext.delete)
							do {
								try viewContext.save()
							} catch {
								print("Failed to delete one or more cards")
							}
						}
					})
				}
				.onChange(of: selectedCard) { target in
					if let target = target {
						proxy.scrollTo(target.objectID, anchor: nil)
						
					}
				}.onAppear() {
					if conntentViewModel.cards.isEmpty {
						showingNoCardsAlert = true
					}
				}.alert(isPresented: $showingNoCardsAlert, content: {
					//#if os(macOS)
					//let addACardMessage="To create a contact card, click the plus button in the top of the sidebar or open the Cards menu and click \"Add Card\"."
					//#else
					var addACardMessage="To create a contact card, tap the plus button."
					if UIDevice.current.userInterfaceIdiom == .pad {
						addACardMessage="To create a contact card, go to the \"My Cards\" list and tap the plus button at the top."
					}
					//#endif
					return Alert(title: Text("Create a Card"), message: Text(addACardMessage), dismissButton: .default(Text("Got it.")))
				})
				//#if os(macOS)
				//.frame(minWidth: nil, idealWidth: 150, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil)
				//#endif
				.toolbar {
					// MARK: Add Card
					ToolbarItem(placement: .primaryAction) {
						Button(action: addCard) {
							Label("Add Card", systemImage: "plus").accessibilityLabel("Add Card")
						}
					}
					/*
					 #if os(macOS)
					 // MARK: Toggle Sidebar
					 ToolbarItem(placement: .navigation) {
					 Button(action: toggleSidebar, label: {
					 Label("Toggle Sidebar", systemImage: "sidebar.leading").accessibilityLabel("Toggle Sidebar")
					 })
					 }
					 #endif
					 */
					// MARK: iOS Toolbar
					//#if os(iOS)
					//iOS bottom toolbar item group
					ToolbarItemGroup(placement: .bottomBar) {
						// MARK: For Siri
						Button(action: showSiriSheet) {
							Text("For Siri").accessibilityLabel("For Siri")
						}
						Spacer()
						// MARK: Manage Cards
						Button(action: showManageCardsSheet) {
							Label("Manage Cards", systemImage: "gearshape").accessibilityLabel("Manage Cards")
						}
						// MARK: About
						Button(action: showAboutSheet) {
							Label("About", systemImage: "questionmark").accessibilityLabel("About")
						}
					}
					//#endif
				}.navigationTitle("My Cards")
			}
			// MARK: Delete Card
			
		} detail: {
			// MARK: Card View
			if let card = selectedCard {
				ContactCardView(context: viewContext, card: card, selectedCard: $selectedCard, modalStateViewModel: modalStateViewModel ).environment(\.managedObjectContext, viewContext).environmentObject(cardSharingViewModel)
				//#if os(macOS)
				//.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center)
				//#endif
			} else {
				NoCardSelectedView()
			}
		}
		
	}
#endif
	
	// MARK: Navigation ForEach
	@ViewBuilder
	func naviagtionForEach(proxy: ScrollViewProxy) -> some View {
		ForEach(conntentViewModel.cards, id: \.objectID) { card in
			//view upon selection by list
			NavigationLink(tag: card, selection: $selectedCard) {
				// MARK: Card View
				ContactCardView(context: viewContext, card: card, selectedCard: $selectedCard, modalStateViewModel: modalStateViewModel ).environment(\.managedObjectContext, viewContext).environmentObject(cardSharingViewModel)
#if os(macOS)
					.frame(minWidth: minDetailWidthMacOS, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center)
#endif
			} label: {
				// MARK: Card Row
				//card row: the label (with title and circluar color)
				if let selectedCard = selectedCard {
					if selectedCard.objectID==card.objectID {
						CardRow(card: card, selected: true)
					} else {
						CardRow(card: card, selected: false)
					}
				} else {
					CardRow(card: card, selected: false)
				}
				
			}
			// MARK: Delete Card
		}.onDelete { offsets in
			withAnimation {
				offsets.map { conntentViewModel.cards[$0] }.forEach(viewContext.delete)
				do {
					try viewContext.save()
				} catch {
					print("Failed to delete one or more cards")
				}
			}
		}
	}
	
	
	// MARK: Add Sheet
	@ViewBuilder
	func addSheet() -> some View {
		//sheet for adding or editing card
		if #available(iOS 15, macOS 12.0, *) {
			AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: modalStateViewModel.$showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert("Title Required", isPresented: $showingEmptyTitleAlert, actions: {
				Button("Got it.", role: .none, action: {})
			}, message: {
				Text("Card title must not be blank.")
			})
		} else {
			AddOrEditCardSheet(viewContext: viewContext, showingAddOrEditCardSheet: modalStateViewModel.$showingAddCardSheet, forEditing: false, card: nil, showingEmptyTitleAlert: $showingEmptyTitleAlert, selectedCard: $selectedCard).environment(\.managedObjectContext, viewContext).alert(isPresented: $showingEmptyTitleAlert, content: {
				Alert(title: Text("Title Required"), message: Text("Card title must not be blank."), dismissButton: .default(Text("Got it.")))
			})
		}
	}
	// MARK: Show Modals
	//show add or edit card sheet in add mode
	private func addCard() {
		modalStateViewModel.showingAddCardSheet=true
	}
	private func showAboutSheet() {
		showingAboutSheet=true
	}
	private func showSiriSheet() {
		modalStateViewModel.showingSiriSheet=true
	}
	private func showManageCardsSheet() {
		modalStateViewModel.showingManageCardsSheet=true
	}
	// MARK: Toggle Sidebar
	private func toggleSidebar() { // 2
#if os(macOS)
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
#endif
	}
	
}
/*
 // MARK: Preview
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
 }
 }
 */
