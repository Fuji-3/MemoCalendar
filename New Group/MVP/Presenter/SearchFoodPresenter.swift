//
//  SearchFoodPresenter.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/11.
//

import Foundation
protocol SearchFood_presenter_input:AnyObject{
    func serathBarText(text: String)
}
protocol SearchFood_presenter_output:AnyObject{
    func output_serathData(data: [String:AnyObject])
}

class SearchFood_Presenter {
    weak var view:SearchFood_presenter_output?
    private let model:SearchFool_inout_model
    
    init(view: SearchFood_presenter_output) {
        self.view = view
        self.model = SearchFood_model()
    }
}
extension SearchFood_Presenter:SearchFood_presenter_input {
    func serathBarText(text: String) {
        print("text:\(text)")
        self.model.get_searchFoodDB(foodName: text) { result in
            switch result {
            case.success(let foodData):
                print("searchFood_presenter ")
                /*\(foodData.sorted { $0.key < $1.key })*/
            case.failure(let error):
                print("searchFood_presenter \(error)")
            }
        }
    }
}
