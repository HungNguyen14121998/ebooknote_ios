//
//  GridView.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/15/24.
//

import UIKit
import CoreData

class GrapView: UIView
{
    private var path = UIBezierPath()
    
    let kPointCircle = "pointCircle"
    let kDashShape = "dashShape"
    let kGoalsShape = "goalsShape"
    
    fileprivate var gridWidthMultiple: CGFloat // date
    {
        return 14 // 14 rows
    }
    
    fileprivate var gridHeightMultiple : CGFloat // pages
    {
        return 11 // 11 columns
    }

    fileprivate var gridWidth: CGFloat
    {
        return bounds.width/CGFloat(gridWidthMultiple)
    }

    fileprivate var gridHeight: CGFloat
    {
        return bounds.height/CGFloat(gridHeightMultiple)
    }

    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // dataSources
    var graphPoints: [GraphPoint] = []
    
    // data dummy
    fileprivate var dataDummy: [Int] {
        var array = [Int]()
        for _ in 0...13 {
            array.append(Int.random(in: 0...100))
        }
        return array
    }
    
    fileprivate var pointX_Dates: [Double] {
        var array = [Double]()
        stride(from: 0, through: 260, by: 20).forEach { value in
            array.append(Double(value))
        }
        return array
    }
    
    fileprivate var day_Dates: [Date] = Date.getLastWeek + Date.getWeekday
    
    // MARK: - Config graph
    // init value
    private func getDataGraph() -> [Int] { // array int 14 element
        var result = [Int]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<History> = History.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let histories = try? context.fetch(fetchRequest) {
            let twoWeekAgo = Date.getLastWeek + Date.getWeekday
            for endDay in twoWeekAgo {
                let startDay = Calendar.current.date(bySettingHour: 00, minute: 01, second: 01, of: endDay)!
                let filterHistories = histories.filter{ ($0.creationDate ?? Date() > startDay)
                    && ($0.creationDate ?? Date() < endDay) }
                let totals = filterHistories.reduce(0) { $0 + $1.pages }
                result.append(Int(totals))
            }
        }
        return result
    }
    
    // Draw method

    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = 1

        for index in 1...Int(gridWidthMultiple) - 1
        {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }

        for index in 1...Int(gridHeightMultiple) - 1 {
            let start = CGPoint(x: 0, y: CGFloat(index) * gridHeight)
            let end = CGPoint(x: bounds.width, y: CGFloat(index) * gridHeight)
            path.move(to: start)
            path.addLine(to: end)
        }

        //Close the path.
        path.close()
        
