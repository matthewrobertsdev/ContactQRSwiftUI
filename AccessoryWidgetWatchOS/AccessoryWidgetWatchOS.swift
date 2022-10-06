//
//  AccessoryWidget.swift
//  AccessoryWidget
//
//  Created by Matt Roberts on 10/5/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> SimpleEntry {
		getSimpleEntry()
	}

	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = getSimpleEntry()
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let entry=getSimpleEntry()
		let timeline = Timeline(entries: [entry], policy: .never)
		completion(timeline)
	}
}

func getSimpleEntry() -> SimpleEntry {
	return SimpleEntry(date: Date())
}

struct SimpleEntry: TimelineEntry {
	let date: Date
}

struct AccessoryWidgetEntryView : View {
	var entry: Provider.Entry

	@Environment(\.widgetRenderingMode) private var renderingMode
	
	let tintedImage = "TintedAccessoryImage"
	let fullColorImage = "FullColorAccessoryImage"
		
		var body: some View {
			switch renderingMode {
			case .accented:
				Image(tintedImage).resizable().widgetAccentable()
			case .fullColor:
				Image(fullColorImage).resizable()
			case .vibrant:
				Image(fullColorImage).resizable()
			default:
				Image(fullColorImage).resizable()
			}
		}
}

@main
struct AccessoryWidget: Widget {
	let kind: String = "AccessoryWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			AccessoryWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Contact Cards")
		.description("For quick access to Contact Cards").supportedFamilies([.accessoryCircular, .accessoryCorner])
	}
}

/*
struct AccessoryWidget_Previews: PreviewProvider {
	static var previews: some View {
		AccessoryWidgetEntryView(entry: SimpleEntry(date: Date()))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}
*/

