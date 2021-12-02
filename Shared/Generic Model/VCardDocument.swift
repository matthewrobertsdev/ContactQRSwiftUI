//
//  VCardDocument.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/1/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct VCardDocument: FileDocument {
	
	static var readableContentTypes: [UTType] { [.vCard] }

	var vCard: String

	init(vCard: String) {
		self.vCard = vCard
	}

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
			  let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		vCard = string
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		return FileWrapper(regularFileWithContents: vCard.data(using: .utf8) ?? Data())
	}
	
}
