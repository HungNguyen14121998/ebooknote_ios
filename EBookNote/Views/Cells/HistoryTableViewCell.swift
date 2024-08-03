//
//  HistoryTableViewCell.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/17/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var backgroudPages: UIView!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundCard.addShadowWithCornerRadius(12)
        backgroudPages.layer.cornerRadius = 4
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(history: History) {
        tagLabel.text = history.tag
        pagesLabel.text = "\(history.pages)"
        contentLabel.text = history.content
        dateLabel.text = history.creationDate?.formatted()
    }
    
    func setupIsNoneRead() {
        backgroundCard.layer.cornerRadius = 12
        backgroundCard.layer.borderWidth = 1
        backgroundCard.layer.borderColor = UIColor.accent.cgColor
    }
    
}
