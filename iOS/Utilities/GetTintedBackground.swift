//
//  GetTintedBackground.swift
//  Contact Cards (iOS)
//
//  Created by Matt Roberts on 3/30/22.
//

import UIKit
func getTintedBackground(image: UIImage, color: UIColor) -> UIImage {
	UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
		
	guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = image.cgImage else { return image }
	defer { UIGraphicsEndImageContext() }
		
	let rect = CGRect(origin: .zero, size: image.size)
	ctx.setFillColor(color.cgColor)
	ctx.fill(rect)
	ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: image.size.height))
	ctx.draw(cgImage, in: rect)
		
	return UIGraphicsGetImageFromCurrentImageContext() ?? image
  }
