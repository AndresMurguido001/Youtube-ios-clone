//
//  SubscriptionCell.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/14/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchVideosForSubscriptions { (video) in
            self.videos = video
            self.collectionView.reloadData()
        }
    }
}
