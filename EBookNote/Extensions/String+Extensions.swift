//
//  String+Extensions.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/20/24.
//

import Foundation

extension String {
    func convertToInt() -> Int {
        guard let result = Int(self) else {
            return 0
        }
        return result
    }
}
