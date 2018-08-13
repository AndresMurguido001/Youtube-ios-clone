//
//  ViewController.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/7/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
    
    let getSongsUrl = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    func fetchVideos(){
        URLSession.shared.dataTask(with: getSongsUrl!) { (data, response, error) in
            if error != nil {
                print("Error making request")
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                self.videos = [Video]()
                for dictionary in json as! [[String : AnyObject]] {
                    
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    let channel = Channel()
                    let channelDictionary = dictionary["channel"] as! [String : AnyObject]
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    video.channel = channel
                    self.videos?.append(video)
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            
            } catch let jsonError {
                print(jsonError)
            }
            

            
        }.resume()
        
        
            
            
        
           
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVideos()
        navigationItem.title = "Home"
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 255, green: 32, blue: 31)
        //Getting rid of black bar underneath nav
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView =  titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        setupMenubar()
        setupNavbarButtons()
    }
    
    let menubar: Menubar = {
        let mb = Menubar()
        
        return mb
    }()
    
    private func setupMenubar(){
        view.addSubview(menubar)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: menubar)
        view.addContraintsWithFormat(format: "V:|[v0(50)]|", views: menubar)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 32) * 9/16
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    func setupNavbarButtons(){
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        searchBarButton.tintColor = UIColor.white
        moreButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [moreButton, searchBarButton]
    }
    
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    
    @objc func handleMore(){
        settingsLauncher.homeController = self
        settingsLauncher.showSettings()
    }

    func showControllerForSettings(setting: Setting){
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    @objc func handleSearch(_ sender: UIBarButtonItem){
        print(123)
    }
}


