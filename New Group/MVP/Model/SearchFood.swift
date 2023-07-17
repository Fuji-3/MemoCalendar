//
//  SearchFood.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/08.
//

import Foundation
import FirebaseDatabase
protocol SearchFool_inout_model{
    func get_searchFoodDB(foodName: String, completion:@escaping (Result<[String:AnyObject], Error>) -> Void)
}
class SearchFood_model {
    
    
    
}

extension SearchFood_model:SearchFool_inout_model{
    func get_searchFoodDB(foodName: String, completion: @escaping (Result<[String:AnyObject], Error>) -> Void) {
        //var food_data:Dictionary<String,AnyObject> = [:]
    
        let ref = Database.database().reference().child("SearchData").child("Data")
        
        ref.observe(.value) { snapshot in
            if let data = snapshot.value as? [String:Any] {
                for (_,food_Data) in data {
                    if let menu_data = food_Data as? [String:Any] {
                        for (menu_name,menu_data) in menu_data {
                            if let menuInfo = menu_data as? [String: Any] {
                                if menu_name.hasPrefix("かけ"){
                                    if let name = menuInfo["name"] as? String{
                                        print(menu_data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        /*
         if let menuInfo = menu_data as? [String: Any] {
             print(menuInfo)
             if menu_name.hasPrefix("かけ"){
                 
                 if let name = menuInfo["name"] as? String{
                     //print("name:\(name)")
                 }
             }
         }
         */
        /*[String:[String:Any]
         quer.getData { Error, snapshot in
            if let data = snapshot?.value as? [String:[String:[String:Any]]] {
                for(_, menu) in data{
                    for(_,menuData) in menu {
                        print(menuData)
                    }
                }
            }
        }*/

        
        /*一応できてる
        ref.observe(.value) { snapshot in
            if let data = snapshot.value as? [String:Any] {
                for (food_name,food_Data) in data {
                    if let menu_data = food_Data as? [String:Any] {
                        for (menu_name,menu_data) in menu_data {
                            if let menuInfo = menu_data as? [String: Any] {
                                if menu_name.hasPrefix("かけ"){
                                    if let name = menuInfo["name"] as? String{
                                        print("name:\(name)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        */
    }
    
    
}
