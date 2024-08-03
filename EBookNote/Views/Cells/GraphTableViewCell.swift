//
//  GraphTableViewCell.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/15/24.
//

import UIKit

protocol GraphTableViewCellDelegate: NSObject {
    func didTapGraphView(graphPoint: GraphPoint)
}

class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var graphView: GrapView!
    
    weak var delegate: GraphTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundCard.addShadow()
        
        let tapGetsure = UITapGestureRecognizer(target: self, action: #selector(self.graphTapped(_:)))
        graphView.isUserInteractionEnabled = true
        graphView.addGestureRecognizer(tapGetsure)
    }
    
    func reloadGraph() {
        graphView.setNeedsDisplay()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func graphTapped(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self.graphView)
        graphView.tapGraph(point: point) { [weak self] grapPoint in
            self?.delegate?.didTapGraphView(graphPoint: grapPoint)
        }
    }
    
}
