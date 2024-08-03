//
//  GraphHeaderView.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/15/24.
//

import UIKit

class GraphHeaderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var totalsLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        let bundle = Bundle(for: GraphHeaderView.self)
        bundle.loadNibNamed(Constant.kGraphHeaderView, owner: self, options: nil)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: 90)
        addSubview(contentView)
        
        contentView.addShadow()
    }
    
    func setupContent(totals: String, date: String) {
        totalsLabel.text = "--"
        pagesLabel.isHidden = true
        dateLabel.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.totalsLabel.text = totals
            self.pagesLabel.isHidden = false
            self.dateLabel.text = date
        }
    }
}
