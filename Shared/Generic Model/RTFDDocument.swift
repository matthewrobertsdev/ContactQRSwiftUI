//
//  RTFDDocument.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 4/16/22.
//
import SwiftUI
import UniformTypeIdentifiers
struct RTFDDocument: FileDocument {
	
	static var readableContentTypes: [UTType] { [.rtfd] }

	var rtfd: String

	init(rtfd: String) {
		self.rtfd = rtfd
	}

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
			  let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		rtfd = string
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		return FileWrapper(regularFileWithContents: rtfd.data(using: .utf8) ?? Data())
	}
	
}
