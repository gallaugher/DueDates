//
//  DetailView.swift
//  DueDates Test
//
//  Created by John Gallaugher on 11/14/26.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    let assignment: Assignment
    
    @State private var course = ""
    @State private var assignmentTitle = ""
    @State private var dueDate = Date()
    @State private var notes = ""
    @State private var isCompleted = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Course:")
                .bold()
            TextField("course", text: $course)
                .textFieldStyle(.roundedBorder)
            
            Text("Assignment Title:")
                .bold()
            TextField("assignment title", text: $assignmentTitle)
                .textFieldStyle(.roundedBorder)
            
            DatePicker("Due Date:", selection: $dueDate, displayedComponents: DatePickerComponents.date)
                .bold()
            
            Toggle("Completed:", isOn: $isCompleted)
                .bold()
            
            Text("Notes:")
                .bold()
            TextField("notes", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            
        }
        .font(.title2)
        .padding(.horizontal)
        .onAppear {
            course = assignment.course
            assignmentTitle = assignment.title
            dueDate = assignment.dueDate
            notes = assignment.notes
            isCompleted = assignment.isCompleted
        }
        
        .navigationBarBackButtonHidden() // we supply our own Cancel and checkmark buttons
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) { // iOS 26+: the role supplies the system label
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) { // the prominent checkmark
                    saveData()
                }
                .disabled(assignmentTitle.isEmpty)
            }
        }
    }
    
    func saveData() {
        // Copy the edited fields back into the assignment, put it in the container, and save
        assignment.course = course
        assignment.title = assignmentTitle
        assignment.dueDate = dueDate
        assignment.isCompleted = isCompleted
        assignment.notes = notes
        modelContext.insert(assignment) // no effect if this asignment is already saved — needed for a new one
        do {
            try modelContext.save() // SwiftData would save on its own eventually; saving now makes the change immediate
            dismiss()
        } catch {
            print("😡 ERROR: Could not save \(assignment.title). \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(assignment: Assignment(course: "Swift", title: "Final Project", notes: "Build something I'm proud to show off."))
            .modelContainer(for: Assignment.self, inMemory: true)
    }
}
