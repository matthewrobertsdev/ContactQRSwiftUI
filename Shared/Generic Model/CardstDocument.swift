//
//  CardsExportFile.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/16/22.
//

import SwiftUI
import UniformTypeIdentifiers
struct CardsDocument: FileDocument {
	
	static var readableContentTypes: [UTType] { [.json, .text, .rtfd,] }

	var json=""
	var rtfd=""
	var fileType = UTType.json

	init(json: String) {
		fileType = .json
		self.json = json
	}
	
	init(rtfd: String) {
		fileType = .rtfd
		self.rtfd = rtfd
	}

	init(configuration: ReadConfiguration) throws {
		if configuration.contentType == .json ||  configuration.contentType == .text {
			guard let data = configuration.file.regularFileContents,
				  let string = String(data: data, encoding: .utf8)
			else {
				throw CocoaError(.fileReadCorruptFile)
			}
			json = string
		} else {
			guard let data = configuration.file.regularFileContents,
				  let string = String(data: data, encoding: .utf8)
			else {
				throw CocoaError(.fileReadCorruptFile)
			}
			rtfd = string
		}
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		if configuration.contentType == .json {
			return FileWrapper(regularFileWithContents: json.data(using: .utf8) ?? Data())
		} else {
			return FileWrapper(regularFileWithContents: rtfd.data(using: .utf8) ?? Data())
		}
	}
	
}