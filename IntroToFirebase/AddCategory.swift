//
//  AddCategory.swift
//  IntroToFirebase
//
//  Created by meshal alkhozaei on 18/10/1445 AH.
//


import SwiftUI

struct AddCategory: View {
    @State private var categoryTitle = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var firebaseManager: FirebaseManager
    
    var body: some View {
        NavigationStack {
            Spacer()
            VStack{
                TextField("Category" , text: $categoryTitle)
            }
            Spacer()
            .padding()
            Section() {
                Button("Add Category") {
                    let cat = Category(id: UUID().uuidString, name: categoryTitle)
                    Task {
                        try await firebaseManager.createCategory(cat)
                        try? await firebaseManager.fetchCategories()
                    }
                    dismiss()
                    
                }
                Spacer()
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Add Category")
        }
    }
}

#Preview {
    AddCategory()
}

