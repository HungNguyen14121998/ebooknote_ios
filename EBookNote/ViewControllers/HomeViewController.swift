//
//  HomeViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/10/24.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var books = [Book]()
    
    let refreshControl = UIRefreshControl()
    
    var dateSelected = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getDataFromAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHomeData()
    }
    
    private func setupTableView() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.register(UINib(nibName: Constant.kHomeTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.kHomeTableViewCell)

        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        homeTableView.refreshControl = refreshControl
    }
    
    private func getDataFromAPI() {
        showLoading()
        APIClient.getBooks(completion: handleToGetBooksResponse(response:error:))
    }
    
    private func handleToGetBooksResponse(response: [BookResponseModel], error: Error?) {
        if error != nil {
            hideLoading()
            showAlertError(message: "Server response error!")
        }
        
        clearDataPersistent()
        addDataToPersistent(books: response)
    }
    
    private func clearDataPersistent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let result = try context.execute(batchDeleteRequest)
            if let deleteResult = result as? NSBatchDeleteResult {
                let objectIDs = deleteResult.result as? [NSManagedObjectID]
                let changes: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: objectIDs ?? []
                ]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
            context.reset()
        } catch {
            print (error)
        }
    }
    
    private func addDataToPersistent(books: [BookResponseModel]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        for book in books {
            let newBook = Book(context: context)
            newBook.creationDate = Date(timeIntervalSince1970: book.createDate)
            newBook.name = book.name
            newBook.author = book.author
            newBook.numberOfPages = Int16(book.numberOfPages)
            
            if let path = book.photo {
                APIClient.downloadImage(path: path) { image, error in
                    guard let image = image else { return }
                    
                    newBook.photo = image.pngData()
                    appDelegate.saveContext()
                }
            }
            
            appDelegate.saveContext()
            
            for history in book.histories {
                let newHistory = History(context: context)
                newHistory.creationDate = Date(timeIntervalSince1970: history.createDate)
                newHistory.content = history.content
                newHistory.from = Int16(history.from)
                newHistory.to = Int16(history.to)
                newHistory.pages = Int16(history.pages)
                newHistory.tag = history.tag
                newHistory.book = newBook
                
                appDelegate.saveContext()
            }
        }
        
        hideLoading()
        loadHomeData()
    }
    
    private func loadHomeData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? context.fetch(fetchRequest) {
            books = result
            homeTableView.reloadData()
        }
    }
    
    private func loadHomeDataByDate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? context.fetch(fetchRequest) {
            books = result
            if books.count > 0 {
                homeTableView.beginUpdates()
                var indexPaths = [IndexPath]()
                for index in 0...books.count - 1 {
                    let indexPath = IndexPath(row: index, section: 0)
                    if let _ = homeTableView.cellForRow(at: indexPath) {
                        indexPaths.append(indexPath)
                    }
                }
                homeTableView.reloadRows(at: indexPaths, with: .none)
                homeTableView.endUpdates()
            }
        }
    }
    
    @objc func refreshData() {
        showLoading()
        dateSelected = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        loadHomeData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
            self.hideLoading()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.kHomeTableViewCell, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(book: books[indexPath.row], date: dateSelected)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("didSelectRowAt")
        performSegue(withIdentifier: Constant.kToListHistory, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frameHeader = CGRect(x: 0, y: 0, width: UIDevice.width, height: 168)
        let headerView = HomeHeaderView(frame: frameHeader)
        headerView.didTapCell = { date in
            self.dateSelected = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
            self.loadHomeDataByDate()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let listHistoryController = segue.destination as? ListHistoryViewController {
            let indexPath = homeTableView.indexPathForSelectedRow
            let book = books[indexPath?.row ?? 0]
            listHistoryController.book = book
        }
    }
    
}
