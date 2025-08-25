//
//  MyActivityItemSource.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import UIKit
import LinkPresentation

class MyActivityItemSource: NSObject, UIActivityItemSource {
    
    var title: String
    var text: String
    var image: UIImage?
    
    init(title: String, text: String, image: UIImage?) {
        self.title = title
        self.text = text
        self.image = image
        
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        print("activityType: \(activityType?.rawValue ?? "null")")
        
        if activityType?.rawValue == "com.apple.UIKit.activity.CopyToPasteboard" {
            print("text.copy: \(text)")
            return text
        }
        
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.imageProvider = NSItemProvider(object: image!)
        metadata.iconProvider = NSItemProvider(object: image!)
        metadata.originalURL = URL(fileURLWithPath: text)
        
        return metadata
    }
}
