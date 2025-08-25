//
//  Array+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import Foundation

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }
        
        return self[index]
    }
}
