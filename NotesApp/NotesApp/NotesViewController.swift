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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if notes == nil {
            self.fetchNotes()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let noteToUpdate = noteToUpdate {
            updateUIForNote(note: noteToUpdate)
            self.noteToUpdate = nil
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
            if note.note.isEmpty {
                cell.textLabel?.text = "Note is empty"
                cell.textLabel?.textColor = UIColor.darkText.withAlphaComponent(0.3)
            } else {
                cell.textLabel?.text = note.note
                cell.textLabel?.textColor = UIColor.darkText
            }
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Delete", handler: { [weak self] (action, indexPath) in
            self?.deleteNote(index: indexPath.row)
        })]
    }
    
    // MARK: - Private
    
    fileprivate var notes: [Note]? = nil
    
    fileprivate var noteToUpdate: Note?
    
    private let noteDataSource = NoteDataSource()
    
    private var noteFetchAllDataTask: URLSessionDataTask?
    
    fileprivate func addNote() {
        showNote(Note())
    }
    
    fileprivate func deleteNote(index: Int) {
        guard
            let notes = notes,
            index < notes.count
            else { return }
        
        _ = noteDataSource.delete(note: notes[index]) { [weak self] (note, error) in
            if let error = error {
                self?.showError(error: error)
            } else {
                self?.notes?.remove(at: index)
                self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .top)
            }
        }
    }
    
    private func fetchNotes() {
        noteFetchAllDataTask?.cancel()

        noteFetchAllDataTask = noteDataSource.fetchAll() { [weak self] (notes, error) in
            guard let strongSelf = self else { return }
            guard error == nil else { strongSelf.handleDataSourceError(error!); return }
            
            strongSelf.notes = notes
            strongSelf.tableView.reloadData()
        }
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
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func showNote(_ note: Note) {
        let ctrl = NoteViewController()
        ctrl.note = note
        ctrl.delegate = self
        navigationController?.pushViewController(ctrl, animated: true)
    }
    
    private func updateUIForNote(note: Note) {
        guard let key = note.key else { return }
        
        if let index = notes?.indexForKey(key) {
            notes?[index] = note
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        } else if self.notes != nil {
            notes?.insert(note, at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }
}

// MARK: - Actions

extension NotesViewController {
    
    func addButtonTapped() {
        addNote()
    }
}

// MARK: - Delegate

extension NotesViewController: NoteViewControllerDelegate {
    
    func noteViewController(_ noteViewController: NoteViewController, didSaveNote note: Note) {
        noteToUpdate = note
    }
}
