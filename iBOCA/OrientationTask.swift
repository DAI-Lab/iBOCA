//
//  OrientationTask.swift
//  iBOCA
//
//  Created by Ellison Lim on 8/1/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import UIKit
import MessageUI

var firstTimeThrough = true
//declare variables to be defined by pickerviews
var startTime = Foundation.Date()

class OrientationTask:  ViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate,UIPickerViewDelegate  {
    
    let defaultBlueColor: UIColor = UIColor.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
    var Week : String?
    var State : String?
    var Town : String?
    var Date : String?
    var Time : String?
    var TimeOK : Bool = false
    var DateOK : Bool = false
    var dkDate : Bool = false {
        didSet {
            if dkDate {
                btnDontKnowDate.setTitleColor(UIColor.red, for: .normal)
            }
            else {
                btnDontKnowDate.setTitleColor(defaultBlueColor, for: .normal)
            }
        }
    }
    var dkMonth : Bool = false {
        didSet {
            if dkMonth {
                btnDontKnowMonth.setTitleColor(UIColor.red, for: .normal)
            }
            else {
                btnDontKnowMonth.setTitleColor(defaultBlueColor, for: .normal)
            }
        }
    }
    var dkYear : Bool = false {
        didSet {
            if dkYear {
                btnDontKnowYear.setTitleColor(UIColor.red, for: .normal)
            }
            else {
                btnDontKnowYear.setTitleColor(defaultBlueColor, for: .normal)
            }
        }
    }
    var dkWeek : Bool = false {
        didSet {
            if dkWeek {
                btnDontKnowWeek.setTitleColor(UIColor.red, for: .normal)
            }
            else {
                btnDontKnowWeek.setTitleColor(defaultBlueColor, for: .normal)
            }
        }
    }
    var dkState : Bool = false {
        didSet {
            if dkState {
                btnDontKnowState.setTitleColor(UIColor.red, for: .normal)
            }
            else {
                btnDontKnowState.setTitleColor(defaultBlueColor, for: .normal)
            }
        }
    }
    var dkTown : Bool = false {
        didSet {
            if dkTown {
                btnDontKnowTown.setTitleColor(UIColor.red, for: .normal)
            }
            else {
                btnDontKnowTown.setTitleColor(defaultBlueColor, for: .normal)
            }
        }
    }
    var dkTime : Bool = false {
        didSet {
            if dkTime {
                btnDontKnowTime.setTitleColor(UIColor.red, for: .normal)
            }
            else {
                btnDontKnowTime.setTitleColor(defaultBlueColor, for: .normal)
            }
        }
    }

    //pickerview content set up(defines options)
    
    @IBOutlet weak var WeekPicker: UIPickerView!
    let weekData = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Do not know"]
    
    @IBOutlet weak var StatePicker: UIPickerView!
    let stateData = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia","Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming", "Don't Know"]
    
    
    @IBOutlet weak var currentDate: UIDatePicker!
    
    @IBOutlet weak var btnDontKnowMonth: UIButton!
    @IBOutlet weak var btnDontKnowDate: UIButton!
    @IBOutlet weak var btnDontKnowYear: UIButton!
    @IBOutlet weak var btnDontKnowWeek: UIButton!
    @IBOutlet weak var btnDontKnowState: UIButton!
    @IBOutlet weak var btnDontKnowTown: UIButton!
    @IBOutlet weak var btnDontKnowTime: UIButton!
    
    
    var body:String?
    //text field input and results
    
    @IBAction func updateDate(_ sender: AnyObject) {
        let d:UIDatePicker = sender as! UIDatePicker
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        Date = formatter.string(from: d.date)
        let v = startTime.timeIntervalSince(d.date)
        if abs(v) < 60*60*24 {
            DateOK = true
        } else {
            DateOK = false
        }
        
        dkDate = false
        dkMonth = false
        dkYear = false
    }
    
    @IBOutlet weak var TownPicker: UIPickerView!
    let townData = ["Correct", "Incorrect"]
    
    
    @IBOutlet weak var currentTime: UIDatePicker!
    
    @IBAction func updateTime(_ sender: Any) {
        let d:UIDatePicker = sender as! UIDatePicker
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        Time = formatter.string(from: d.date)
        TimeOK = TimeDiffOK(date1: startTime, date2: d.date)
        
        dkTime = false
    }
    
    @IBAction func DontKnowMonth(_ sender: UIButton) {
        dkMonth = true
    }
    
    @IBAction func DontKnowDate(_ sender: Any) {
        dkDate = true
    }
    
    @IBAction func DontKnowYear(_ sender: UIButton) {
        dkYear = true
    }
    
    @IBAction func DontKnowWeek(_ sender: Any) {
        Week = "Dont Know"
        dkWeek = true
    }
    
    
    @IBAction func DontKnowState(_ sender: Any) {
        State = "Dont Know"
        dkState = true
    }
    
    
    @IBAction func DontKnowTown(_ sender: Any) {
        Town = "Dont Know"
        dkTown = true
    }
    
