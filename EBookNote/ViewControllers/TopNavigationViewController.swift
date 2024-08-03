//
//  TopNavigationViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/12/24.
//

import UIKit

class TopNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .white
        self.navigationBar.standardAppearance = navBarAppearance
        self.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = .white
    }
}
