//
//  W_PhotoModel+CoreDataProperties.swift
//  Wallpee
//
//  Created by Thanh Hoang on 15/6/24.
//
//

import Foundation
import CoreData


extension W_PhotoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<W_PhotoModel> {
        return NSFetchRequest<W_PhotoModel>(entityName: "W_PhotoModel")
    }

    @NSManaged public var id: NSNumber
    @NSManaged public var width: NSNumber
    @NSManaged public var height: NSNumber
    @NSManaged public var url: String
    @NSManaged public var alt: String
    @NSManaged public var liked: Bool
    
    @NSManaged public var portrait: String
    @NSManaged public var landscape: String
    @NSManaged public var original: String
    @NSManaged public var large2x: String
    @NSManaged public var large: String
    @NSManaged public var medium: String
    @NSManaged public var small: String
    
    @NSManaged public var coin: NSNumber
    @NSManaged public var unlock: Bool
    @NSManaged public var downloaded: Bool
    @NSManaged public var createdTime: String
    
}

extension W_PhotoModel : Identifiable {

}
