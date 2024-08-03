//
//  HomeTableViewCell.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/13/24.
//

import UIKit
import CoreData

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCard: UIView!

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var titleBookLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundCard.addShadowWithCornerRadius(16)
        addCircleBackground()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundCard.addShadowWithCornerRadius(16)
        addCircleBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(book: Book, date: Date = Date()) {
        titleBookLabel.text = book.name
        authorNameLabel.text = book.author
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<History> = History.fetchRequest()
        let predicate = NSPredicate(format: "book == %@", book)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? context.fetch(fetchRequest) {
            let filterResult = result.filter{ $0.creationDate ?? Date() < date }
            let totals = filterResult.reduce(0) { $0 + $1.pages }
            pagesLabel.text = "\(totals) / \(book.numberOfPages)"
            let percent: Double = Double(totals) / Double(book.numberOfPages) * 100
            percentLabel.text = "\(String(format: "%.0f", percent.rounded())) %"
            let valueOfCircle: Double = calculateCircleValue(totals: Int(totals), numberOfPages: Int(book.numberOfPages))
            addCircleValue(Double(String(format: "%.2f", valueOfCircle)) ?? 0)
            adjustCircleView()
        } else {
            pagesLabel.text = "-- / \(book.numberOfPages)"
        }
    }
    
    private func calculateCircleValue(totals: Int, numberOfPages: Int) -> Double {
        return Double(totals * 2) / Double(numberOfPages)
    }
    
    
    // MARK: - Draw Circle
    
    func addCircleBackground() {
        let halfSize:CGFloat = min( 50, 50)
        let desiredLineWidth:CGFloat = 15
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2)),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.grayBackground.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        circleView.layer.addSublayer(shapeLayer)
    }
    
    func addCircleValue(_ value: Double = 0) {
        let halfSize:CGFloat = min( 50, 50)
        let desiredLineWidth:CGFloat = 15
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2)),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * value), // 2 is 100%
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.accent.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        circleView.layer.addSublayer(shapeLayer)
        
        // animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1
        shapeLayer.add(animation, forKey: "MyAnimation")
    }
    
    func adjustCircleView() {
        circleView.transform = CGAffineTransform(scaleX: 1, y: -1); // flip y
        circleView.transform = circleView.transform.rotated(by: .pi / 2) // 90˚
    }
    
}
