//
//  AddItemView.swift
//  ToDoFirebase
//
//  Created by meshal alkhozaei on 26/04/2024.
//

import SwiftUI

struct AddItemView: View {
    @State private var title = ""
    @State private var info = ""
    @State private var dueDate = Date()
    //@State private var isDone = false
    @State private var showingError = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var firebaseManager: FirebaseManager
    var category: Category
    var body: some View {
        NavigationStack {
            Form {
                    Section(footer: Text(showingError ? "Title and details must be filled in" : "Title your task to spotlight your priorities.")
                        .foregroundStyle(showingError ? .red : .gray)){
                    TextField("title" , text: $title)
                    TextField("Description" , text: $info)

                    DatePicker("Date", selection: $dueDate, in: Date()...)
                }

                Section() {
                    Button("Add Task") {
                        if !title.isEmpty && !info.isEmpty {
                            let item =  Item(id: UUID().uuidString, title: title, info: info, dueDate: dueDate)
                            Task {
                                try await firebaseManager.createItem(item, category)
                                try? await firebaseManager.fetchItems(category)
                            }
                        dismiss()
                           
                        } else {
                            showingError = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

            }.navigationTitle("Add Task")


        }
    }
}

#Preview {
    AddItemView(category: Category(id: "", name: ""))
        .environmentObject(FirebaseManager())
}

