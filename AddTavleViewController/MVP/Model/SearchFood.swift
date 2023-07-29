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
    
    func set_serctFoodDB(data:[String:Any],day:String,uid:String, completion:@escaping(Result<String,Error>)->Void)
    func get_serctFoodDB(day:String,uid:String,completion:@escaping(Result<String,Error>)->Void)
}

enum dataBase_Error:String, Error {
    case netWork_Error = "データの取得失敗"
    case not_DB = "データが存在しません"
}

//サーチDB
class SearchFood_model {

    
}

extension SearchFood_model:SearchFool_inout_model{
    func get_serctFoodDB(day: String, uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().sync {
            let ref = Database.database().reference().child("ID")
                .child(uid)
                .child(day)
            ref.getData { error, snapshot in
                guard error != nil else{
                    return
                }
                if ((snapshot?.exists()) != nil) {
                    print(snapshot?.value)
                }
            }
        }
    }
    

    func set_serctFoodDB(data: [String : Any], day: String, uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        DispatchQueue.global().sync {
            let ref = Database.database().reference().child("ID")
                .child(uid)
                .child(day)
                .child(data["name"] as? String ?? "")
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.hasChildren() {
                        // 既存のデータがある場合の処理
                        completion(.success("既存のデータがあります"))
                        
                    }else{
                        // 既存のデータがない場合の処理
                        //print("既存のデータがないので追加する")
                        ref.setValue(data){(error, snapshot) in
                            if let error = error {
                                // データ追加中にエラーが発生した場合の処理
                                //print("データの追加に失敗しました: \(error.localizedDescription)")
                                completion(.failure(error))
                            } else {
                                // データ追加が成功した場合の処理
                                completion(.success("データの追加に成功しました"))
                            }
                        }
                    }
            })
        }
    }

    
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
