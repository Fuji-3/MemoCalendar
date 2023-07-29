//
//  HiruTableViewCell.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/06/26.
//

import UIKit

class HiruTableViewCell: UITableViewCell {
    @IBOutlet weak var kcalLabel: UILabel!
    var delegate:CellButtonTapProtocol?
    
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
    @IBAction func AddButton(_ sender: UIButton) {
        delegate?.AddButonTap(identifier: Self.identifier, nib: Self.nib)
    }
    
}
