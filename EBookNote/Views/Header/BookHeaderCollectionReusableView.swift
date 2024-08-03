//
//  BookHeaderCollectionReusableView.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/13/24.
//

import UIKit

protocol BookHeaderCollectionReusableViewDelegate: NSObject {
    func didTapUpdateCurrentBookAction()
}

class BookHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var updateButton: UIButton!
    
    var delegate: BookHeaderCollectionReusableViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentStackView.addShadow()
        updateButton.layer.cornerRadius = 4
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        print("update current book")
        delegate?.didTapUpdateCurrentBookAction()
    }
    
}

