//
//  LoginViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/7/24.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var widthImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightImageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var usernameTextField: EBTextField!
    @IBOutlet weak var passwordTextField: EBTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupImageView()
        
        setupTextField(usernameTextField)
        setupTextField(passwordTextField)
        setupLoginButton()
        setupRegisterButton()
        
        if UIDevice.width <= UIDevice.widthIphone8plus {
            setupKeyboardHiding()
        }
        setupDismissKeyboardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.offFocusTextField()
        passwordTextField.offFocusTextField()
        view.endEditing(true)
    }
    
    @IBAction func pressLoginButton(_ sender: UIButton) {
        showLoading()
        if let username = usernameTextField.text, let password = passwordTextField.text, username != "", password != "" {
            APIClient.login(username: username, password: password, completion: handleLoginResponse(response:error:))
        } else {
            hideLoading()
            showAlertError(message: "username or password invalid!")
        }
    }
    
    private func handleLoginResponse(response: LoginResponseModel?, error: Error?) {
        hideLoading()
        if error != nil {
            if let nsErr = error as? NSError {
                showAlertError(message: nsErr.domain)
            } else {
                showAlertError(message: "Server response error!")
            }
        }
        
        guard let response = response else { return }
        
        performSegue(withIdentifier: Constant.kGoToHome, sender: nil)
    }
    
    private func setupTextField(_ textField: EBTextField) {
        textField.delegate = self
        textField.offFocusTextField()
    }
    
    private func setupLoginButton() {
        loginButton.layer.cornerRadius = 16
    }
    
    private func setupRegisterButton() {
        createAccountButton.layer.cornerRadius = 16
        createAccountButton.layer.borderWidth = 1.5
        createAccountButton.layer.borderColor = UIColor.accent.cgColor
    }
    
    private func setupImageView() {
        // set up for iphone large screen
        if UIDevice.width > UIDevice.widthIphone8plus {
            widthImageConstraint.constant = 240
            heightImageConstraint.constant = 240
            view.layoutIfNeeded()
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc private  func viewTapped(_ recognizer: UITapGestureRecognizer) {
        usernameTextField.offFocusTextField()
        passwordTextField.offFocusTextField()
        view.endEditing(true) // resign first responder
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === usernameTextField {
            usernameTextField.text = ""
            usernameTextField.onFocusTextField()
            passwordTextField.offFocusTextField()
        } else if textField === passwordTextField {
            passwordTextField.text = ""
            passwordTextField.onFocusTextField()
            usernameTextField.offFocusTextField()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }


}

