//
//  SerectDataTableViewCell.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/28.
//

import UIKit

class SerectDataTableViewCell: UITableViewCell {

    @IBOutlet weak var serect_name: UILabel!
    @IBOutlet weak var serect_value: UILabel!
    
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
    
}
