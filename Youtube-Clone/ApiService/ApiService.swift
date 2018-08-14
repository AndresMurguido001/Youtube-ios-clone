//
//  ApiService.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/13/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    
    func fetchVideos(completion: @escaping ([Video]) -> ()){
            let getSongsUrl = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
            URLSession.shared.dataTask(with: getSongsUrl!) { (data, response, error) in
                if error != nil {
                    print("Error making request")
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    var videos = [Video]()
                    for dictionary in json as! [[String : AnyObject]] {
                        
                        let video = Video()
                        video.title = dictionary["title"] as? String
                        video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                        let channel = Channel()
                        let channelDictionary = dictionary["channel"] as! [String : AnyObject]
                        channel.name = channelDictionary["name"] as? String
                        channel.profileImageName = channelDictionary["profile_image_name"] as? String
                        video.channel = channel
                        videos.append(video)
                    }
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
                
                
                
                }.resume()
            
            
            
            
            
            
        }
    

}
