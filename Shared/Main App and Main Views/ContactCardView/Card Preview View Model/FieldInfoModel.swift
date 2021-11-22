//
//  FieldInfoModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/19/21.
//
import SwiftUI
struct FieldInfoModel: Identifiable {
	var hasLink: Bool
	var text: String
	var linkText: String
	var hyperlink: String
	var id=UUID()
}
