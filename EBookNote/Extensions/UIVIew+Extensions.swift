//
//  UIView+Extensions.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/11/24.
//

import Foundation
import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 1
        self.layer.shadowColor  = UIColor.black.cgColor
    }
    
    func addShadowWithCornerRadius(_ corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 1
        self.layer.shadowColor  = UIColor.black.cgColor
    }
}


