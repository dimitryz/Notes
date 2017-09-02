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
    
    static let cellIdentifier = "Cell"
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = .current
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if notes == nil {
            self.fetchNotes()
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if let dequeued = tableView.dequeueReusableCell(withIdentifier: NotesViewController.cellIdentifier) {
            cell = dequeued
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: NotesViewController.cellIdentifier)
        }
        
        if let note = notes?[indexPath.row] {
            cell.textLabel?.text = note.note
            cell.detailTextLabel?.text = NotesViewController.dateFormatter.string(from: note.date)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let notes = notes {
            showNote(notes[indexPath.row])
        }
    }
    
    // MARK: - Private
    
    fileprivate var notes: [Note]? = nil
    
    private let noteDataSource = NoteDataSource()
    
    private var noteFetchAllDataTask: URLSessionDataTask?
    
    private func fetchNotes() {
        noteFetchAllDataTask?.cancel()

        noteFetchAllDataTask = noteDataSource.fetchAll() { [weak self] (notes, error) in
            guard let strongSelf = self else { return }
            guard error == nil else { strongSelf.handleDataSourceError(error!); return }
            
            DispatchQueue.main.async {
                strongSelf.notes = notes
                strongSelf.tableView.reloadData()
            }
        }
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
    
    private func showNote(_ note: Note) {
        let ctrl = NoteViewController()
        ctrl.note = note
        ctrl.delegate = self
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

extension NotesViewController: NoteViewControllerDelegate {
    
    func noteViewController(noteViewController: NoteViewController, didSaveNote note: Note) {
        guard
            let notes = self.notes,
            let key = note.key,
            let index = notes.indexForKey(key)
            else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
