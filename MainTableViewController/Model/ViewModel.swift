//
//  ViewModel.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/26.
//

import Foundation
import FirebaseDatabase
protocol get_SerectFood_DB{
    func get_timezone_DB(time: String, time_zone: String, completion: @escaping (Result<[String:[String:Any]], Error>) -> Void)
}
class ViewModel{
    private var serectFood = Array<[String:Any]>()
    
}
extension ViewModel{
    private func get_Firebase(time:String,time_zone:String,uid:String)->DatabaseReference{
        let ref:DatabaseReference = Database.database().reference()
        return ref
    }
        
}
extension ViewModel:get_SerectFood_DB{
    func get_timezone_DB(time: String, time_zone: String, completion: @escaping (Result<[String:[String : Any]], Error>) -> Void) {
        let userDefaults = UserDefaults.standard.dictionary(forKey: "id")
        let uid = userDefaults!["uid"] as? String ?? ""
        DispatchQueue.global().sync {
            switch time_zone{
                case " 朝":
                     //let data = self.get_Firebase(time: time, time_zone: time_zone, uid: uid)
                    let ref:DatabaseReference = Database.database().reference()
                    ref.child("ID").child(uid).child(time+time_zone).getData { error, snapshot in
                        guard snapshot?.exists() != nil else{
                            return
                        }
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
                case " 昼":
                    //self.get_Firebase(time: time, time_zone: time_zone, uid: uid)
                    let ref:DatabaseReference = Database.database().reference()
                    ref.child("ID").child(uid).child(time+time_zone).getData { error, snapshot in
                        guard snapshot?.exists() != nil else{
                            return
                        }
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
                case " 夜":
                    //self.get_Firebase(time: time, time_zone: time_zone, uid: uid)
                    let ref:DatabaseReference = Database.database().reference()
                    ref.child("ID").child(uid).child(time+time_zone).getData { error, snapshot in
                        guard snapshot?.exists() != nil else{
                            return
                        }
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
                default:
                    break
            }
        }

    }

    
    
    
}
