//
//  HistoryRequestModel.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/31/24.
//

import Foundation

struct HistoryRequestModel: Codable {
    let nameBook: String
    let content: String
    let from: Int
    let to: Int
    let pages: Int
    let tag: String
    let createDate: Double
}
