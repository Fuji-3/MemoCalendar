//
//  AsaTableViewCell.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/06/26.
//
public protocol CellButtonTapProtocol{
    func AddButonTap(identifier:String,nib:UINib)
}
import UIKit

class AsaTableViewCell: UITableViewCell {
    var delegate:CellButtonTapProtocol?
    
    @IBOutlet weak var kcalLabel: UILabel!
    
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

