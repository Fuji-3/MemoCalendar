//
//  SearchFood.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/08.
//

import Foundation
import FirebaseDatabase

struct SearchFood {
    private var ref: DatabaseReference!
    
    //検索の読み込み
    func searchFood_Fast(inputSearchText:String){
        var ref = DatabaseReference()
        ref = Database.database().reference()
        ref
            .child("SearchData/Data")
            .queryOrdered(byChild: "name")
            .queryStarting(atValue: "釜揚げうどん")
            .observeSingleEvent(of: .value, with: { snapshot in
                if let dic = snapshot.value as? [String:AnyObject] {
                    for i in dic {
                        print(i.value as! [String:String])
                    }
                }
            })
    }
    
    
    
    
    
    
}
