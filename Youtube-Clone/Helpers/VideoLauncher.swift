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
    
    let relatedVideos: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .yellow
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
            pausePlayButton.setImage(UIImage(named: "pause"), for: UIControlState.normal)
            pausePlayButton.tintColor = .white
            animatePlayPauseButton()
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "play"), for: UIControlState.normal)
            self.pausePlayButton.tintColor = .white
            animatePlayPauseButton()
        }
        isPlaying = !isPlaying

    }
    func animatePlayPauseButton(){
        UIView.animate(withDuration: 1.0) {
            let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.pausePlayButton.transform = scale
            self.pausePlayButton.tintColor = .clear
        }
        pausePlayButton.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    let videoLengthLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let videoSlider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.thumbTintColor = .red
        slider.setThumbImage(UIImage(named: "circle"), for: .normal)
        slider.maximumTrackTintColor = .white
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()

    @objc func handleSliderChange() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let seekValue = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(seekValue), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //do Something later
            })
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        setupPlayerView()
        setupGradientLayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicatorView)
        controlsContainerView.addSubview(pausePlayButton)
        
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        
        
        
        
        
        
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
            //track progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressingTime) in
                let seconds = CMTimeGetSeconds(progressingTime)
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutes = String(format: "%02d", Int(seconds) / 60)
                self.currentTimeLabel.text = "\(minutes):\(secondsString)"
                //move slider
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
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
            UIView.animate(withDuration: 1.0) {
                self.pausePlayButton.tintColor = .clear
                return
            }
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                let secondsText = Int(seconds) % 60
                
                let minutes = String(format: "%02d", Int(seconds) / 60)
                
                videoLengthLabel.text = "\(minutes):\(secondsText)"
            }
             
            
        }
    }
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
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
            
            let layout = UICollectionViewFlowLayout()
            let relatedView = Related(frame: CGRect(x: 0, y: videoPlayerView.frame.height, width: keyWindow.frame.width, height: keyWindow.frame.height - videoPlayerView.frame.height), collectionViewLayout: layout)
            view.addSubview(relatedView)
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
