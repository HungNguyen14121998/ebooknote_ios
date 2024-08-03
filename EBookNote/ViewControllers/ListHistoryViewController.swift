//
//  ListHistoryViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/17/24.
//

import UIKit
import CoreData



class ListHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listHistoryTableView: UITableView!
    
    var book: Book!
    var listHistory = [History]()
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupTitle()
        setupTableView()
        
        loadHistoryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadHistoryData()
    }
    
    private func setupTitle() {
        self.title = book.name
    }
    
    private func setupTableView() {
        listHistoryTableView.dataSource = self
        listHistoryTableView.delegate = self
        listHistoryTableView.register(UINib(nibName: Constant.kHistoryTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.kHistoryTableViewCell)
        
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        listHistoryTableView.refreshControl = refreshControl
        listHistoryTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    private func loadHistoryData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<History> = History.fetchRequest()
        let predicate = NSPredicate(format: "book == %@", book)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? context.fetch(fetchRequest) {
            listHistory = result
            listHistoryTableView.reloadData()
        }
    }
    
    @objc func refreshData() {
        showLoading()
        loadHistoryData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
            self.hideLoading()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.kHistoryTableViewCell, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(history: listHistory[indexPath.row])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("didSelectRowAt")
        performSegue(withIdentifier: Constant.kGoToHistory, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let historyController = segue.destination as? HistoryViewController, segue.identifier == Constant.kGoToHistory {
            historyController.book = book
            if let indexSelected = listHistoryTableView.indexPathForSelectedRow {
                historyController.history = listHistory[indexSelected.row]
            }
        } else if let historyController = segue.destination as? HistoryViewController {
            historyController.book = book
        }
    }
}
