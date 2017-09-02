import Foundation
import Kitura
import NotesShared

// Keeps a list of notes
var notes: [Note] = [
    Note(key: 1, note: "Create a notes app", date: Date(timeInterval: -3600, since: Date())),
    Note(key: 2, note: "Document the notes app", date: Date(timeInterval: -1800, since: Date())),
    Note(key: 3, note: "Don't forget the groceries", date: Date())
]

// The router
let router = Router()

// Adds the body parser
router.all(middleware: BodyParser())

// Retrieves all notes
router.get("/notes") { request, response, next in
    response.send(json: notes.json)
    next()
}

// Creates a new note and returns it
router.post("/notes") { request, response, next in
    guard
        let json = request.body?.asJSON,
        var note = Note(json: json)
        else { next(); return }
    
    lock() {
        note.key = notes.nextKey()
        notes.append(note)
    }
    
    response.send(json: note.json)
    next()
}

// Updates an existing note
router.post("/notes/:key") { request, response, next in
    guard
        let keyString = request.parameters["key"],
        let key = Int(keyString),
        let noteText = request.body?.asJSON?["note"].string
        else { next(); return }
    
    var note: Note?
    
    lock() {
        if let index = notes.indexForKey(key) {
            note = notes[index]
            note!.note = noteText
            notes[index] = note!
        }
    }
    
    if note != nil {
        response.send(json: note!.json)
    }
    
    next()
}

// Delete a post
router.delete("/notes/:key") { request, response, next in
    guard
        let keyString = request.parameters["key"],
        let key = Int(keyString)
        else { next(); return }
    
    var note: Note? = nil
    
    lock() {
        note = notes.removeForKey(key)
    }
    
    if note != nil {
        response.send(json: note!.json)
    }
    next()
}

// Starts the Kitura server
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
