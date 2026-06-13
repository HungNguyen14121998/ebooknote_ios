//
//  Constant.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/17/24.
//

import UIKit

struct Constant {

    // Idetifier Segue
    static let kGoToHistory = "goToHistory"
    static let kGoToUpDateCurrentBook = "updateCurrentBook"
    static let kToListHistory = "toListHistory"
    static let kGoToHome = "goToHome"
    
    // Idetifier Header
    static let kHomeHeaderView = "HomeHeaderView"
    static let kGraphHeaderView = "GraphHeaderView"
    static let kBookHeaderCollectionReusableView = "BookHeaderCollectionReusableView"
    static let kFooterHeaderCollectionReusableView = "FooterHeaderCollectionReusableView"
    
    // Idetifier Cell
    static let kHomeHeaderCollectionViewCell = "HomeHeaderCollectionViewCell"
    static let kHistoryTableViewCell = "HistoryTableViewCell"
    static let kGraphTableViewCell = "GraphTableViewCell"
    static let kBookCollectionViewCell = "BookCollectionViewCell"
    static let kHomeTableViewCell = "HomeTableViewCell"
    
    // API Header
    static let applicationJson = "application/json"
    static let httpHeaderAccept = "Accept"
    static let httpHeaderContentType = "Content-Type"
    static let httpHeaderAuthorization = "Authorization"
}
