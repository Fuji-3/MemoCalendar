//
//  ViewPresenter.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/26.
//

import Foundation
//ViewからPresenterに処理そ委託
protocol View_Presenter_input:AnyObject{
    func get_TableData(time:String,time_zone:String)
    var  get_AsaCellText:[[String:Any]]{get}
    var  get_HiruCellText:[[String:Any]]{get}
    var  get_YoruCellText:[[String:Any]]{get}
    func numberOfRowsInSection(seciton:Int)->Int
}
//PresenterからViewに委託
protocol View_Presenter_output:AnyObject{
    func dataFethCompleted(time_zone:String)
}


class ViewPresenter{
    weak var view:View_Presenter_output?
    private let model:ViewModel
    private var serect_FoodDB:[String:Any]!
    
    private var as_serect_FoodDB =   [[String:Any]]()
    private var hiru_serect_FoodDB = [[String:Any]]()
    private var yoru_serect_FoodDB = [[String:Any]]()
    init(view:View_Presenter_output) {
        self.view = view
        self.model = ViewModel()
    }
}

extension ViewPresenter{
    //DBからのデータをフォーマットする
    private func searchFoodDB_Format(data:[String:[String:Any]],time_zone:String)->[[String:Any]]{
        switch time_zone{
            case " 朝":
                as_serect_FoodDB   = [[String:Any]]()
                for (_,food_data) in data{
                    var data = [String:Any]()
                    data.updateValue(food_data["name"] as Any, forKey: "name")
                    data.updateValue(food_data["kcal"] as Any, forKey: "kcal")
                    as_serect_FoodDB.append(data)
                    //as_serect_FoodDB.updateValue(food_data["kcal"], forKey: food_data["name"] as? String ?? "0")
                }
                
                let sored = as_serect_FoodDB.sorted { (data1 ,data2)->Bool in
                    if let kcal1 = data1["name"] as? String, let kcal2 = data2["name"] as? String {
                        return kcal1 > kcal2
                    } else {
                        // "kcal"がnilの場合は後ろに表示されるようにします
                        return false
                    }
                }
                as_serect_FoodDB = sored
                return sored

            case " 昼":
                hiru_serect_FoodDB = [[String:Any]]()
                for (_,food_data) in data{
                    var data = [String:Any]()
                    data.updateValue(food_data["name"] as Any, forKey: "name")
                    data.updateValue(food_data["kcal"] as Any, forKey: "kcal")
                    hiru_serect_FoodDB.append(data)
                }
                let sored = hiru_serect_FoodDB.sorted { (data1 ,data2)->Bool in
                    if let kcal1 = data1["name"] as? String, let kcal2 = data2["name"] as? String {
                        return kcal1 > kcal2
                    } else {
                        // "kcal"がnilの場合は後ろに表示されるようにします
                        return false
                    }
                }
                hiru_serect_FoodDB = sored
                return sored
            case " 夜":
                yoru_serect_FoodDB = [[String:Any]]()
                for (_,food_data) in data{
                    var data = [String:Any]()
                    data.updateValue(food_data["name"] as Any, forKey: "name")
                    data.updateValue(food_data["kcal"] as Any, forKey: "kcal")
                    yoru_serect_FoodDB.append(data)
                }
                let sored = yoru_serect_FoodDB.sorted { (data1 ,data2)->Bool in
                    if let kcal1 = data1["name"] as? String, let kcal2 = data2["name"] as? String {
                        return kcal1 > kcal2
                    } else {
                        // "kcal"がnilの場合は後ろに表示されるようにします
                        return false
                    }
                }
                yoru_serect_FoodDB = sored
                return sored
            default:break
        }
        return [[:]]
    }
    
}

extension ViewPresenter:View_Presenter_input{
    func numberOfRowsInSection(seciton: Int) -> Int {
        print("section___:\(seciton)")
        switch seciton{
            case 0:
                return self.as_serect_FoodDB.count + 1
            case 1:
                return self.hiru_serect_FoodDB.count + 1
            case 2:
                return self.yoru_serect_FoodDB.count + 1
            default:break
        }
        return 1
    }
    

    var get_AsaCellText: [[String : Any]] {
        return self.as_serect_FoodDB
    }
    
    var get_HiruCellText: [[String:Any]] {
        return self.hiru_serect_FoodDB
    }
    
    var get_YoruCellText: [[String:Any]] {
        return  self.yoru_serect_FoodDB
      
    }
    
    func get_TableData(time: String, time_zone: String) {
        let dispatchGroup = DispatchGroup()
        if time_zone == " 朝"{
            dispatchGroup.enter()
                self.model.get_timezone_DB(time: time, time_zone: time_zone) { result in
                    switch result {
                        case.success(let data):
                            self.as_serect_FoodDB = self.searchFoodDB_Format(data: data, time_zone: time_zone)
                            dispatchGroup.leave()
                        case.failure(let error):break
                    }
                }
        }
        
        if time_zone == " 昼"{
            dispatchGroup.enter()
                self.model.get_timezone_DB(time: time, time_zone: time_zone) { [self] result in
                    switch result {
                        case.success(let data):
                            self.hiru_serect_FoodDB = self.searchFoodDB_Format(data: data, time_zone: time_zone)
                            dispatchGroup.leave()
                        case.failure(let error):
                            break
                    }
                }
            
        }
        
        if time_zone == " 夜"{
            dispatchGroup.enter()
                self.model.get_timezone_DB(time: time, time_zone: time_zone) { result in
                    switch result {
                        case.success(let data):
                            self.yoru_serect_FoodDB = self.searchFoodDB_Format(data: data, time_zone: time_zone)
                            dispatchGroup.leave()
                        case.failure(let error):break
                    }
                }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Asa:\(self.get_AsaCellText)")
            print("Hiru:\(self.get_HiruCellText)")
            print("Yoru:\(self.get_YoruCellText)")
                self.view?.dataFethCompleted(time_zone: time_zone)
        }
    }
    
    
}
