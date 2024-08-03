//
//  HomeHeaderView.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/12/24.
//

import UIKit

class HomeHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var homeHeaderCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let kHeightOfView = 168.0
    let kHeightCollectionView = 128.0
    
    let dates: [Date] = Date.getWeekday
    var indexSelected: Int = -1 // init index selected
    
    var didTapCell: ((Date) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    func initView() {
        let bundle = Bundle(for: HomeHeaderView.self)
        bundle.loadNibNamed(Constant.kHomeHeaderView, owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: kHeightOfView)
        homeHeaderCollectionView.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: kHeightCollectionView)
        addSubview(contentView)
        
        
        homeHeaderCollectionView.dataSource = self
        homeHeaderCollectionView.delegate = self
        homeHeaderCollectionView.register(UINib(nibName: Constant.kHomeHeaderCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constant.kHomeHeaderCollectionViewCell)
        
        scrollToCurrentDate()
    }
    
    func scrollToCurrentDate() {
        let row = indexOfWeekday()
        let indexPath = IndexPath(row: row, section: 0)
        homeHeaderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func indexOfWeekday() -> Int {
        let currentDate = Date()
        let index = currentDate.formatted(Date.FormatStyle().weekday(.wide))
        if index == "Sunday" {
            return 6
        } else if index == "Monday" {
            return 0
        } else if index == "Tuesday" {
            return 1
        } else if index == "Wednesday" {
            return 2
        } else if index == "Thursday" {
            return 3
        } else if index == "Friday" {
            return 4
        } else if index == "Saturday" {
            return 5
        }
        
        return 0
    }
    
    func setupFlowLayout() {
        let space: CGFloat = 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: 120, height: 120)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.kHomeHeaderCollectionViewCell, for: indexPath) as? HomeHeaderCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let dateCell = dates[indexPath.row]
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: dateCell)

        if let dayStr = components.day {
            let dateText = dateCell.formatted(Date.FormatStyle().weekday(.wide))
            cell.setupCell(monthText: dateText, dateText: dayStr.formatted())
        }
        
        if indexPath.row == indexOfWeekday() && indexSelected == -1 || indexPath.row == indexSelected {
            cell.setSelected()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            cell.setUnSelected()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexSelected = indexPath.row
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        didTapCell!(dates[indexPath.row])
    }

}
