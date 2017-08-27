import Kitura
import NotesShared

// Keeps a list of notes
var notes: [Note] = []

// The router
let router = Router()

// Retrieves all notes
router.get("/notes") { request, response, next in
    next()
}

// Creates a new note and returns it
router.post("/notes") { request, response, next in
    next()
}

// Starts the Kitura server
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
