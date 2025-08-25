//
//  AudioFile.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import Foundation

public struct AudioFile {
    
    var filename: String?
    var extensionName: String?
    var bundle: Bundle?
    var url: URL?
    var identifier: String?
    
    public init(filename: String, extensionName: String, bundle: Bundle? = nil) {
        self.filename = filename
        self.extensionName = extensionName
        let bundle = bundle ?? Bundle.main
        self.bundle = bundle
        self.url = bundle.url(forResource: filename, withExtension: extensionName)
    }
    
    public init(url: URL) {
        self.url = url
    }
}
