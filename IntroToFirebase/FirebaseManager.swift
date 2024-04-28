//
//  FirebaseManager.swift
//  IntroToFirebase
//
//  Created by meshal alkhozaei on 14/10/1445 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Item: Codable, Identifiable{
    let id: String
    var title: String
    var info: String
    var isDone: Bool = false
    var dueDate: Date
    var timestamp: Date = .now
}
struct Category: Codable, Identifiable {
    var id: String
    var name: String
}

// NSObject = التطبيق اثناء يسوي رن يكون له اولولية انه يسوي اكسكيوت
class FirebaseManager: NSObject , ObservableObject{
    
    // اثناء الانشاء نسوي له اوفر رايد عشان يكون له اولوية قصوى
    
    
    let firestore: Firestore
    @Published var items: [Item] = []
    @Published var categories: [Category] = []
    
    override init() {
        self.firestore = Firestore.firestore()
        super.init()
    }
    
    // MARK: - delete data from DB
    func deleteItem(_ item: Item, _ category: Category) async throws {
        let documentRef = firestore.collection("category").document(category.id).collection("items").document(item.id)
        try await documentRef.delete()
    }
    // MARK: - delete category from DB
    func deleteCategory(_ category: Category) async throws {
        let documentRef = firestore.collection("category").document(category.id)
        try await documentRef.delete()
    }
    
    
    // MARK: - fetch data in category from DB
    func fetchCategories() async throws {
        let querySnapshot = try await firestore.collection("category").getDocuments()
        let categories = querySnapshot.documents.compactMap({try? $0.data(as: Category.self)})
        DispatchQueue.main.sync {
            self.categories = categories
        }
    }
    
    
    // MARK: - fetch data from DB
    func fetchItems(_ category: Category) async throws {
        let querySnapshot = try await firestore.collection("category").document(category.id).collection("items").getDocuments()
        let items = querySnapshot.documents.compactMap({try? $0.data(as: Item.self)})
        DispatchQueue.main.sync {
            self.items = items
        }
    }
    
    
    
    // MARK: - update item in the DB
    func updateItem(_ item: Item, _ category: Category){
        do {
            try firestore.collection("category")
                .document(category.id)
                .collection("items")
                .document(item.id)
                .setData(from: item)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - update category in the DB
    func updateCategory( _ category: Category){
        do {
            try  firestore.collection("category").document(category.id).setData(from: category)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Create Item
    
    func createItem(_ item : Item ,_ category: Category) async throws{
        
        //        let item = Item(title: "This is My title", info: "This is info", dueDate: .now)
        
        do {
            try firestore.collection("category").document(category.id).collection("items").document(item.id).setData(from: item)
        } catch {
            
        }
        
    }
    // MARK: - Create Category
    
    func createCategory(_ category: Category) async throws {
        do{
            try  firestore.collection("category").document(category.id).setData(from: category)
            print("done")
        }
        catch{
            print("failed")
            
        }
    }
}
