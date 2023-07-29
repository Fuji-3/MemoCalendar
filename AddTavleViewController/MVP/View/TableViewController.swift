//
//  TableViewController.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/02.
//

import UIKit

class TableViewController: UIViewController {
    private var searchFood_presenter: SearchFood_presenter_input!
    private let searchButton_Indicator = UIActivityIndicatorView(style: .large)
 
    @IBOutlet weak var addDataTableView: UITableView!
    @IBOutlet weak var searchFoot_searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator_config()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.searchFoot_searchBar.delegate = self
        self.searchFood_presenter = SearchFood_Presenter(view: self)
        
        self.addDataTableView.delegate = self
        self.addDataTableView.dataSource = self
        
        self.addDataTableView.register(AddTableViewCell.nib, forCellReuseIdentifier: AddTableViewCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.addDataTableView.reloadData()
    }
    
    @IBAction func buttonDismis(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        self.searchButton_Indicator.startAnimating()
        searchFood_presenter.serathBarText(text: searchFoot_searchBar.text ?? "")
    }

}
extension TableViewController{
    func indicator_config(){
        searchButton_Indicator.color = UIColor.white
        searchButton_Indicator.backgroundColor = .gray
        searchButton_Indicator.center = view.center
        searchButton_Indicator.hidesWhenStopped = true
        self.view.addSubview(searchButton_Indicator)
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
    func event_alet(text: String) {
        let alertController = UIAlertController(title: "", message: text, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default){(_) in
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func output_serathData(data: [String : Any]) {
        self.searchButton_Indicator.stopAnimating()
        self.addDataTableView.reloadData()
    }
    
}

extension TableViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
extension TableViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFood_presenter.numberOfFood_Data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
        cell.delegate = self
        let data = self.searchFood_presenter.cellForText(row: indexPath.row)
        
        if let label:String = data["name"] as? String{
            cell.syouhine_label.text = label
        }
        
        cell.syouhine_value.text =
        "カロリー \(data["kcal"] ?? "0" )kcal " +
        "脂質 \(data["lipid"] ?? "0")g" +
        "炭水化物 \(data["protein"] ?? "0")"
        
        return cell
    }
    
}
extension TableViewController:AddCellButton{
    func addCellFood(cell: AddTableViewCell) {
        if let indexPath = addDataTableView.indexPath(for: cell){
            let data = self.searchFood_presenter.cellForText(row: indexPath.row)
            self.searchFood_presenter.serectFoodData(data: data, day: self.navigationItem.title!.description)
            
        }
    }
    
    
    
    
}
