//
//  Food.swift
//  icalories
//
//  Created by Karlo Buhinjak on 24.06.2023..
//

import Foundation


struct Food_Details: Identifiable{

    var id: String
    var calories: Int
    var food_name:String
    var user_id: String

}
//class Food_Details: Identifiable {
//    var id: String
//    var calories: Int
//    var food_name: String
//    var user_id: String
//
//    init(id: String, calories: Int, food_name: String, user_id: String) {
//        self.id = id
//        self.calories = calories
//        self.food_name = food_name
//        self.user_id = user_id
//    }
//}
