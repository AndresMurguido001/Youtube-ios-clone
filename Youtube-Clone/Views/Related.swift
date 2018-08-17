//
//  Related.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/17/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class Related: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    let imagesArr = ["DrakeVevo1-Energy",
                     "DrakeVevo2-Interview",
                     "DrakeVevo3-How-bout-now",
                     "DrakeVevo4-WhatsMyName",
                     "DrakeVevo5-GodsPlan"
                     ]
    let titles = ["Drake - Energy", "Vevo Drake Interview", "Drake - How bout now", "Drake - Whats My Name?", "Drake - Gods Plan"]
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
        register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        delegate = self
        dataSource = self
        contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("# IN SECTION")
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("CELL FOR ITEM AT")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        cell.backgroundColor = .white
        cell.imageView.image = UIImage(named: imagesArr[indexPath.item])
        cell.textLabel.text = titles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height / 4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomCell: BaseCell {
    
    let textLabel: UILabel = {
       let label = UILabel()
        label.text = "Custom Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let subTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DrakeVevo 22K views"
        label.textColor = UIColor.gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    override func setupViews(){
        
        addSubview(textLabel)
        addSubview(imageView)
        addSubview(subTextLabel)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 3))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 4))
        
        addConstraint(NSLayoutConstraint(item: subTextLabel, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1, constant: 2))
        addConstraint(NSLayoutConstraint(item: subTextLabel, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 3))
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



