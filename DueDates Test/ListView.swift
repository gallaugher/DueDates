//
//  ContentView.swift
//  DueDates Test
//
//  Created by John Gallaugher on 11/14/26.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Query(sort: \Assignment.dueDate) private var assignments: [Assignment]
    @State private var sheetIsPresented = false
    @Environment(\.modelContext) private var modelContext // the "desk" where we add and delete
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(assignments) { assignment in
                    NavigationLink {
                        DetailView(assignment: assignment)
                    } label: {
                        HStack {
                            Image(systemName: assignment.isCompleted ? "checkmark.square" : "square")
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text(assignment.title)
                                    .font(.title2)
                                Text(assignment.course)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(assignment.dueDate.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            deleteData(assignment: assignment)
                        }
                        Button("Done", systemImage: "checkmark") {
                            toggleCompleted(assignment: assignment)
                        }
                        .tint(.green)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Due Dates:")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", systemImage: "plus") {
                        sheetIsPresented = true
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack { // a sheet needs its own NavigationStack or its toolbar won't show
                    DetailView(assignment: Assignment()) // a brand-new, blank item
                }
            }
        }
    }
    
    func deleteData(assignment: Assignment) {
        modelContext.delete(assignment)
        do {
            try modelContext.save()
        } catch {
            print("😡 ERROR: Could not save after deleting \(assignment.title). \(error.localizedDescription)")
        }
    }
    
    func toggleCompleted(assignment: Assignment) {
        assignment.isCompleted.toggle() // Could also use an if/else statement here
        do {
            try modelContext.save()
        } catch {
            print("😡 ERROR: Could not save \(assignment.title). \(error.localizedDescription)")
        }
    }
}

#Preview {
    ListView()
        .modelContainer(Assignment.preview)
}
