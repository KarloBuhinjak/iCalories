//
//  EditFoodView.swift
//  icalories
//
//  Created by Karlo Buhinjak on 01.05.2023..
//

import SwiftUI

struct EditFoodView: View {
    @Environment(\.dismiss) var dismiss

    var food: Food_Details
    @State private var name: String
    @State private var calories: Double
    var model: ViewModel

    init(food: Food_Details, model: ViewModel) {
        self.food = food
        self.model = model
        _name = State(initialValue: food.food_name)
        _calories = State(initialValue: Double(food.calories))
    }

    var body: some View {
        Form {
            Section {
                TextField("Food name", text: $name)
                Slider(value: $calories, in: 0...2000, step: 10)
                Text("Calories: \(Int(calories))")
            }

            Button("Submit") {
                model.updateData(foodToUpdate: food, newName: name, newCalories: Int(calories))
                dismiss()
            }
        }
    }
}