        // Specify a border (stroke) color.
        UIColor.grayLight.setStroke()
        path.stroke()
    }
    
    fileprivate func transformValueToPoint(pages: [Int]) -> [GraphPoint] {
        let pointY_Pages: [Double] = pages.map { value in
            return Double(220 - ((value * 220) / 110))
        }
        
        var graphPoints = [GraphPoint]()
        
        // loop 14 times get 14 point for draw value on graph view
        for (index, pointX) in pointX_Dates.enumerated() {
            var graphPoint = GraphPoint()
            let point = CGPoint(x: pointX, y: pointY_Pages[index])
            graphPoint.point = point
            graphPoint.totals = pages[index]
            graphPoint.date = day_Dates[index]
            graphPoints.append(graphPoint)
        }
        
        return graphPoints
    }
    
    fileprivate func drawValue() {
        path = UIBezierPath()
        path.lineWidth = 1
        
        // draw value on graph view
        // loop 14 times - 14 points - 13 line
        for index in 0...12 { // 0...12 -> get 13 line
            let startGraphPointX = self.graphPoints[index].point.x
            let startGraphPointY = self.graphPoints[index].point.y
            
            let endGraphPointX = self.graphPoints[index+1].point.x
            let endGraphPointY = self.graphPoints[index+1].point.y
            
            let start = CGPoint(x: startGraphPointX, y: startGraphPointY)
            let end = CGPoint(x: endGraphPointX, y: endGraphPointY)
            path.move(to: start)
            path.addLine(to: end)
            
            if index + 1 == 13 { // index + 1 == 13 is tails so if index + 1 == 13 line -> stop draw
                break
            }
        }
        
        path.close()
        
        // Specify a border (stroke) color.
        UIColor.accent.setStroke()
        path.stroke()
    }
    
    // MARK: - Draw Graph
    
    override func draw(_ rect: CGRect)
    {
        drawGrid()
        
        graphPoints = transformValueToPoint(pages: getDataGraph())

        drawValue()
        
        addLineGoals()
    }
    
    // MARK: - Handle tap gesture
    
    func tapGraph(point: CGPoint, completion: (GraphPoint) -> Void) {
        var position: Int = 0
        
        // identify point by locations user tapped
        let xMaxHasPoint: CGFloat = 260
        let lastPosition = 13
        /* 
            if x = 46 so position belong between [2] and [3]
            solution:
            let result = x + valueSupportCompare
            => result = 56
            if 40 < result < 60 -> position is [2]
            case result > 60 -> position is [3]
         */
        let valueSupportCompare: CGFloat = 10.0
        
        if point.x > xMaxHasPoint {
            position = lastPosition
        } else {
            for index in 0...lastPosition {
                if index == lastPosition {
                    break
                }
                
                if point.x > pointX_Dates[index] && point.x < pointX_Dates[index + 1] {
                    let result = CGFloat(point.x + valueSupportCompare)
                    position = result > pointX_Dates[index + 1] ? index + 1 : index
                    break
                } else {
                    continue
                }
            }
        }
        
        
        let pointCorrect = self.graphPoints[position].point
        
        // remove old value tapped
        removeOldCircleAndDashLine()
        
        // add new value tapped
        addPointCircle(point: pointCorrect)
        addLineDash(pointX: pointCorrect.x)
        
        // clsoure throw graph point to GraphTableViewCell
        completion(graphPoints[position])
    }
    
    func removeOldCircleAndDashLine() {
        if let sublayers = self.layer.sublayers {
            for item in sublayers {
                if item.name == kPointCircle || item.name == kDashShape {
                    item.removeFromSuperlayer()
                    item.removeAllAnimations()
                }
            }
        }
    }
    
    func removeGoalsShape() {
        if let sublayers = self.layer.sublayers {
            for item in sublayers {
                if item.name == kGoalsShape {
                    item.removeFromSuperlayer()
                    item.removeAllAnimations()
                }
            }
        }
    }
    
    func addPointCircle(point: CGPoint) {
        let circlePoint = CGPoint(x: point.x, y: point.y)
        let halfSize:CGFloat = min(4, 4)
        let lineWidth:CGFloat = 2
        
        let circlePath = UIBezierPath(
            arcCenter: circlePoint,
            radius: CGFloat( halfSize - (lineWidth/2)),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2), // 2 is 100%
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.accent.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.name = kPointCircle
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addLineDash(pointX: Double) {
        let start = CGPoint(x: pointX, y: 0)
        let end = CGPoint(x: pointX, y: 220)
        
        let dashPath = UIBezierPath()
        dashPath.move(to: start)
        dashPath.addLine(to: end)
        
        let dashShape = CAShapeLayer()
        dashShape.path = dashPath.cgPath
        dashShape.fillColor = UIColor.clear.cgColor
        dashShape.strokeColor = UIColor.accent.cgColor
        dashShape.lineDashPattern = [2, 4]
        dashShape.lineWidth = 1
        dashShape.name = kDashShape
        
        self.layer.addSublayer(dashShape)
    }
    
    func addLineGoals() {
        removeGoalsShape()
        let dataStore = DataStoreManager(key: kUserDefaultGoals)
        if let pagesGoals = dataStore.getValue() as? Int, pagesGoals > 0 {
            let averagePages = pagesGoals / 7
            let pointY = Double(220 - ((averagePages * 220) / 110))
            
            let start = CGPoint(x: 0, y: pointY)
            let end = CGPoint(x: 280, y: pointY)
            
            let dashPath = UIBezierPath()
            dashPath.move(to: start)
            dashPath.addLine(to: end)
            
            let goalsShape = CAShapeLayer()
            goalsShape.path = dashPath.cgPath
            goalsShape.fillColor = UIColor.clear.cgColor
            goalsShape.strokeColor = UIColor.orangeGoals.cgColor
            goalsShape.lineDashPattern = [2, 4]
            goalsShape.lineWidth = 1
            goalsShape.name = kGoalsShape
            
            self.layer.addSublayer(goalsShape)
        }
    }
}
