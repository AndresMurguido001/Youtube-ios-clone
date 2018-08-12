//
//  SettingsController.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/12/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let overlay = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight = 50
    
    let settingsArr: [Setting] = {
        return [Setting(name: "Settings", imageName: "settingsOne"), Setting(name: "Terms & Privacy Policy", imageName: "locked"), Setting(name: "Send Feedback", imageName: "feedback"), Setting(name: "Help", imageName: "info"), Setting(name: "Switch Account", imageName: "userOne"), Setting(name: "Cancel", imageName: "cancel")]
    }()
    
    @objc func showSettings(){
        // handle more
        if let window = UIApplication.shared.keyWindow {
            
            overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(overlay)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settingsArr.count * cellHeight)
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            overlay.frame = window.frame
            
            overlay.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.overlay.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.overlay.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
             self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settingsArr[indexPath.row]
        
        cell.setting = setting
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
}
