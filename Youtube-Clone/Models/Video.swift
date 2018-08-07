//
//  Video.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/7/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
