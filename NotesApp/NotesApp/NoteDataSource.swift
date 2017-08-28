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
            
            callback(notes, nil)
        }
    }
    
    func save(text: String, callback: @escaping (Note?, NoteDataSourceError?) -> Void) -> URLSessionDataTask {
        return dataTask("/", method: .post) { data, error in
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
        callback: @escaping (Data?, NoteDataSourceError?) -> Void) -> URLSessionDataTask
    {
        var urlRequest = URLRequest(url: url(path))
        urlRequest.httpMethod = method.rawValue
        
        let task = session().dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                callback(nil, .networkError(error: error))
            } else {
                callback(data, nil)
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
