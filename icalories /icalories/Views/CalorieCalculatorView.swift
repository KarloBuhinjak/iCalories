//
//  CalorieCalculatorView.swift
//  icalories
//
//  Created by Karlo Buhinjak on 28.05.2023..
//

import SwiftUI

struct CalorieCalculatorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var weight: Double = 0.0
    @State private var height: Double = 0.0
    @State private var age: Int = 0
    @State private var activityLevel: Int = 1 // Default: Lightly active
    
    private let activityLevels = ["Sedentary", "Lightly active", "Moderately active", "Very active", "Extra active"]
    private let bmrMultipliers = [1.2, 1.375, 1.55, 1.725, 1.9]
    
    private var bmr: Double {
        return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * Double(age))
    }
    
    private var totalCalories: Double {
        let calories = bmr * bmrMultipliers[activityLevel]
        UserDefaults.standard.set(calories, forKey: "totalCalories")
        return calories
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Weight (kg)", value: $weight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        TextField("Height (cm)", value: $height, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        Stepper(value: $age, in: 0...150, label: {
                            Text("Age: \(age)")
                        })
                    }
                    
                    Section(header: Text("Activity Level")) {
                        Picker("Activity Level", selection: $activityLevel) {
                            ForEach(0..<activityLevels.count, id: \.self) { index in
                                Text(activityLevels[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    
                    }
                    
                    Section(header: Text("Calorie Calculation")) {
                        Text("BMR: \(bmr, specifier: "%.2f")")
                        Text("Total Calories: \(totalCalories, specifier: "%.2f")")
                    }
                }
                .navigationBarTitle("Calorie Calculator")
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct CalorieCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalorieCalculatorView()
    }
}
