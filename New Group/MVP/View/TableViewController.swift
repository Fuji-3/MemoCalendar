//
//  TableViewController.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/02.
//

import UIKit

class TableViewController: UIViewController {
    private var searchFood_presenter: SearchFood_presenter_input!
    
    var barTitle:String!
    
    @IBOutlet weak var searchFoot_searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        searchFoot_searchBar.delegate = self

        searchFood_presenter = SearchFood_Presenter(view: self) 
        
    }
    
    @IBAction func buttonDismis(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        searchFood_presenter.serathBarText(text: searchFoot_searchBar.text ?? "")
    }
    
}
extension TableViewController:UISearchBarDelegate{
    //ユーザーが検索テキストの編集を開始する
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension TableViewController:SearchFood_presenter_output{
    func output_serathData(data: [String : AnyObject]) {
        
    }
    
    
}
