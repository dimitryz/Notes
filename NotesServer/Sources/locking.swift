//
//  locking.swift
//  LoggerAPI
//
//  Created by Dimitry Zolotaryov on 2017-08-27.
//

import Dispatch
import Foundation

// A thread with unique write access to the notes
private let writeThread = DispatchQueue(label: "Write Queue")

func lock(block: () -> Void) {
    _ = writeThread.sync {
        block()
    }
}
