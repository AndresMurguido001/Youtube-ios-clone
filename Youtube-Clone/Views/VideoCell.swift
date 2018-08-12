//
//  VideoCell.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/7/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
                setupThubnailImage()
                setupProfileImage()

            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let subTitleText = "\(channelName) • \(numberFormatter.string(from: numberOfViews)!) • 2 years ago"
                subtitleLabel.text = subTitleText
            }
            
            //measure title text
            if let videoTitle = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: videoTitle).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
            
        }
    }
    
    func setupThubnailImage(){
        if let thumbnailImageUrl = video?.thumbnailImageName {
           thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    func setupProfileImage() {
        if let userProfileImg = video?.channel?.profileImageName {
            userProfileImageView.loadImageUsingUrlString(urlString: userProfileImg)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "DrakeVevo1-Energy")
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let view = CustomImageView()
        view.image = UIImage(named: "drakeIcon")
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drake - Energy"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleLabel: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "DrakeVevo • 1,235,435 • 1 year ago"
        textView.textContainerInset = UIEdgeInsets(top: 1, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews(){
        addSubview(thumbnailImageView)
        addSubview(seperatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        //Horizontal Constraints
        addContraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addContraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        addContraintsWithFormat(format: "H:|-16-[v0(44)]|", views: userProfileImageView)
        //Vertical Constraints
        addContraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, seperatorView)
        
        //title Label top constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: thumbnailImageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8))
        //title label left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: userProfileImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 8))
        //title right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: thumbnailImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
        
        //title height
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        
        
        //SUBTITLE TEXT VIEW
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: titleLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 4))
        //subtitle label left constraint
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: userProfileImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 8))
        //subtitle right constraint
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: thumbnailImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
        //subtitle height
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 30))
        
    }
    
    
}



