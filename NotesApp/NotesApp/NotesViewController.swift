//
//  NotesViewController.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-08-27.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import NotesShared
import UIKit

class NotesViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if notes == nil {
            self.fetchNotes()
        }
    }
    
    // MARK: - Private
    
    private var notes: [Note]? = nil
    
    private let noteDataSource = NoteDataSource()
    
    private var noteFetchAllDataTask: URLSessionDataTask?
    
    private func fetchNotes() {
        noteFetchAllDataTask?.cancel()

        noteFetchAllDataTask = noteDataSource.fetchAll() { [weak self] (notes, error) in
            guard let strongSelf = self else { return }
            guard error == nil else { strongSelf.handleDataSourceError(error!); return }
            
            strongSelf.notes = notes
            strongSelf.tableView.reloadData()
        }
    }
    
    private func saveNote(text: String) {
        
    }
    
    private func deleteNote(index: Int) {
        
    }
    
    private func handleDataSourceError(_ error: NoteDataSourceError) {
        let message: String
        
        switch error {
        case .missingKey:
            message = "Missing 'key' in note"
        case .networkError(let error):
            message = "Error communicating with server \(error)"
        case .parsingError:
            message = "Error parsing response"
        }
        
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alertView, animated: true)
    }
}
