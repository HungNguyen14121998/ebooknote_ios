//
//  GraphViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/10/24.
//

import UIKit



class GraphViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GraphTableViewCellDelegate {
    
    @IBOutlet weak var graphTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var totalsStep: Int = 0
    var dateGraph: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        graphTableView.reloadData()
    }
    
    private func setupTableView() {
        graphTableView.dataSource = self
        graphTableView.delegate = self
        graphTableView.register(UINib(nibName: Constant.kGraphTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.kGraphTableViewCell)
        
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        graphTableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        showLoading()
        graphTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
            self.hideLoading()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.kGraphTableViewCell, for: indexPath) as? GraphTableViewCell else {
            return UITableViewCell()
        }
        
        cell.reloadGraph()
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("didSelectRowAt")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frameHeader = CGRect(x: 0, y: 0, width: UIDevice.width, height: 90)
        let headerView = GraphHeaderView(frame: frameHeader)
        headerView.setupContent(totals: "\(totalsStep)", date: dateGraph)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 302
    }
    
    // MARK: - GraphTableViewCellDelegate
    func didTapGraphView(graphPoint: GraphPoint) {
        totalsStep = graphPoint.totals
        dateGraph = Date.formatDateToString(date: graphPoint.date)
        graphTableView.reloadData()
    }

}
