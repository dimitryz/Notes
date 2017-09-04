//
//  Note.swift
//  NotesShared
//
//  Created by Dimitry Zolotaryov on 2017-08-26.
//

import Foundation
import SwiftyJSON

public struct Note {
    
    // MARK: - Public
    
    public var key: Int?
    public var note: String
    public let date: Date
    
    // Initializer
    
    public init() {
        self.init(key: nil, note: "", date: Date())
    }

    public init(key: Int?, note: String, date: Date) {
        self.key = key
        self.note = note
        self.date = date
    }
    
    // Serialization / deserialization
    
    public init?(json: JSON) {
        guard
            let note = json["note"].string,
            let dateString = json["date"].string,
            let date = Note.dateFormatter.date(from: dateString)
            else { return nil }
        
        self.key = json["key"].int
        self.note = note
        self.date = date
    }
    
    public var json: JSON {
        var dict: [String: Any] = [
            "note": note,
            "date": Note.dateFormatter.string(from: date)
        ]
        
        if let key = key {
            dict["key"] = key
        }
        
        return JSON(dict)
    }
    
    // MARK: - Internal
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
}
