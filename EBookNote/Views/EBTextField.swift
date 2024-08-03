//
//  EBTextField.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/13/24.
//

import UIKit

class EBTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func onFocusTextField() {
        self.backgroundColor = UIColor.blueLight
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.accent.cgColor
        self.layer.borderWidth = 2
    }
    
    func offFocusTextField() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.grayLight.cgColor
        self.layer.borderWidth = 1
    }
}
