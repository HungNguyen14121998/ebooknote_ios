//
//  BookCollectionViewCell.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/13/24.
//

import UIKit
import CoreData

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var bookPhoto: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCard.addShadow()
    }
    
    func setupCell(book: Book) {
        if let data = book.photo {
            bookPhoto.image = UIImage(data: data)
        } else {
            bookPhoto.image = UIImage(named: "image-book-placeholder")
        }
        
        bookTitleLabel.text = book.name
        authorNameLabel.text = book.author
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<History> = History.fetchRequest()
        let predicate = NSPredicate(format: "book == %@", book)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? context.fetch(fetchRequest) {
            let totals = result.reduce(0) { $0 + $1.pages }
            pagesLabel.text = "\(totals) / \(book.numberOfPages)"
        } else {
            pagesLabel.text = "0 / \(book.numberOfPages)"
        }
        
    }
}
