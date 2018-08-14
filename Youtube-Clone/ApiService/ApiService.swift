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
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideosForHome(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completion: completion)
    }
    func fetchVideosForTrending(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
        }
    
    func fetchVideosForSubscriptions(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let getSongsUrl = URL(string: urlString)
        URLSession.shared.dataTask(with: getSongsUrl!) { (data, response, error) in
            if error != nil {
                print("Error making request")
            }
            do {
                var videos = [Video]()
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String : AnyObject]] {
                        for dictionary in jsonDictionaries {
                            let video = Video()
                    
                            video.title = dictionary["title"] as? String
                            video.thumbnail_image_name = dictionary["thumbnail_image_name"] as? String
                            video.number_of_views = dictionary["number_of_views"] as? NSNumber
                            
                            let channelDictionary = dictionary["channel"] as! [String : AnyObject]
                            
                            let channel = Channel()
                            
                            channel.name = channelDictionary["name"] as? String
                            channel.profile_image_name = channelDictionary["profile_image_name"] as? String
                            video.channel = channel
                            videos.append(video)
                        }
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

//let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//var videos = [Video]()
//for dictionary in json as! [[String : AnyObject]] {
//
//    let video = Video()
//    video.title = dictionary["title"] as? String
//    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
//    let channel = Channel()
//    let channelDictionary = dictionary["channel"] as! [String : AnyObject]
//    channel.name = channelDictionary["name"] as? String
//    channel.profileImageName = channelDictionary["profile_image_name"] as? String
//    video.channel = channel
//    videos.append(video)
//}
//DispatchQueue.main.async {
//    completion(videos)
//}



