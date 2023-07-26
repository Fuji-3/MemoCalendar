//
//  AddTableViewCell.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/11.
//

import UIKit
protocol AddCellButton:AnyObject {
    func addCellFood(cell: AddTableViewCell)
}

class AddTableViewCell: UITableViewCell {
    @IBOutlet weak var syouhine_label: UILabel!
    @IBOutlet weak var syouhine_value: UILabel!
    
    var delegate:AddCellButton?
    
    static var  identifier:String {
        String(describing: self)
    }
    static var nib:UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addButton(_ sender: UIButton) {
        delegate?.addCellFood(cell: self)
        
    }
}
