//
//  File.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/03.
//

import Foundation
import UIKit

struct DayTableViewCell_Modally {
    
    func senniVC(vc:UIViewController){
        let storyboard:UIStoryboard = vc.storyboard!
        let init_addVC = storyboard.instantiateViewController(withIdentifier: "initAddVC")
        vc.present(init_addVC, animated: true)
    }
}
