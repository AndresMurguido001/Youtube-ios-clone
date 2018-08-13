//
//  SettingsController.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/12/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Cancel = "Cancel"
    case Setting = "Settings"
    case Terms = "Terms & Privacy Policy"
    case Feedback = "Send Feedback"
    case Help = "Help"
    case Account = "Switch Account"
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
        let cancelSetting = Setting(name: .Cancel, imageName: "cancel")
        let settingSetting = Setting(name: .Setting, imageName: "settingsOne")
        let termsSetting = Setting(name: .Terms, imageName: "locked")
        let feedbackSetting = Setting(name: .Feedback, imageName: "feedback")
        let helpSetting = Setting(name: .Help, imageName: "info")
        let accountSetting = Setting(name: .Account, imageName: "userOne")
        return [settingSetting, termsSetting, feedbackSetting, helpSetting, accountSetting, cancelSetting]
    }()
    
    var homeController: HomeController?
    
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
    @objc func handleDismiss(setting: Setting){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.overlay.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completed: Bool) in
            if setting.name != .Cancel {
                self.homeController?.showControllerForSettings(setting: setting)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleDismiss(setting: settingsArr[indexPath.item])
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
}
