//
//  AudioPlayerManager.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/3/14.
//

import AVFoundation
import StreamingKit

class AudioPlayerManager: NSObject, ObservableObject {
    
    static let shared = AudioPlayerManager()
    
    var player: STKAudioPlayer!
    
    // 播放状态：false 未播放；true 播放中
    @Published var playing: Bool = false
        
    @Published var currentPath: String?
    
    typealias PlayCompleted = () -> Void
    var playCompleted: PlayCompleted?
    
    private override init() {
        super.init()
        player = STKAudioPlayer()
        player.delegate = self
        
        // 激活AVAudioSession，获取硬件资源(麦克风、扬声器)的使用，否则播放不出声音
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession")
        }
    }
}

extension AudioPlayerManager {
    
    func play(path: String, completed: PlayCompleted? = nil) {

        self.playCompleted = completed

        if self.currentPath == path, self.playing {
            self.stop()
        }else {
            self.player.play(path)
            self.currentPath = path
        }
    }
    
    func stop() {
        self.player.stop()
        self.currentPath = ""
    }
}

extension AudioPlayerManager: STKAudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        print("开始播放")
        self.playing = true
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        print("缓冲结束")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        print("播放状态切换", state, previousState)
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        print("结束播放")
        self.playing = false
        if let playCompleted = self.playCompleted {
            playCompleted()
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print("播放报错")
        self.playing = false
        if let playCompleted = self.playCompleted {
            playCompleted()
        }
    }
    
    
}
