//
//  BookRequestModel.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/30/24.
//

import Foundation

struct BookRequestModel: Codable {
    let name: String
    let author: String
    let numberOfPages: Int
    let createDate: Double
}
