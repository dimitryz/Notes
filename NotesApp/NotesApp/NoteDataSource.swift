//
//  NoteDataSource.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-08-27.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import Foundation
import NotesShared
import SwiftyJSON

enum NoteDataSourceError: Error {
    case missingKey
    case networkError(error: Error)
    case parsingError
}

class NoteDataSource {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    func fetchAll(callback: @escaping ([Note]?, NoteDataSourceError?) -> Void) -> URLSessionDataTask {
        return dataTask("/notes", method: .get) { data, error in
            guard error == nil else {
                callback(nil, error)
                return
            }
            
            guard
                let data = data,
                let notes = [Note](json: JSON(data: data, options: .allowFragments))
                else
            {
                callback(nil, .parsingError)
                return
            }
            
            callback(notes.sortedReverseChronologically(), nil)
        }
    }
    
    func save(text: String, callback: @escaping (Note?, NoteDataSourceError?) -> Void) -> URLSessionDataTask {
        
        let newNote = Note(key: nil, note: text, date: Date())
        
        return dataTask("/notes", method: .post, payload: newNote.json) { data, error in
            guard error == nil else {
                callback(nil, error)
                return
            }
            
            guard
                let data = data,
                let note = Note(json: JSON(data: data))
                else
            {
                callback(nil, NoteDataSourceError.parsingError)
                return
            }
            
            callback(note, nil)
        }
    }
    
    func update(note: Note, callback: @escaping (Note, NoteDataSourceError?) -> Void) -> URLSessionDataTask? {
        guard let noteKey = note.key else {
            callback(note, .missingKey)
            return nil
        }
        
        return dataTask("/notes/\(noteKey)", method: .post, payload: note.json) { data, error in
            guard error == nil else {
                callback(note, error)
                return
            }
            
            callback(note, nil)
        }
    }
    
    func delete(note: Note, callback: @escaping (Note, NoteDataSourceError?) -> Void) -> URLSessionDataTask? {
        guard let noteKey = note.key else {
            callback(note, NoteDataSourceError.missingKey)
            return nil
        }
        
        return dataTask("/notes/\(noteKey)", method: .delete) { data, error in
            guard error == nil else {
                callback(note, error)
                return
            }
            
            callback(note, nil)
        }
    }
    
    // MARK: - Private
    
    private func dataTask(
        _ path: String,
        method: Method = .get,
        payload: JSON? = nil,
        callback: @escaping (Data?, NoteDataSourceError?) -> Void) -> URLSessionDataTask
    {
        var urlRequest = URLRequest(url: url(path))
        urlRequest.httpMethod = method.rawValue
        
        if let payload = payload {
            urlRequest.httpBody = try? payload.rawData()
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        }
        
        let task = session().dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    callback(nil, .networkError(error: error))
                } else {
                    callback(data, nil)
                }
            }
        }
        task.resume()
        return task
    }
    
    private func session() -> URLSession {
        return URLSession.shared
    }
    
    private func url(_ path: String) -> URL {
        return URL(string: "http://localhost:8080\(path)")!
    }
}
