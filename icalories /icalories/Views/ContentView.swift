//
//  ContentView.swift
//  icalories
//
//  Created by Karlo Buhinjak on 01.05.2023..
//

import SwiftUI
import CoreData
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

struct ContentView: View {
    //@EnvironmentObject var appViewModel: ViewModel
    @AppStorage("uid") var userID: String = ""
    @AppStorage("totalCalories") var totalCalories: Double = 0.0
    @State private var showingAddView = false
    @State private var showingCalculatorView = false
    @ObservedObject var model = ViewModel()
    
    init() {
        model.getData()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\( calculateTotalCalories()) calories today/ Daily intake: \(totalCalories, specifier: "%.0f") cal")
                    .foregroundColor(.gray)
                    .padding([.horizontal])
                List {
                    ForEach(model.list) { food in
                        NavigationLink(destination: EditFoodView(food: food, model: model)){
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(food.food_name)
                                        .bold()
                                    
                                    Text("\(Int(food.calories)) calories")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let foodToDelete = model.list[index]
                            model.deleteData(foodToDelete: foodToDelete)
                        }
                    }
                }.id(UUID())
            }
            .onChange(of: totalCalories) { _ in
                // Promjena totalCalories će ponovno renderirati view
            }
            .navigationTitle("Calories Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Spacer()
                        Button(action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                withAnimation{
                                    userID = ""
                                }
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }) {
                            Text("Sign Out")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingAddView.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                        }
                        
                        Button(action: {
                            showingCalculatorView.toggle()
                        }) {
                            Image(systemName: "pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
            .sheet(isPresented: $showingCalculatorView) {
                CalorieCalculatorView()
            }
        }
        .navigationViewStyle(.stack)
    }
    func calculateTotalCalories() -> Int {
        var totalCalories = 0
        
        for food in model.list {
            totalCalories += food.calories
        }
        
        return totalCalories
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
