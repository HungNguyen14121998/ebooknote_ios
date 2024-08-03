//
//  BooksResponseModel.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/31/24.
//

import Foundation

struct BooksResponseModel: Codable {
    let data: [BookResponseModel]
}

struct BookResponseModel: Codable {
    let name: String
    let author: String
    let photo: String
    let numberOfPages: Int
    let createDate: Double
    let histories: [HistoryResponseModel]
}

struct HistoryResponseModel: Codable {
    let content: String
    let from: Int
    let to: Int
    let pages: Int
    let tag: String
    let createDate: Double
}
