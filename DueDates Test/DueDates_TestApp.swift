//
//  DueDates_TestApp.swift
//  DueDates Test
//
//  Created by John Gallaugher on 11/14/26.
//

import SwiftUI
import SwiftData

@main
struct DueDates_TestApp: App {
    var body: some Scene {
        WindowGroup {
            ListView()
                .modelContainer(for: Assignment.self)
        }
    }
    
    // Will allow us to find where our simulator datea is saved:
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
