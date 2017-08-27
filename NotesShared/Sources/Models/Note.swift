//
//  Note.swift
//  NotesShared
//
//  Created by Dimitry Zolotaryov on 2017-08-26.
//

import Foundation

public struct Note {
    
    // MARK: - Public
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZ"
        return dateFormatter
    }()
    
    let key: Int?
    let note: String
    let date: Date
    
    // Initializer

    init(key: Int?, note: String, date: Date) {
        self.key = key
        self.note = note
        self.date = date
    }
    
    // Serialization / deserialization
    
    init?(dict: [String: Any?]) {
        guard
            let note = dict["note"] as? String,
            let dateString = dict["date"] as? String,
            let date = Note.dateFormatter.date(from: dateString)
            else { return nil }
        
        self.key = dict["key"] as? Int
        self.note = note
        self.date = date
    }
    
    var dict: [String: Any?] {
        return [
            "key": key,
            "note": note,
            "date": Note.dateFormatter.string(from: date)
        ]
    }
}
