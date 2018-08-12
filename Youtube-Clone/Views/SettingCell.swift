//
//  SettingCell.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/12/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImage.tintColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            if let cellimage = setting?.imageName {
                iconImage.tintColor = UIColor.black
                iconImage.image = UIImage(named: cellimage)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "settingsOne")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addSubview(iconImage)
        
        addContraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImage, nameLabel)
        addContraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        iconImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}
