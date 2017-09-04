## Notes App

The Notes app is a simple client/server application entirely written in Swift, with shared business logic. The reason for creating this application was to experiment with the posibilities of server-side Swift using the Kitura framework and shared business logic between client and server.

## Requirements

- **XCode 8.x**
- **Swift 3.1**

## Installing

```
git clone git@github.com:dimitryz/Notes.git
cd Notes
./install.sh
open Notes.xcworkspace
```

That should install all of the necessasry packages for both the _NotesServer_ and _NotesShared_ projects. The dependancies of the _NotesApp_ project are bundled with the source code.

## Running

Start by opening the _Notes.xcworkspace_ with XCode 8.x.

Running the application is a two step process. First, in XCode, you have to run the _NotesServer_ project using _Mac_ as the device. After that launches, you have to run the _NotesApp_ project using any of the iPhone simulators. Please note that the app was built for the iOS 10 simulator and not tested on an actual device.

## What does it do?

The project is a note taking app. Once the _NotesServer_ is booted up, it contains 3 notes. The user can then use the application to create additional notes or delete the notes that are on the server. It's also possible to modify existing notes. Any note that has no content is deleted.

All of the content is held in memory while the _NotesServer_ project is running. There is no permanent storage mechanism. Therefore, killing the _NotesServer_ will delete all notes stored in memory.

## License

The MIT License

Copyright (c) 2017 Dimitry Zolotaryov. http://webit.ca

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
