//
//  VideoView.swift
//  iBOCA
//
//  Created by hdwebsoft on 7/11/19.
//  Copyright © 2019 sunspot. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol VideoViewDelegate {
    func videoDidFinishPlaying()
}

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var delegate: VideoViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func config(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType:"mov") else {
            debugPrint("video not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resize
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
        if let playerLayer = self.playerLayer {
            playerLayer.removeFromSuperlayer()
        }
        delegate?.videoDidFinishPlaying()
    }
    
    func isPlaying() -> Bool {
        return player?.timeControlStatus == AVPlayer.TimeControlStatus.playing
    }
    
    @objc func playerDidFinishPlaying() {
        if let playerLayer = self.playerLayer {
            playerLayer.removeFromSuperlayer()
        }
        delegate?.videoDidFinishPlaying()
    }
}
