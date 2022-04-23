//
//  JSONDocument.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/10/22.
//

import SwiftUI
import UniformTypeIdentifiers
struct JSONDocument: FileDocument {
	
	static var readableContentTypes: [UTType] { [.json] }

	var json: String

	init(json: String) {
		self.json = json
	}

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
			  let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		json = string
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		return FileWrapper(regularFileWithContents: json.data(using: .utf8) ?? Data())
	}
	
}
