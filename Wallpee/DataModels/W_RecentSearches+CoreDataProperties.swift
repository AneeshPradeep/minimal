//
//  W_RecentSearches+CoreDataProperties.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//
//

import Foundation
import CoreData


extension W_RecentSearches {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<W_RecentSearches> {
        return NSFetchRequest<W_RecentSearches>(entityName: "W_RecentSearches")
    }

    @NSManaged public var keyword: String
    @NSManaged public var createdTime: String

}

extension W_RecentSearches : Identifiable {

}
