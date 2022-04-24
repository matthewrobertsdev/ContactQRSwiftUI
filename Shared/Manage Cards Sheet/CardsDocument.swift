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

	var json=Data()
	var rtfd=FileWrapper()
	var fileType = UTType.json

	init(json: Data) {
		fileType = .json
		self.json = json
	}
	
	init(rtfd: FileWrapper) {
		fileType = .rtfd
		self.rtfd = rtfd
	}

	init(configuration: ReadConfiguration) throws {
		if configuration.contentType == .json ||  configuration.contentType == .text {
			guard let data = configuration.file.regularFileContents else {
				throw CocoaError(.fileReadCorruptFile)
			}
			json=data
		}
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		if configuration.contentType == .json {
			return FileWrapper(regularFileWithContents: json)
		} else {
			return rtfd
		}
	}
	
}