    @IBAction func DontKnowTime(_ sender: Any) {
        Time = "Dont Know"
        dkTime = true
        TimeOK = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //declare pickerviews
        WeekPicker.delegate = self
        StatePicker.delegate = self
        TownPicker.delegate = self
        
        dkDate = false
        dkMonth = false
        dkYear = false
        
        State = stateData[StatePicker.selectedRow(inComponent: 0)]
        // If a correct state name has been saved, use it
        if(UserDefaults.standard.object(forKey: "OrientationState") != nil) {
            let os = UserDefaults.standard.object(forKey: "OrientationState") as! String
            let v = stateData.index(of: os)
            if (v != nil) {
                State  = os
                StatePicker.selectRow(v!, inComponent: 0, animated: false)
            }
        }
        
        Town = townData[TownPicker.selectedRow(inComponent: 0)]
        
        // Get the current date
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        currentDate.setDate(Foundation.Date(),  animated: false)
        Date = formatter.string(from: currentDate.date)
        DateOK = true
        
        
        // Get the current time
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        currentTime.setDate(Foundation.Date(),  animated: false)
        formatter.dateFormat = "HH:MM"
        Time = formatter.string(from: currentTime.date)
        TimeOK = true
        
        // Get the current week
        Week = weekData[WeekPicker.selectedRow(inComponent: 0)]
        formatter.dateFormat = "EEEE"
        let wk = formatter.string(from: Foundation.Date())
        let v = weekData.index(of: wk)
        if (v != nil) {
            Week  = wk
            WeekPicker.selectRow(v!, inComponent: 0, animated: false)
        }

        currentDate.isUserInteractionEnabled = true
        currentTime.isUserInteractionEnabled = true
        WeekPicker.isUserInteractionEnabled = true
        StatePicker.isUserInteractionEnabled = true
        TownPicker.isUserInteractionEnabled = true
        currentDate.alpha = 1.0
        currentTime.alpha = 1.0
        WeekPicker.alpha = 1.0
        StatePicker.alpha = 1.0
        TownPicker.alpha = 1.0
        
        startTime = Foundation.Date()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        body = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
    
    @IBAction func DoneButton(_ sender: AnyObject) {
        let result = Results()
        result.name = "Orientation"
        result.startTime = startTime
        result.endTime = Foundation.Date()
        
        result.json["Week Given"] = Week!
        result.json["State Given"] = State!
        result.json["Town Given"] = Town!
        result.json["Date Given"] = Date!
        result.json["Time Given"] = Time!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        let rightDate = formatter.string(from: startTime)
        result.json["Date Tested"] = rightDate
        formatter.dateFormat = "HH:MM"
        let rightTime = formatter.string(from: startTime)
        result.json["Time Tested"] = rightTime
        formatter.dateFormat = "EEEE"
        let rightWeek = formatter.string(from: startTime)
        result.json["Week Tested"] = rightWeek
        let WeekOK = rightWeek == Week!
        
        result.json["Time Correct"] = TimeOK
        result.json["Date Correct"] = DateOK
        result.json["Week Correct"] = WeekOK
        result.json["Dont Know Date"] = dkDate
        result.json["Dont Know Month"] = dkMonth
        result.json["Dont Know Year"] = dkYear
        
        result.shortDescription = "State: \(State!) "
        if Town! != "Correct" {
            result.shortDescription = result.shortDescription! + "Town: \(Town!) "
        }
        if WeekOK == false {
            result.shortDescription = result.shortDescription! + " Week: \(Week!)(\(rightWeek)) "
        }
        if DateOK == false {
            result.shortDescription = result.shortDescription! + " Date: \(Date!)(\(rightDate)) "
        }
        if dkDate {
            result.shortDescription = result.shortDescription! + " Don't know date "
        }
        if dkMonth {
            result.shortDescription = result.shortDescription! + " Don't know month "
        }
 
        if dkYear {
            result.shortDescription = result.shortDescription! + " Don't know year "
        }
        
        if TimeOK == false {
            result.shortDescription = result.shortDescription! + " Time: \(Time!)(\(rightTime)) "
        }
        
        resultsArray.add(result)
        Status[TestOrientation] = TestStatus.Done
        
        UserDefaults.standard.set(State, forKey:"OrientationState")
        UserDefaults.standard.synchronize()
    }
    
    //pickerview setup and whatnot
    
    func numberOfComponentsInPickerView(_ pickerView : UIPickerView!) -> Int{
        return 1
    }
    
    //returns length of pickerview contents
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        print("0:", pickerView)
        if pickerView == WeekPicker {
            return weekData.count
        }
        else if pickerView == StatePicker {
            return stateData.count
        }
        else if pickerView == TownPicker {
            return townData.count
        }
        return 1
    }
    
    ////sets the final variables to selected row of the pickerview's text
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("1:",pickerView)
        if pickerView == WeekPicker {
            Week = weekData[row]
            return weekData[row]
        }
        else if pickerView == StatePicker {
            State = stateData[row]
            return stateData[row]
        }
        else if pickerView == TownPicker {
            Town = townData[row]
            return townData[row]
        }
        
        return ""
    }
    
    //sets final variables to the selected row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print("2:", pickerView)
        if pickerView == WeekPicker {
            dkWeek = false
            Week = weekData[row]
        }
        else if pickerView == StatePicker {
            dkState = false
            State = stateData[row]
        }
        else if pickerView == TownPicker {
            dkTown = false
            Town = townData[row]
        }
    }
    
    func TimeDiffOK(date1: Date, date2: Date) -> Bool {
        var h1 = Calendar.current.component(.hour, from: date1)
        var h2 = Calendar.current.component(.hour, from: date2)
        let m1 = Calendar.current.component(.minute, from: date1)
        let m2 = Calendar.current.component(.minute, from: date2)
        
        // Deal with noon and 1PM
        if h1 == 12 && h2 == 1 {
            h2 = 13
        }
        if h1 == 1 && h2 == 12 {
            h1 = 13
        }
        return abs(h1*60 + m1 - h2*60 - m2) < 15*60
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  */
}
