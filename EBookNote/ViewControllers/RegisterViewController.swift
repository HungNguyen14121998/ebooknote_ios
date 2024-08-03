//
//  RegisterViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/7/24.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var widthImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightImageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var usernameTextField: EBTextField!
    @IBOutlet weak var passwordTextField: EBTextField!
    @IBOutlet weak var confirmPasswordTextField: EBTextField!
    
    @IBOutlet weak var createButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
        
        setupTextField(usernameTextField)
        setupTextField(passwordTextField)
        setupTextField(confirmPasswordTextField)
        setupCreateButton()
        
        if UIDevice.width <= UIDevice.widthIphone8plus {
            setupKeyboardHiding()
        }
        setupDismissKeyboardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.offFocusTextField()
        passwordTextField.offFocusTextField()
        confirmPasswordTextField.offFocusTextField()
        view.endEditing(true)
    }
    
    @IBAction func pressCreateButton(_ sender: UIButton) {
        if let username = usernameTextField.text, username != "",
           let password = passwordTextField.text, password != "",
           let confirmPassword = confirmPasswordTextField.text, confirmPassword != "",
           password == confirmPassword
        {
            showLoading()
            APIClient.register(username: username, password: password, completion: handleRegisterResponse(response:error:))
            
        } else {
            showAlertError(message: "username or password/confirm password invalid!")
        }
    }
    
    private func handleRegisterResponse(response: RegisterResponseModel?, error: Error?) {
        hideLoading()
        if error != nil {
            if let nsErr = error as? NSError {
                showAlertError(message: nsErr.domain)
            } else {
                showAlertError(message: "Server response error!")
            }
        }
        
        guard let response = response else { return }
        
        let alertController = UIAlertController(title: "Success", message: "Creaste username success", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .default) {_ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    
    private func setupTextField(_ textField: EBTextField) {
        textField.delegate = self
        textField.offFocusTextField()
    }
    
    private func setupCreateButton() {
        createButton.layer.cornerRadius = 16
    }
    
    private func setupImageView() {
        // set up for iphone large screen
        if UIDevice.width > UIDevice.widthIphone8plus {
            widthImageConstraint.constant = 320
            heightImageConstraint.constant = 240
            view.layoutIfNeeded()
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        usernameTextField.offFocusTextField()
        passwordTextField.offFocusTextField()
        confirmPasswordTextField.offFocusTextField()
        view.endEditing(true) // resign first responder
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === usernameTextField {
            usernameTextField.text = ""
            usernameTextField.onFocusTextField()
            passwordTextField.offFocusTextField()
            confirmPasswordTextField.offFocusTextField()
        } else if textField === passwordTextField {
            passwordTextField.text = ""
            passwordTextField.onFocusTextField()
            usernameTextField.offFocusTextField()
            confirmPasswordTextField.offFocusTextField()
        } else if textField == confirmPasswordTextField {
            confirmPasswordTextField.onFocusTextField()
            usernameTextField.offFocusTextField()
            passwordTextField.offFocusTextField()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }

}
