//
//  ViewModel.swift
//  icalories
//
//  Created by Karlo Buhinjak on 24.06.2023..
//

import Foundation
import Firebase
import Combine
import SwiftUI
import FirebaseCore
import FirebaseFirestore



class ViewModel: ObservableObject{
    @AppStorage("uid") var userID: String = ""
    @Published var list: [Food_Details] = []
    private var cancellables: Set<AnyCancellable> = []
    private let dataSubject = PassthroughSubject<Void, Never>()
    
    init() {
            dataSubject
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
       
      
    
    func updateData(foodToUpdate: Food_Details, newName: String, newCalories: Int) {
        let db = Firestore.firestore()
        let documentRef = db.collection("food").document(foodToUpdate.id)

        documentRef.updateData([
            "food_name": newName,
            "calories": newCalories
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                DispatchQueue.main.async {
                    if let index = self.list.firstIndex(where: { $0.id == foodToUpdate.id }) {
                        self.list[index].food_name = newName
                        self.list[index].calories = newCalories
                    }
                }
                print("Document updated successfully")
            }
        }
    }
    
    func deleteData(foodToDelete: Food_Details){
        let db = Firestore.firestore()
        
        db.collection("food").document(foodToDelete.id).delete{ error in
            if error == nil{
                DispatchQueue.main.async {
                    self.list.removeAll { food in
                        return food.id == foodToDelete.id
                    }
                }
            }
            
        }
    }
    

    func addData(calories: Int, food_name: String, user_id: String) {
           let db = Firestore.firestore()
           let data: [String: Any] = [
               "calories": calories,
               "food_name": food_name,
               "user_id": user_id,
               "timestamp": Timestamp()
           ]
           db.collection("food").addDocument(data: data) { error in
               if let error = error {
                   print("Error adding document: \(error)")
               } else {
                   print("Document added successfully")
                   self.getData()
               }
           }
       }




    func getData() {
        let db = Firestore.firestore()
    
        db.collection("food")
            .whereField("user_id", isEqualTo: self.userID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }

                if let snapshot = snapshot {

                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { document in
                            let data = document.data()
                            let id = document.documentID
                            let calories = data["calories"] as? Int ?? 0
                            let foodName = data["food_name"] as? String ?? ""
                            let userId = data["user_id"] as? String ?? ""
                            return Food_Details(id: id, calories: calories, food_name: foodName, user_id: userId)
                        }
                    }
                }
            }
    }
    
    
   
    
}
