//
//  SearchFood.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/08.
//

import Foundation
import FirebaseDatabase

protocol SearchFool_inout_model{
    func get_searchFoodDB(foodName: String, completion:@escaping (Result<[String:[String:Any]], Error>) -> Void)
}

enum dataBase_Error:String, Error {
    case netWork_Error = "データの取得失敗"
    case not_DB = "データが存在しません"
}

class SearchFood_model {}

extension SearchFood_model:SearchFool_inout_model{
    func get_searchFoodDB(foodName: String, completion: @escaping (Result<[String : [String : Any]], Error>) -> Void) {
        DispatchQueue.global().sync {
            let ref = Database.database().reference()
                ref
                    .child("SearchData")
                    .child("Data")
                    .getData { error , snapshot in
                        if error != nil {
                            //データベースにアクセス失敗した場合
                            completion(.failure(dataBase_Error.netWork_Error))
                        }else{
                            // データの取得に成功した場合/
                            if snapshot!.exists() {
                                if let value = snapshot?.value as? [String:[String:Any]]  {
                                    completion(.success(value))
                                }
                            }else{
                                //該当データが存在しない場合
                                completion(.failure(dataBase_Error.not_DB))
                                
                            }
                        }
                    }

        }
    }
    
    
    
}
