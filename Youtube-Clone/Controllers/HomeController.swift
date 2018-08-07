//
//  ViewController.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/7/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video] = {
        var drakeChannel = Channel()
        drakeChannel.name = "Drake"
        drakeChannel.profileImageName = "user"
        
       var godsPlan = Video()
        godsPlan.title = "Drake - Gods Plan"
        godsPlan.thumbnailImageName = "DrakeVevo5-GodsPlan"
        godsPlan.channel = drakeChannel
        godsPlan.numberOfViews = 1675340
        
        var whatsMyName = Video()
        whatsMyName.thumbnailImageName = "DrakeVevo4-WhatsMyName"
        whatsMyName.title = "Drake - Whats My Name featuring Rihanna"
        whatsMyName.channel = drakeChannel
        whatsMyName.numberOfViews = 2567030
        return [godsPlan, whatsMyName]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos[indexPath.item]
        
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
        navigationItem.rightBarButtonItems = [moreButton, searchBarButton]
    }
    @objc func handleMore(_ sender: UIBarButtonItem){
        print("More")
    }
    @objc func handleSearch(_ sender: UIBarButtonItem){
        print(123)
    }
}


