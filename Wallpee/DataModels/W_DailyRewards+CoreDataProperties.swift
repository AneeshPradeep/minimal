//
//  W_DailyRewards+CoreDataProperties.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//
//

import Foundation
import CoreData


extension W_DailyRewards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<W_DailyRewards> {
        return NSFetchRequest<W_DailyRewards>(entityName: "W_DailyRewards")
    }

    @NSManaged public var title: String
    @NSManaged public var coin: NSNumber
    @NSManaged public var createdTime: String
    @NSManaged public var earn: Bool
    @NSManaged public var type: String

}

extension W_DailyRewards : Identifiable {

}
