//
//  UIVIewController+Extensions.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/12/24.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    func setupNavigationController() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .white
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    func showLogoutAlert() {
        let alertController = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Logout", style: .destructive) {_ in 
            APIClient.Auth.accessToken = ""
            APIClient.Auth.userId = ""
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func showLoading() {
        let backgroudLoading = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.width, height: UIDevice.height))
        backgroudLoading.tag = 1001
        backgroudLoading.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (UIDevice.width / 2) - 20, y: (UIDevice.height / 2) - 20, width: 40, height: 40))
        backgroudLoading.addSubview(activityIndicator)
        
        activityIndicator.style = .large
        activityIndicator.color = UIColor.white
        activityIndicator.startAnimating()
        
        self.view.window?.addSubview(backgroudLoading)
        
    }
    
    func hideLoading() {
        if let subviews = view.window?.subviews {
            for item in subviews {
                if item.tag == 1001 {
                    item.removeFromSuperview()
                }
            }
        }
    }
    
    func showAlertError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel) {_ in
            
        }
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
}
