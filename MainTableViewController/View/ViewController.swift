//
//  ViewController.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/06/20.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var dayTableView: UITableView!
    
    var view_presenter_input:View_Presenter_input!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.scope = .week
        
        self.dayTableView.delegate = self
        self.dayTableView.dataSource = self
        
        self.view_presenter_input = ViewPresenter(view: self)
       
        self.dayTableView.register(AsaTableViewCell.nib, forCellReuseIdentifier: AsaTableViewCell.identifier)
        self.dayTableView.register(HiruTableViewCell.nib, forCellReuseIdentifier: HiruTableViewCell.identifier)
        self.dayTableView.register(YoruTableViewCell.nib, forCellReuseIdentifier: YoruTableViewCell.identifier)
        self.dayTableView.register(SerectDataTableViewCell.nib, forCellReuseIdentifier: SerectDataTableViewCell.identifier)
        
        self.dayTableView.rowHeight = 50
        let time =  todayFormatter(today_date: self.calendar.today!)
        self.get_serectDB(time: time)
    }
    //serectDBに読み取り
    private func get_serectDB(time:String){
        self.view_presenter_input.get_TableData(time: time, time_zone: " 朝")
        self.view_presenter_input.get_TableData(time: time, time_zone: " 昼")
        self.view_presenter_input.get_TableData(time: time, time_zone: " 夜")
    }
}

//FSCalendar関連処理
extension ViewController {
    //日付をフォーマット
    func todayFormatter(today_date:Date)->String{
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "M月dd日"
        return df.string(from: today_date)
    }
    
    //祝日判定を行い結果を返すメソッド(True:祝日)
    func redDay(_ date:Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

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
        self.calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
extension ViewController:FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.get_serectDB(time: self.todayFormatter(today_date: date))
    }
}
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.view_presenter_input.numberOfRowsInSection(seciton: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.section == 0 &&  indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: AsaTableViewCell.identifier, for: indexPath) as! AsaTableViewCell
                cell.delegate = self
            return cell
        }
        
        if indexPath.section == 0 && indexPath.row <= self.view_presenter_input.get_AsaCellText.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: SerectDataTableViewCell.identifier, for: indexPath) as! SerectDataTableViewCell
            let data = self.view_presenter_input.get_AsaCellText[indexPath.row - 1]
            
            
            cell.serect_name.text = data["name"] as? String ?? "Name"
            cell.serect_value.text = data["kcal"] as? String ?? "0"
            return cell
        }
        
        if indexPath.section == 1 &&  indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: HiruTableViewCell.identifier, for: indexPath) as! HiruTableViewCell
                cell.delegate = self
            return cell
        }
        if indexPath.section == 1 && indexPath.row <= self.view_presenter_input.get_HiruCellText.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: SerectDataTableViewCell.identifier, for: indexPath) as! SerectDataTableViewCell
            let data = self.view_presenter_input.get_HiruCellText[indexPath.row - 1]
            cell.serect_name.text = data["name"] as? String ?? "Name"
            cell.serect_value.text = data["kcal"] as? String ?? "0"
            return cell
        }
        if indexPath.section == 2 &&  indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: YoruTableViewCell.identifier, for: indexPath) as! YoruTableViewCell
                cell.delegate = self
            return cell
        }
        if indexPath.section == 2 && indexPath.row <= self.view_presenter_input.get_YoruCellText.count {
            //print("section:\(indexPath.section),\(indexPath.row)")
            let cell = tableView.dequeueReusableCell(withIdentifier: SerectDataTableViewCell.identifier, for: indexPath) as! SerectDataTableViewCell
            let data = self.view_presenter_input.get_YoruCellText[indexPath.row - 1]
            cell.serect_name.text = data["name"] as? String ?? "Name"
            cell.serect_value.text = data["kcal"] as? String ?? "0"
            
            return cell
        }
        return cell
    }
    
    
}

extension ViewController:CellButtonTapProtocol{
    func AddButonTap(identifier: String, nib: UINib) {
        let stroyboad:UIStoryboard = UIStoryboard(name: "TableViewController", bundle: nil)
        let vc = stroyboad.instantiateViewController(withIdentifier: "initAddVC") as! TableViewController
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        var today:String = ""
        
        switch identifier {
        case  "AsaTableViewCell":
            today = todayFormatter(today_date: self.calendar.today!) + " 朝"
        case "HiruTableViewCell":
            today = todayFormatter(today_date: self.calendar.today!) + " 昼"
        case "YoruTableViewCell":
            today = todayFormatter(today_date: self.calendar.today!) + " 夜"
        default:
            break
        }
        nav.navigationBar.topItem?.title = today
        self.present(nav, animated: true)
    }
    
}

extension ViewController:View_Presenter_output{
    func dataFethCompleted(time_zone: String) {
        self.dayTableView.reloadData()
    }
}
