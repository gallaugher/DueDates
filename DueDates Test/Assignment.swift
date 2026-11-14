//
//  Assignment.swift
//  DueDates Test
//
//  Created by John Gallaugher on 11/14/26.
//

import Foundation
import SwiftData

@Model // required when working with SwiftData models
class Assignment {
    var course = ""
    var title = ""
    var dueDate = Date()
    var notes = ""
    var isCompleted = false
    
    init(course: String = "", title: String = "", dueDate: Date = Date(), notes: String = "", isCompleted: Bool = false) {
        self.course = course
        self.title = title
        self.dueDate = dueDate
        self.notes = notes
        self.isCompleted = isCompleted
    }
}

extension Assignment {
    @MainActor
    static var preview: ModelContainer {
        do {
            let container = try ModelContainer(for: Assignment.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            container.mainContext.insert(Assignment(
                course: "Swift", title: "Mid-Term II",
                dueDate: Date.now,
                notes: "Open slides, open files, no AI. I've got this."))
            container.mainContext.insert(Assignment(
                course: "Finance", title: "Problem Set 9",
                dueDate: Date.now.addingTimeInterval(86400 * 2),
                notes: "Bond pricing. Bring a calculator."))
            container.mainContext.insert(Assignment(
                course: "Perspectives", title: "Plato's Cave Paper",
                dueDate: Date.now.addingTimeInterval(86400 * 7),
                notes: "Five pages. Am I the one in the cave?"))
            container.mainContext.insert(Assignment(
                course: "Marketing", title: "Group Slides",
                dueDate: Date.now.addingTimeInterval(-86400 * 3),
                notes: "I did most of the work.", isCompleted: true))
            container.mainContext.insert(Assignment(
                course: "Statistics", title: "Regression HW",
                dueDate: Date.now.addingTimeInterval(-86400),
                notes: "Oops. Ask for an extension."))

            return container
        } catch {
            // fatalError stops the app on purpose. It is only acceptable here, in preview
            // sample data that never ships to a user: if this fails, the developer set it up wrong.
            fatalError("😡 ERROR: Could not create the preview ModelContainer. \(error.localizedDescription)")
        }
    }
}
