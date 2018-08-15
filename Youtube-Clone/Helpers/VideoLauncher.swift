//
//  VideoLauncher.swift
//  Youtube-Clone
//
//  Created by andres murguido on 8/14/18.
//  Copyright © 2018 andres murguido. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
       let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let pausePlayButton: UIButton = {
       let button = UIButton(type: UIButtonType.system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    var isPlaying = false
    
    @objc func handlePause(){
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState.normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState.normal)
        }
        isPlaying = !isPlaying

    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        setupPlayerView()
        
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicatorView)
        controlsContainerView.addSubview(pausePlayButton)
        
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    var player: AVPlayer?
    private func setupPlayerView(){
        let urlString = "https://s3.amazonaws.com/singlevideo/IMG_0098.MOV"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    
    func videoStarted() -> Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" && videoStarted() {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            pausePlayButton.isHidden = false
            isPlaying = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    func showVideoPlayer(){
        print("Showing video player animation")
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { (completedAnimation) in
                //do something later
                UIApplication.shared.isStatusBarHidden = true
            }
            
            keyWindow.addSubview(view)
        }
    }
}
