//
//  icaloriesApp.swift
//  icalories
//
//  Created by Karlo Buhinjak on 01.05.2023..
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
@main
struct icaloriesApp: App {
   
    @AppStorage("uid") var userID: String = ""
    
    init(){
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {

            if userID == ""{
                AuthView()
            }else{
                ContentView()
                    
            }
        }
    }
}
