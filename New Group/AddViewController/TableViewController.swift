//
//  TableViewController.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/02.
//

import UIKit

class TableViewController: UIViewController {
    var barTitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        var searth = SearchFood()
        searth.searchFood_Fast(inputSearchText: "カレーラーメン")
    }
    @IBAction func buttonDismis(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
}
