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
	// MARK: vCard to CNContact
	static func getCNContact(vCardString: String) throws ->CNContact? {
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
	// MARK: Contact to String
	//goes from CNContact, to v card Data, to v card String
	static func cnContactToVCardString(cnContact: CNContact) -> String {
		let vCardData=makeVCardData(cnContact: cnContact)
		return makeVCardString(vCardData: vCardData)
	}
	//goes from CNContact, to v card Data, to qr code UIImage
#if os(iOS)
	// MARK: Contact to UIImage
	static func cnContactToQR_Code(cnContact: CNContact) -> UIImage? {
		let vCardData=makeVCardData(cnContact: cnContact)
		let qrCodeImage=makeQRCode(data: vCardData)
		return qrCodeImage
	}
#elseif os(macOS)
	// MARK: Contact to NSImage
	static func cnContactToQR_Code(cnContact: CNContact) -> NSImage? {
		let vCardData=makeVCardData(cnContact: cnContact)
		let qrCodeImage=makeQRCode(data: vCardData)
		return qrCodeImage
	}
#endif
	// MARK: CNContact to Data
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
	// MARK: String to to QRCode
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
	// MARK: Data to to QRCode
	//goes from v card Data to UIImage
	static func makeQRCode(data: Data) -> UIImage? {
		if let filter = CIFilter(name: "CIQRCodeGenerator") {
			filter.setValue(data, forKey: "inputMessage")
			let transform = CGAffineTransform(scaleX: 10, y: 10)
			if let qrCodeImage = filter.outputImage?.transformed(by: transform) {
				let uiImage=UIImage(ciImage: qrCodeImage)
				return getTintedForeground(image: uiImage, color: UIColor.white)
				
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
			if let qrCodeImage = filter.outputImage?.transformed(by: transform){
				let colorParameters = [
					"inputColor0": CIColor(color: NSColor.white), // Foreground
					"inputColor1": CIColor(color: NSColor.clear) // Background
				]
				let coloredImage = qrCodeImage.applyingFilter("CIFalseColor", parameters: colorParameters as [String : Any])
				let nSCIImageRep = NSCIImageRep(ciImage: coloredImage)
				let nsImage = NSImage(size: nSCIImageRep.size)
				nsImage.addRepresentation(nSCIImageRep)
				return nsImage
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
	// MARK: CardMO to File
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
	// MARK: Cards to File
	static func writeArchive(contactCards: [ContactCard], directoryURL: URL, fileExtension: String) -> URL? {
		let filename="Contact Cards"
		let fileURL = directoryURL.appendingPathComponent(filename)
			.appendingPathExtension(fileExtension)
			do {
				let data=try encodeData(contactCards: contactCards)
				try data.write(to: fileURL, options: [.atomicWrite])
			} catch {
				print("Error trying to make write archive")
				return nil
			}
		print("Successfully wrote .contactcards archive.")
		return fileURL
	}
	// MARK: Cards to Data
	static func encodeData(contactCards: [ContactCard]) throws -> Data {
		let encoder=JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(contactCards)
	}
	static func convertToContactCards(managedObjects: [ContactCardMO]) -> [ContactCard] {
		var contactCards=[ContactCard]()
		managedObjects.forEach { contactCardMO in
			contactCards.append(ContactCard(filename: contactCardMO.filename, vCardString: contactCardMO.vCardString, color: contactCardMO.color))
		}
		return contactCards
	}
	// MARK: URL to Cards
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
#if os(iOS)
	static func getQRPNGData(vCardString: String) -> Data? {
		if let qrCode=ContactDataConverter.makeQRCode(string: vCardString) {
			return qrCode.withRenderingMode(.alwaysTemplate).pngData()
		}
		return nil
	}
#elseif os(macOS)
	static func getQRPNGData(vCardString: String) -> Data? {
		if let qrCode=ContactDataConverter.makeQRCode(string: vCardString) {
			guard let cgImage = qrCode.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
				return nil
			}
			let bitmapImage = NSBitmapImageRep(cgImage: cgImage)
			bitmapImage.size = qrCode.size // if you want the same size
			guard let pngImageData = bitmapImage.representation(using: .png, properties: [:]) else {
				return nil
			}
			return pngImageData
		}
		return nil
	}
#endif
}
// MARK: Data Errors
enum DataConversionError: Error {
	case dataSerializationError(String)
	case badVCard(String)
}

enum FileError: Error {
	case failedToWrite(String)
}

