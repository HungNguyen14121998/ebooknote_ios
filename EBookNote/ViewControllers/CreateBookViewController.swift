//
//  CreateBookViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/10/24.
//

import UIKit
import CoreData

class CreateBookViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var widthImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightImageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var photoBook: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var bookNameTextField: UITextField!
    @IBOutlet weak var authorNameTextField: UITextField!
    @IBOutlet weak var numberOfPagesTextField: UITextField!
    
    
    var imageData: Data? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        
        setupNavigationController()
        setupButtons()
        setupTextFields()
        
        setupDismissKeyboardGesture()
    }
    
    
    @IBAction func pressSaveButton(_ sender: UIBarButtonItem) {
        saveBook()
    }
    
    @IBAction func pressCameraButton(_ sender: UIButton) {
        pickImage(sourceType: .camera)
    }
    
    @IBAction func pressLibraryButton(_ sender: UIButton) {
        pickImage(sourceType: .photoLibrary)
    }
    
    private func pickImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setupButtons() {
        saveButton.isEnabled = false
        
        cameraButton.configuration?.imagePadding = 12
        libraryButton.configuration?.imagePadding = 12
    }
    
    private func setupTextFields() {
        setupTextField(bookNameTextField)
        setupTextField(authorNameTextField)
        setupTextField(numberOfPagesTextField)
    }
    
    private func setupTextField(_ textField: UITextField) {
        textField.addShadow()
        textField.delegate = self
    }
    
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true) // resign first responder
    }
    
    private func setupImageView() {
        // set up for iphone large screen
        if UIScreen.main.bounds.size.width > 375 {
            widthImageConstraint.constant = 160
            heightImageConstraint.constant = 200
            view.layoutIfNeeded()
        }
    }
    
    private func checkEnableSaveButton() {
        if imageData != nil
            && bookNameTextField.text != ""
            && authorNameTextField.text != ""
            && numberOfPagesTextField.text != ""
        {
            saveButton.isEnabled = true
        }
    }
    
    private func saveBook() {
        view.endEditing(true)
        
        saveToServer()
    }
    
    private func saveToServer() {
        
        showLoading()
        let bookRequest = BookRequestModel(name: bookNameTextField.text!,
                                    author: authorNameTextField.text!,
                                    numberOfPages: Int(Int16(getNumberOfPage())),
                                    createDate: Date().timeIntervalSince1970)
        
        APIClient.createBook(book: bookRequest, completion: handleToCreateBookResponse(response:error:))
    }
    
    private func handleToCreateBookResponse(response: CommonResponse?, error: Error?) {
        hideLoading()
        if error != nil {
            if let nsErr = error as? NSError {
                showAlertError(message: nsErr.domain)
            } else {
                showAlertError(message: "Server response error!")
            }
        }
        
        guard let response = response else {return}
        
        uploadImage()
        
        saveToPersistent()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func uploadImage() {
        
        guard let bookName = bookNameTextField.text, let imageData = imageData, let image = UIImage(data: imageData) else {return}
        
        APIClient.uploadImage(bookName: bookName, image: image) { result in
            if result {
                print("upload success")
            } else {
                print("upload error")
            }
        }
    }
    
    private func saveToPersistent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let book = Book(context: context)
        book.creationDate = Date()
        book.photo = imageData
        book.name = bookNameTextField.text
        book.author = authorNameTextField.text
        book.numberOfPages = Int16(getNumberOfPage())
        
        appDelegate.saveContext()
        print("Save book success")
    }
    
    private func getNumberOfPage() -> Int {
        if let numberOfPages = numberOfPagesTextField.text {
            return numberOfPages.convertToInt()
        } else {
            return 0
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL {
            if let ext = imageUrl.pathExtension {
                print(ext)
            }
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            photoBook.image = image
            imageData = image.pngData()
            checkEnableSaveButton()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === bookNameTextField {
            bookNameTextField.text = ""
        } else if textField === authorNameTextField {
            authorNameTextField.text = ""
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkEnableSaveButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === bookNameTextField {
            authorNameTextField.becomeFirstResponder()
        } else if textField === authorNameTextField {
            numberOfPagesTextField.becomeFirstResponder()
        }
        
        return true
    }
    
}
