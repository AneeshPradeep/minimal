//
//  AudioPlayer.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    /// A class that plays buffers or segments of audio files
    let node = AVAudioPlayerNode()
    
    /// Audio player state
    var state: State = State.idle()
    
    func play(_ file: AVAudioFile, identifier: SoundIdentifier) {
        node.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { [weak self] callbackType in
            self?.didCompletePlayback(for: identifier)
        }
        
        state = State(sound: identifier, status: .playing)
        node.play()
    }
    
    func stop() {
        node.stop()
    }
    
    /// Called when Audio player completed playback
    /// - Parameter sound: Sound identifier which is completed
    func didCompletePlayback(for sound: SoundIdentifier) {
        state = State.idle()
    }
}

extension AudioPlayer {
    
    enum Status {
        case idle
        case playing
        case looping
    }
}

extension AudioPlayer {
    
    struct State {
        /// An audio player sound identifier used to play sound by identifier
        let sound: SoundIdentifier?
        
        /// Audio player's  current status
        let status: Status
        
        /// Puts the audio player on idle status
        /// - Returns: self
        static func idle() -> State {
            return State(sound: nil, status: .idle)
        }
    }
}
