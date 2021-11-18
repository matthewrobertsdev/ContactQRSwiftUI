//
//  ContactDataConverter.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/16/21.
//

import Foundation
import Contacts
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
/*
 Converts between CNContact, vCard Data, String, and QR code
 */
class ContactDataConverter {
	static func getCNContact(vCardString: String)throws ->CNContact? {
		if let vCardData = vCardString.data(using: .utf8) {
			let contacts=try CNContactVCardSerialization.contacts(with: vCardData)
			if contacts.count==1 {
				return contacts[0]
			} else {
				return nil
			}
		} else {
			throw DataConversionError.dataSerializationError("Couldn't serialize string to data.")
		}
	}
	//goes from CNContact, to v card Data, to v card String
	static func cnContactToVCardString(cnContact: CNContact) -> String {
		let vCardData=makeVCardData(cnContact: cnContact)
		return makeVCardString(vCardData: vCardData)
	}
	//goes from CNContact, to v card Data, to qr code UIImage
#if os(iOS)
	static func cnContactToQR_Code(cnContact: CNContact) -> UIImage? {
		let vCardData=makeVCardData(cnContact: cnContact)
		let qrCodeImage=makeQRCode(data: vCardData)
		return qrCodeImage
	}
#elseif os(macOS)
	static func cnContactToQR_Code(cnContact: CNContact) -> NSImage? {
		let vCardData=makeVCardData(cnContact: cnContact)
		let qrCodeImage=makeQRCode(data: vCardData)
		return qrCodeImage
	}
#endif
	//goes from CnContact to Data
	static func makeVCardData(cnContact: CNContact) -> Data {
		var vCardData=Data()
		do {
			try vCardData=CNContactVCardSerialization.data(with: [cnContact])
		} catch {
			print ("CNConact not serialized./nError is:/n\(error.localizedDescription)")
			return vCardData
		}
		return vCardData
	}
	//goes from v card Data to String
	static func makeVCardString(vCardData: Data) -> String {
		return String(data: vCardData, encoding: .utf8) ?? "Data was nil"
	}
#if os(iOS)
	static func makeQRCode(string: String) -> UIImage? {
		let data = string.data(using: .utf8) ?? Data()
		return makeQRCode(data: data)
	}
#elseif os(macOS)
	static func makeQRCode(string: String) -> NSImage? {
		let data = string.data(using: .utf8) ?? Data()
		return makeQRCode(data: data)
	}
#endif

#if os(iOS)
	//goes from v card Data to UIImage
	static func makeQRCode(data: Data) -> UIImage? {
		if let filter = CIFilter(name: "CIQRCodeGenerator") {
			filter.setValue(data, forKey: "inputMessage")
			let transform = CGAffineTransform(scaleX: 10, y: 10)
			if let qrCodeImage = filter.outputImage?.transformed(by: transform) {
				return UIImage(ciImage: qrCodeImage)
			} else {
				print("Unable to make qrCodeImage from data with filter")
				return nil
			}
		} else {
			print("Unable to find CIFilter named CIQRCodeGenerator")
			return nil
		}
	}
#elseif os(macOS)
	//goes from v card Data to UIImage
	static func makeQRCode(data: Data) -> NSImage? {
		if let filter = CIFilter(name: "CIQRCodeGenerator") {
			filter.setValue(data, forKey: "inputMessage")
			let transform = CGAffineTransform(scaleX: 10, y: 10)
			if let qrCodeImage = filter.outputImage?.transformed(by: transform).cgImage {
				return NSImage(cgImage: qrCodeImage, size: NSSize(width: qrCodeImage.width, height: qrCodeImage.height))
			} else {
				print("Unable to make qrCodeImage from data with filter")
				return nil
			}
		} else {
			print("Unable to find CIFilter named CIQRCodeGenerator")
			return nil
		}
	}
#endif
	static func writeTemporaryFile(contactCard: ContactCardMO, directoryURL: URL, useCardName: Bool) -> URL? {
		var filename="Contact"
		var contact=CNContact()
		do {
			if let contactToWrite=try ContactDataConverter.getCNContact(vCardString: contactCard.vCardString) {
				contact=contactToWrite
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
		if let name=CNContactFormatter().string(from: contact) {
			filename=name
		}
		if useCardName {
			filename=contactCard.filename
		}
		let fileURL = directoryURL.appendingPathComponent(filename)
			.appendingPathExtension("vcf")
		do {
		let data = try CNContactVCardSerialization.data(with: [contact])

		try data.write(to: fileURL, options: [.atomicWrite])
		} catch {
			print("Error trying to make vCard file")
			return nil
		}
		return fileURL
	}
	static func writeArchive(contactCards: [ContactCard], directoryURL: URL, fileExtension: String) -> URL? {
		let filename="Contact Cards"
		let fileURL = directoryURL.appendingPathComponent(filename)
			.appendingPathExtension(fileExtension)
			if let data=encodeData(contactCards: contactCards) {
				do {
					try data.write(to: fileURL, options: [.atomicWrite])
				} catch {
					print("Error trying to make write archive")
					return nil
				}
			} else {
				return nil
			}
		print("Successfully wrote .contactcards archive.")
		return fileURL
	}
	static func encodeData(contactCards: [ContactCard]) -> Data? {
		do {
			let encoder=JSONEncoder()
			encoder.outputFormatting = .prettyPrinted
			return try encoder.encode(contactCards)
		} catch {
			print("Error trying to make write archive")
			return nil
		}
	}
	static func readArchive(url: URL) -> [ContactCard]? {
		do {
			guard url.startAccessingSecurityScopedResource() else {
							print("Can't access archive")
							return nil
					}
			let decoder=JSONDecoder()
			let data=try Data(contentsOf: url)
			defer { url.stopAccessingSecurityScopedResource() }
			return try decoder.decode([ContactCard].self, from: data)
		} catch {
			print("Error trying to decode data")
			return nil
		}
	}
}
enum DataConversionError: Error {
	case dataSerializationError(String)
	case badVCard(String)
}

