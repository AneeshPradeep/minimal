//
//  AudioError.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import Foundation

enum AudioError: Error {
    case resourceNotFound(name: String)
    case invalidSoundIdentifier(name: String)
    case audioLoadingFailure
}


extension AudioError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .resourceNotFound(let name):
            return "Resource not found '\(name)'"
            
        case .invalidSoundIdentifier(let name):
            return "Invalid identifier. No sound loaded named '\(name)'"
            
        case .audioLoadingFailure:
            return "Could not load audio data"
        }
    }
}
