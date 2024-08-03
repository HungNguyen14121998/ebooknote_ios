//
//  HistoryViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/10/24.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var pagesButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var book: Book!
    var history: History?
    
    var tagText: String = ""
    var fromPage: Int = 0
    var toPage: Int = 0
    var pagesRead: Int = 0
    
    var createNewDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupNavigationItem()
        setupButtons()
        setupContentTextView()
        
        setupDismissKeyboardGesture()
        setupData()
        
        checkEnableSaveButton()
    }
    
    private func setupNavigationItem() {
        navigationItem.setTitle(title: book.name ?? "", subtitle: "")
    }
    
    private func setNavigationSubTitle(_ subtitle: String) {
        navigationItem.setTitle(title: book.name ?? "", subtitle: subtitle)
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupButtons() {
        saveButton.isEnabled = false
        
        tagButton.addShadow()
        pagesButton.addShadow()
        
        tagButton.configuration?.imagePadding = 4
        pagesButton.configuration?.imagePadding = 4
        
        deleteButton.layer.cornerRadius = 4
        deleteButton.isHidden = true
    }
    
    private func setupContentTextView() {
        contentTextView.delegate = self
    }
    
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    private func setupData() {
        if let history = history {
            deleteButton.isHidden = false
            contentTextView.text = history.content
            let subtitle = (history.tag ?? "") + "(\(history.from) - \(history.to))"
            setNavigationSubTitle(subtitle)
            tagText = history.tag ?? ""
            fromPage = Int(history.from)
            toPage = Int(history.to)
            pagesRead = Int(history.pages)
        }
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true) // resign first responder
    }
    
    // MARK: - Actions
    @IBAction func pressSaveButton(_ sender: UIBarButtonItem) {
        saveHistory()
    }
    
    @IBAction func pressTagButton(_ sender: UIButton) {
        inputTagHistory()
    }
    
    @IBAction func pressPagesButton(_ sender: UIButton) {
        inputPagesReadHistory()
    }
    
    @IBAction func pressDeleteButton(_ sender: UIButton) {
        deleteHistoryOnServer()
    }
    
    // MARK: - Method
    private func checkEnableSaveButton() {
        if contentTextView.text != "" && contentTextView.text != "What did you read today?"
            && tagText != ""
            && pagesRead != 0
        {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func saveHistory() {
        view.endEditing(true)
        
        saveToServer()
    }
    
    private func saveToServer() {
        showLoading()
        if let history = history {
            let historyRequest = HistoryRequestModel(nameBook: book.name!,
                                                     content: contentTextView.text!,
                                                     from: Int(Int16(fromPage)),
                                                     to: Int(Int16(toPage)),
                                                     pages: Int(Int16(pagesRead)),
                                                     tag: tagText,
                                                     createDate: history.creationDate!.timeIntervalSince1970)
            
            APIClient.updateHistory(history: historyRequest, completion: handleToCreateUpdateHistoryResponse(response:error:))
        } else {
            createNewDate = Date()
            let historyRequest = HistoryRequestModel(nameBook: book.name!,
                                                     content: contentTextView.text!,
                                                     from: Int(Int16(fromPage)),
                                                     to: Int(Int16(toPage)),
                                                     pages: Int(Int16(pagesRead)),
                                                     tag: tagText,
                                                     createDate: createNewDate.timeIntervalSince1970)
            
            APIClient.createHistory(history: historyRequest, completion: handleToCreateUpdateHistoryResponse(response:error:))
        }
    }
    
    private func handleToCreateUpdateHistoryResponse(response: CommonResponse?, error: Error?) {
        hideLoading()
        if error != nil {
            showAlertError(message: "Server response error!")
        }
        
        guard let response = response else {return}
        
        saveToPersistent()
        
        navigationController?.popViewController(animated: true)
    }
    
    private func saveToPersistent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        if let history = history {
            history.creationDate = history.creationDate
            history.tag = tagText
            history.from = Int16(fromPage)
            history.to = Int16(toPage)
            history.pages = Int16(pagesRead)
            history.content = contentTextView.text
            // relationship
            history.book = book
        } else {
            let history = History(context: context)
            history.creationDate = createNewDate
            history.tag = tagText
            history.from = Int16(fromPage)
            history.to = Int16(toPage)
            history.pages = Int16(pagesRead)
            history.content = contentTextView.text
            // relationship
            history.book = book
        }
        
        appDelegate.saveContext()
        print("Save history success")
    }
    
    fileprivate func inputTagHistory() {
        let alertController = UIAlertController(title: "Add tag name", message: "Which chapter are you reading?", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Chapter..."
            textField.text = self.tagText
            textField.keyboardType = .default
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            if let chapterTextField = alertController.textFields?.first as? UITextField {
                self.tagText = chapterTextField.text ?? ""
                self.setNavigationSubTitle(self.tagText)
            } else {
                self.tagText = ""
            }
            
            self.checkEnableSaveButton()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func inputPagesReadHistory() {
        let alertController = UIAlertController(title: "Add number of pages", message: "How many number of pages you have read?", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "From"
            textField.text = "\(self.fromPage)"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { textField in
            textField.placeholder = "To"
            textField.text = "\(self.toPage)"
            textField.keyboardType = .numberPad
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            if let fromTextField = alertController.textFields?.first as? UITextField,
               let toTextField = alertController.textFields?.last as? UITextField,
               let fromPage = fromTextField.text,
               let toPage = toTextField.text 
            {
                let fromPage = Int(fromPage.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                let toPage = Int(toPage.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                let subtitle = self.tagText + "(\(fromPage) - \(toPage))"
                self.setNavigationSubTitle(subtitle)
                self.fromPage = fromPage
                self.toPage = toPage
                if toPage > fromPage {
                    self.pagesRead = toPage - fromPage
                } else {
                    self.pagesRead = 0
                }
            }
            
            self.checkEnableSaveButton()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func deleteHistoryOnServer() {
        if let history = history {
            showLoading()
            let historyRequest = HistoryRequestModel(nameBook: book.name!, 
                                                     content: contentTextView.text!,
                                                     from: Int(Int16(fromPage)),
                                                     to: Int(Int16(toPage)),
                                                     pages: Int(Int16(pagesRead)),
                                                     tag: tagText,
                                                     createDate: history.creationDate!.timeIntervalSince1970)
            
            APIClient.deleteHistory(history: historyRequest, completion: handleToDeleteHistoryResponse(response:error:))
        }
    }
    
    private func handleToDeleteHistoryResponse(response: CommonResponse?, error: Error?) {
        hideLoading()
        if error != nil {
            showAlertError(message: "Server response error!")
        }
        
        guard let response = response else {return}
        
        deleteHistoryOnPersistent()
        
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func deleteHistoryOnPersistent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        if let history = history {
            context.delete(history)
            print("Delete history success")
        }
    }
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = textView.text! as NSString
        newText = newText.replacingCharacters(in: range, with: text) as NSString
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What did you read today?" {
            textView.text = ""
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        checkEnableSaveButton()
    }

}
