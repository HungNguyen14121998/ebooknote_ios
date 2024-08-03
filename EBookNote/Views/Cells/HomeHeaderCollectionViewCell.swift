//
//  HomeHeaderCollectionViewCell.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/12/24.
//

import UIKit

class HomeHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayTextLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.dayNumberLabel.textColor = .black
        contentView.layer.borderColor = UIColor.accent.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func setupCell(monthText: String?, dateText: String?) {
        self.dayTextLabel.text = monthText
        self.dayNumberLabel.text = dateText
    }
    
    func setSelected() {
        self.dayNumberLabel.textColor = .accent
    }
    
    func setUnSelected() {
        self.dayNumberLabel.textColor = .black
    }

}
