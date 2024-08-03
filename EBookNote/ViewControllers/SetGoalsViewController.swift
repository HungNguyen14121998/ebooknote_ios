//
//  SetGoalsViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/10/24.
//

import UIKit

let kUserDefaultGoals = "goalsOfWeek"

class SetGoalsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var numberOfPagesTextField: UITextField!
    private var dataStore = DataStoreManager(key: kUserDefaultGoals)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupDismissKeyboardGesture()
        setupTextField()
    }
    
    private func setupTextField() {
        if let goals = dataStore.getValue() as? Int {
            numberOfPagesTextField.text = "\(goals)"
        } else {
            numberOfPagesTextField.text = "0"
        }
        
        numberOfPagesTextField.delegate = self
    }
    
    func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true) // resign first responder
    }
    
    @IBAction func pressSaveButton(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        if let numberOfPages = numberOfPagesTextField.text {
            let goals = Int(numberOfPages)
            dataStore.set(goals as Any)
            
            showAlertSuccess()
        }
    }
    
    private func showAlertSuccess() {
        let alertController = UIAlertController(title: "Success", message: "Update goals success", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .default) {_ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
    
}
