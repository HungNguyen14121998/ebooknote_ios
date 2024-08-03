//
//  MainTabbarViewController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/12/24.
//

import UIKit

class MainTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    @IBOutlet weak var addBookButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        addBookButton.isHidden = true
        
        setupTabbar()
    }
    
    private func setupTabbar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .white
        self.navigationItem.standardAppearance = navBarAppearance
        self.navigationItem.scrollEdgeAppearance = navBarAppearance
        self.navigationItem.hidesBackButton = true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
        
        addBookButton.isHidden = !(item.tag == 1)
    }
}
