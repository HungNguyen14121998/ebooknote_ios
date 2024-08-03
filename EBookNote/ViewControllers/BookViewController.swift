//
//  BookViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/10/24.
//

import UIKit
import CoreData

class BookViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BookHeaderCollectionReusableViewDelegate {
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let refreshControl = UIRefreshControl()
    
    var books = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Books"
        
        loadBookData()
    }
    
    private func setupCollectionView() {
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        bookCollectionView.refreshControl = refreshControl
    }
    
    private func setupFlowLayout() {
        let space: CGFloat = 0 // spacing
        let dimesion = (view.frame.size.width - (2 * space)) / 2.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimesion, height: 254)
        flowLayout.sectionHeadersPinToVisibleBounds = true
    }
    
    private func loadBookData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? context.fetch(fetchRequest) {
            books = result
            bookCollectionView.reloadData()
        }
    }
    
    @objc func refreshData() {
        showLoading()
        loadBookData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
            self.hideLoading()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.kBookCollectionViewCell, for: indexPath) as? BookCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(book: books[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = bookCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constant.kBookHeaderCollectionReusableView, for: indexPath) as! BookHeaderCollectionReusableView
            headerView.delegate = self
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = bookCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constant.kFooterHeaderCollectionReusableView, for: indexPath)
            return footerView
        default:
            print("kind default")
        }
        
        // footer
        return bookCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constant.kFooterHeaderCollectionReusableView, for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
    }
    
    // MARK: - BookHeaderCollectionReusableViewDelegate
    func didTapUpdateCurrentBookAction() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<History> = History.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let histories = try? context.fetch(fetchRequest) {
            if histories.count > 0, let lastesBookUpdate = histories.first?.book {
                performSegue(withIdentifier: Constant.kGoToUpDateCurrentBook, sender: lastesBookUpdate)
            } else {
                showAlertNoHistory()
            }
        }
    }
    
    private func showAlertNoHistory() {
        let alertController = UIAlertController(title: "Warning", message: "No history update", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .default) {_ in
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Naviagtion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let listHistoryController = segue.destination as? ListHistoryViewController {
            guard let cell = sender as? BookCollectionViewCell else {return}
            let indexPath = bookCollectionView.indexPath(for: cell)
            let book = books[indexPath?.row ?? 0]
            listHistoryController.book = book
        } else if let historyController = segue.destination as? HistoryViewController,
                  segue.identifier == Constant.kGoToUpDateCurrentBook,
                  let book = sender as? Book {
            historyController.book = book
        }
    }
}
