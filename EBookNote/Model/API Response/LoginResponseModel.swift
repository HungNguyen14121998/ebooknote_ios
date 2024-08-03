//
//  LoginResponseModel.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/26/24.
//

import Foundation

struct LoginResponseModel: Codable {
    let status: String
    let token: String
    let userId: String
}
