//
//  FileWorker.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/28/22.
//

import Foundation

class FileWorker {
	static func getRtfdFileWrapper(attributedString: NSAttributedString) throws -> FileWrapper {
		return try attributedString.fileWrapper(from: NSRange (location: 0, length: attributedString.length ), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
	}
	static func getUrlInCachesDirectory(filename: String, fileExtension: String) throws -> URL {
		guard var fileUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
			throw FileError.failedToWrite("Couldn't get caches url")
			}
		fileUrl.appendPathComponent(filename)
		fileUrl.appendPathExtension(fileExtension)
		return fileUrl
	}
}
