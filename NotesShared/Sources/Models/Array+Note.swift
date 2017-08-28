//
//  Array+Note.swift
//  NotesShared
//
//  Created by Dimitry Zolotaryov on 2017-08-27.
//

import Foundation
import SwiftyJSON

public extension Array where Element == Note {
    
    public var json: JSON {
        return JSON(map { $0.json })
    }
    
    public init?(json: JSON) {
        guard let array = json.array else { return nil }
        
        self.init()
        
        for json in array {
            guard let note = Note(json: json) else { continue }
            append(note)
        }
    }
    
    public func nextKey() -> Int {
        var maxKey: Int = 0
        for note in self {
            guard let key = note.key else { continue }
            maxKey = Swift.max(maxKey, key)
        }
        return maxKey + 1
    }
    
    public mutating func removeForKey(_ key: Int) -> Note? {
        if let index = index(where: { $0.key == key }) {
            return remove(at: index)
        } else {
            return nil
        }
    }
}
