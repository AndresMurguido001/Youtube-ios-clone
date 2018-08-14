//
//  TrendingCellCollectionViewCell.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/14/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class TrendingCellCollectionViewCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchVideosForTrending { (video) in
            self.videos = video
            self.collectionView.reloadData()
        }
    }
    
}
