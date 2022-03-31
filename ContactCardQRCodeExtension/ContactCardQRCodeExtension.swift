//
//  ContactCardQRCodeExtension.swift
//  ContactCardQRCodeExtension
//
//  Created by Matt Roberts on 3/11/22.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
enum WidgetMode {
	case placeholder
	case contactQRCode
	case editMessage
	case empty
}
struct Provider: IntentTimelineProvider {
	func placeholder(in context: Context) -> SimpleEntry {
		createPreviewEntry()
	}
	func getSnapshot(for configuration: ConfigurationIntent, in context: Context,
					 completion: @escaping (SimpleEntry) -> Void) {
		let entry=createPreviewEntry()
		completion(entry)
	}
	func getTimeline(for configuration: ConfigurationIntent, in context: Context,
					 completion: @escaping (Timeline<SimpleEntry>) -> Void) {
		let entry=createEntryFromConfiguration(configuration: configuration)
		let timeline = Timeline(entries: [entry], policy: .never)
		completion(timeline)
	}
	func createEntryFromConfiguration(configuration: ConfigurationIntent) ->
		SimpleEntry {
		var qrCode: Image?
		var color: String?
		var title: String?
		var widgetMode=WidgetMode.editMessage
		if let uuid=configuration.parameter?.identifier {
			let container=loadPersistentCloudKitContainer()
			let managedObjectContext=container.viewContext
			let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
				do {
					// Execute Fetch Request
					let contactCards = try managedObjectContext.fetch(fetchRequest)
					if let contactCardMO=contactCards.first(where: { (contactCardMO) -> Bool in
						return uuid==contactCardMO.objectID.uriRepresentation().absoluteString
					}) {
#if os(macOS)
						qrCode=Image(nsImage: ContactDataConverter.makeQRCode(string: contactCardMO.vCardString) ?? NSImage())
#elseif os(iOS)
						qrCode=Image(uiImage: ContactDataConverter.makeQRCode(string: contactCardMO.vCardString) ?? UIImage())
#endif
						title=contactCardMO.filename
						color=contactCardMO.color
						print("Should have made qr code for widget")
						widgetMode=WidgetMode.contactQRCode
					}
				} catch {
					print("Unable to fetch contact cards")
				}
		}
			return SimpleEntry(date: Date(), qrCode: qrCode, color: color, title: title, widgetMode: widgetMode)
	}
}
func createPreviewEntry() -> SimpleEntry {
#if os(macOS)
	let qrCode = Image(nsImage: ContactDataConverter.makeQRCode(string: "https://matthewrobertsdev.github.io/celeritasapps/#/") ?? NSImage())
	return SimpleEntry(date: Date(), qrCode: qrCode,
				color: "Yellow", title: "Placeholder",widgetMode: WidgetMode.placeholder)
#elseif os(iOS)
	let qrCode = Image(uiImage: ContactDataConverter.makeQRCode(string: "https://matthewrobertsdev.github.io/celeritasapps/#/") ?? UIImage())
	return SimpleEntry(date: Date(), qrCode: qrCode,
				color: "Yellow", title: "Placeholder", widgetMode: WidgetMode.placeholder)
#endif
}
struct SimpleEntry: TimelineEntry {
	let date: Date
	let qrCode: Image?
	let color: String?
	let title: String?
	let widgetMode: WidgetMode
}

struct ContactCardQRCodeEntryView: View {
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.widgetFamily) var family
	var entry: Provider.Entry
	@ViewBuilder
	var body: some View {
		if entry.widgetMode==WidgetMode.placeholder {
			if let qrCode=entry.qrCode {
				qrCode.resizable().aspectRatio(contentMode: .fit).colorMultiply(Color("Matching Color", bundle: nil)).background(Color("AppColor", bundle: nil)).padding(12).accessibilityLabel("Placeholder QR Code")
			} else {
				Text("Error making placeholder image.")
			}
			
		} else if entry.widgetMode == WidgetMode.editMessage {
			switch family {
			case .systemSmall:
				Text(getEditWidgetMessage()).font(.system(size: 10, weight: .light, design: .default)).padding()
			case .systemLarge:
				Text(getEditWidgetMessage()).font(.system(size: 20, weight: .light, design: .default)).padding()
			default:
				Text(getEditWidgetMessage()).font(.system(size: 10, weight: .light, design: .default)).padding()
			}
		} else if entry.widgetMode==WidgetMode.contactQRCode {
			if let qrImage = entry.qrCode { qrImage.resizable().aspectRatio(contentMode: .fit).colorMultiply(Color("Matching Color", bundle: nil)).background(Color(entry.color ?? "", bundle: nil)).padding(12).accessibilityLabel("\(entry.color ?? "") QR Code")
			} else {
				Text("Error making QR code image")
			}
		} else {
			switch family {
			case .systemSmall:
				Text(getErrorMessage()).font(.system(size: 10, weight: .light, design: .default)).padding()
			case .systemLarge:
				Text(getErrorMessage()).font(.system(size: 20, weight: .light, design: .default)).padding()
			default:
				Text(getErrorMessage()).font(.system(size: 10, weight: .light, design: .default)).padding()
			}
		}
	}
}
@main
struct ContactCardQRCode: Widget {
	let kind: String = "ContactCardQRCode"
	var body: some WidgetConfiguration {
		IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
			ContactCardQRCodeEntryView(entry: entry)
		}
		.configurationDisplayName("Contact Card QR Code")
		.description("Display a QR Code for a Contact Card").supportedFamilies([.systemSmall, .systemLarge])
	}
}
struct ContactCardQRCodePreviews: PreviewProvider {
	static var previews: some View {
		Group {
		ContactCardQRCodeEntryView(entry: createPreviewEntry())
			.previewContext(
				WidgetPreviewContext(family: .systemSmall))
		ContactCardQRCodeEntryView(entry: createPreviewEntry())
			.previewContext(
				WidgetPreviewContext(family: .systemLarge))
		}
	}
}
func getEditWidgetMessage() -> String {
	#if os(macOS)
	return "Control-click on this widget and choose \"Edit Widget\" to choose a contact card for a QR code."
	#else
	return "While not editing the home screen, press down on this widget  and choose \"Edit Widget\" to choose a contact card for a QR code."
	#endif
}
func getErrorMessage() -> String {
	return "Error loading widget.  Sorry, it was a bug.  Please restart the device to refresh it with the system and fix it."
}
