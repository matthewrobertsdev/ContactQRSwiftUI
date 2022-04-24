//
//  CloudDataDescriber.swift
//  Contact Cards
//
//  Created by Matt Roberts on 4/23/22.
//
import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import CoreData
class CloudDataDescriber {
	static func getAttributedString(cards: [ContactCardMO]) -> NSAttributedString? {
		let iCloudExplnationString="If you have sync with iCloud on for this app and have given it adequate time for it to sync over the internet, this description should accurately represent your data in iCloud for the Contact Cards app.\n\n\n"
		let attributedString=NSMutableAttributedString(string: iCloudExplnationString)
		let headerLength=iCloudExplnationString.count
		attributedString.append(NSAttributedString(string: "[\n"))
		for index in 0..<cards.count {
			let card=cards[index]
			attributedString.append(NSAttributedString(string: "\t{\n"))
			attributedString.append(NSAttributedString(string: "\t\tfilename: \(card.filename)\n"))
			attributedString.append(NSAttributedString(string: "\t\tcolor: \(card.color)\n"))
			attributedString.append(NSAttributedString(string: "\t\tvCardString: \(card.vCardString)\n"))
#if os(macOS)
			if let qrCodeData = card.qrCodeImage {
				if let qrCodeImage = NSImage(data: qrCodeData) {
					let tintedImage=getTintedForeground(image: qrCodeImage, color: NSColor.gray)
					if let smallQrCodeImage=resizeImage(image: tintedImage, width: 300) {
						let imageAttachment = NSTextAttachment()
						imageAttachment.bounds = CGRect(x: 0, y: -280, width: 300, height: 300)
						imageAttachment.image = smallQrCodeImage
						attributedString.append(NSAttributedString(string: "\t\tqrCodeImage: "))
						attributedString.append(NSAttributedString(attachment: imageAttachment))
						attributedString.append(NSAttributedString(string: "\n"))
					}
				}
			}
#elseif os(iOS)
			if let qrCodeData = card.qrCodeImage {
				if let qrCodeImage = UIImage(data: qrCodeData) {
					let tintedImage=getTintedForeground(image: qrCodeImage, color: UIColor.gray)
					if let smallQrCodeImage=resizeImage(image: tintedImage, width: 300) {
						let imageAttachment = NSTextAttachment()
						imageAttachment.bounds = CGRect(x: 0, y: -280, width: 300, height: 300)
						imageAttachment.image = smallQrCodeImage
						attributedString.append(NSAttributedString(string: "\t\tqrCodeImage: "))
						attributedString.append(NSAttributedString(attachment: imageAttachment))
						attributedString.append(NSAttributedString(string: "\n"))
					}
				}
			}
#endif
			if index<cards.count-1 {
				attributedString.append(NSAttributedString(string: "\t},\n"))
			} else {
				attributedString.append(NSAttributedString(string: "\t}\n"))
			}
		}
		attributedString.append(NSAttributedString(string: "]\n"))
		let headerParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		headerParagraphStyle.alignment = NSTextAlignment.center
#if os(macOS)
		let headerAttributes = [ NSAttributedString.Key.font: NSFont.systemFont(ofSize: CGFloat(18), weight: NSFont.Weight.light),
								 NSAttributedString.Key.paragraphStyle: headerParagraphStyle, .foregroundColor: NSColor.systemBlue]
		let bodyParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		bodyParagraphStyle.alignment = NSTextAlignment.left
		let bodyAttributes = [ NSAttributedString.Key.font: NSFont.systemFont(ofSize: CGFloat(18), weight: NSFont.Weight.light),
							   NSAttributedString.Key.paragraphStyle: bodyParagraphStyle, .foregroundColor: NSColor.systemBlue]
#elseif os(iOS)
		let headerAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.light),
								 NSAttributedString.Key.paragraphStyle: headerParagraphStyle, .foregroundColor: UIColor.systemBlue]
		let bodyParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		bodyParagraphStyle.alignment = NSTextAlignment.left
		let bodyAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.light),
							   NSAttributedString.Key.paragraphStyle: bodyParagraphStyle, .foregroundColor: UIColor.systemBlue]
#endif
		attributedString.addAttributes(headerAttributes, range: NSRange(location: 0, length: headerLength))
		attributedString.addAttributes(bodyAttributes, range: NSRange(location: headerLength-1, length: attributedString.length-headerLength))
		return attributedString
	}
#if os(macOS)
	static func resizeImage(image: NSImage, width: CGFloat) -> NSImage? {
		let destinationSize = NSMakeSize(CGFloat(width), CGFloat(ceil(width/image.size.width * image.size.height)))
		let newImage = NSImage(size: destinationSize)
		newImage.lockFocus()
		image.draw(in: NSMakeRect(0, 0, destinationSize.width, destinationSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.copy, fraction: CGFloat(1))
		newImage.unlockFocus()
		newImage.size = destinationSize
		return NSImage(data: newImage.tiffRepresentation ?? Data())
	}
#elseif os(iOS)
	static func resizeImage(image: UIImage, width: CGFloat) -> UIImage? {
		let canvas = CGSize(width: width, height: CGFloat(ceil(width/image.size.width * image.size.height)))
		let format = image.imageRendererFormat
		format.opaque = true
		return UIGraphicsImageRenderer(size: canvas, format: format).image { _ in image.draw(in: CGRect(origin: .zero, size: canvas))
		}
	}
#endif
}
