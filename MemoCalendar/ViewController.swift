//
//  ViewController.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/06/20.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class ViewController: UIViewController {
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var dayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.delegate = self
        self.calendar.scope = .week
        
        self.dayTableView.delegate = self
        self.dayTableView.dataSource = self
    
        self.dayTableView.register(DayTableViewCell.nib, forCellReuseIdentifier: DayTableViewCell.identifier)
        self.dayTableView.register(AsaTableViewCell.nib, forCellReuseIdentifier: AsaTableViewCell.identifier)
        self.dayTableView.register(HiruTableViewCell.nib, forCellReuseIdentifier: HiruTableViewCell.identifier)
        self.dayTableView.register(YoruTableViewCell.nib, forCellReuseIdentifier: YoruTableViewCell.identifier)
        
        self.dayTableView.rowHeight = 50
        
        
    }
    
    //祝日判定を行い結果を返すメソッド(True:祝日)
    func redDay(_ date:Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
}

extension ViewController:FSCalendarDelegateAppearance{
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.redDay(date){
            return UIColor.red
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }

        return nil
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print(bounds.height)
        //self.calendar.frame = CGRect(origin: calendar.frame.origin , size: bounds.size)
        self.calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tap")
    }
}
extension ViewController:UITableViewDataSource{
    
     
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch indexPath {
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: AsaTableViewCell.identifier, for: indexPath) as! AsaTableViewCell
            cell.delegate = self
            return cell
        case [0,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.identifier, for: indexPath) as! DayTableViewCell
            return cell
            
        case [1,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: HiruTableViewCell.identifier, for: indexPath) as! HiruTableViewCell
            return cell
        case [1,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.identifier, for: indexPath) as! DayTableViewCell
            return cell
            
        case [2,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: YoruTableViewCell.identifier, for: indexPath) as! YoruTableViewCell
            return cell
        case [2,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.identifier, for: indexPath) as! DayTableViewCell
            return cell
        default:
            break
        }
        return cell
    }
    
    
}

extension ViewController:CellButtonTapProtocol{
    func AddButonTap(identifier: String, nib: UINib) {
        print("\(identifier):\(nib)")
    }
}

