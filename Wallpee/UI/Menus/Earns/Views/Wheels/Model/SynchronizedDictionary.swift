//
//  SynchronizedDictionary.swift
//  Wallpee
//
//  Created by Thanh Hoang on 22/6/24.
//

import Foundation

class SynchronizedDictionary<KeyType: Hashable, ValueType> {
    
    private var dictionary: [KeyType:ValueType] = [:]
    private let queue = DispatchQueue(label: "com.downloader.SynchronizedDictionaryAccess", attributes: .concurrent)
    
    public func removeValue(forKey: KeyType) {
        queue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: forKey)
        }
    }
    
    public subscript(key: KeyType) -> ValueType? {
        set {
            queue.async(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
        get {
            var element: ValueType?
            queue.sync {
                element = self.dictionary[key]
            }
            return element
        }
    }
    
    public func clear() {
        queue.async(flags: .barrier) {
            self.dictionary.removeAll()
        }
    }
}
