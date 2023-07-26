//
//  SearchFoodPresenter.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/11.
//

import Foundation
protocol SearchFood_presenter_input:AnyObject{
    var numberOfFood_Data:Int{get}
    func serathBarText(text: String)
    func cellForText(row: Int)->[String:Any]
    func serectFoodData(data:[String:Any],day:String)
}
protocol SearchFood_presenter_output:AnyObject{
    func output_serathData(data: [String:Any])
}


class SearchFood_Presenter {
    private var food_data = [String:Any]()
    private var food_key = [String]()
    
    weak var view:SearchFood_presenter_output?
    private let model:SearchFool_inout_model
    
    init(view: SearchFood_presenter_output) {
        self.view = view
        self.model = SearchFood_model()
    }
    //DBからのデータをフォーマットする
    func searchFoodDB_Format(data:[String:[String:Any]],text:String)->[String:Any]{
        var search_data = [String:Any]()
        self.food_data = [:]
        //textが空白ならリターン
        guard text.isEmpty != true else{
            return [:]
        }
        for (_, food_name_data) in data {
            for (data_key,data_value) in food_name_data.sorted(by: {$0.0 < $1.0}) {
                //textでkey検索
                if data_key.hasPrefix(text){
                    search_data.updateValue(data_value as! [String : Any], forKey: data_key)
                }
                
            }
        }
        return search_data
        
    }
    
}
extension SearchFood_Presenter:SearchFood_presenter_input {
    //検索一覧から登録ボタンが押された処理
    func serectFoodData(data: [String : Any], day: String) {
        
    }
    
    func cellForText(row: Int) -> [String:Any]{
        let keys = Array(food_data.keys).sorted()
        
        let data = keys[row]
        if  let valeu = (food_data[data] as? [String:Any]) {
            return valeu
        }
        return [:]
    }
    
    var numberOfFood_Data: Int {
        return self.food_data.count
    }
    //データ読み取り
    func serathBarText(text: String) {
        print("text:\(text)")
        self.model.get_searchFoodDB(foodName: text) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case.success(let data):
                    self.food_data = self.searchFoodDB_Format(data: data, text: text)
                    self.view?.output_serathData(data: self.food_data)
                    
                case.failure(let error):
                    print("searchFood_presenter \(error)")
                    self.view?.output_serathData(data: [:])
                }
            }
        }
    }
}
