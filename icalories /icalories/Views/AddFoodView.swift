//
//  AddFoodView.swift
//  icalories
//
//  Created by Karlo Buhinjak on 01.05.2023..
//

import SwiftUI
import Firebase


struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("uid") var userID: String = ""
    @State private var name = ""
    @State private var calories: Int = 0
    @ObservedObject var model = ViewModel()
   
   
    
    var body: some View {
            Form {
                Section() {
                    TextField("Food name", text: $name)
                    
                    //VStack {
                        Text("Calories: \(Int(calories))")
                        //Slider(value: $calories, in: 0...1000, step: 10)
                        
                        TextField("Number of calories", value: $calories, format: .number).keyboardType(.numberPad)
                                        
                                        
                    //}
                    
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            model.addData(calories: calories, food_name: name, user_id: userID)
                            
                            dismiss()
                        }
                        Spacer()
                    }
                }
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
