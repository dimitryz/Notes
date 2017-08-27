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

// Retrieves all notes
router.get("/notes") { request, response, next in
    response.send(json: notes.json)
    next()
}

// Adds the body parser
router.post("/notes", middleware: BodyParser())

// Creates a new note and returns it
router.post("/notes") { request, response, next in
    guard
        let json = request.body?.asJSON,
        var note = Note(json: json)
        else { next(); return }
    
    lock() {
        note.key = notes.nextKey()
        notes.append(note) 
        response.send(json: note.json)
    }
    next()
}

// Delete a post

// Starts the Kitura server
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
