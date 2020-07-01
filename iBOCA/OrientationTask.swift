//
//  OrientationTask.swift
//  iBOCA
//
//  Created by Ellison Lim on 8/1/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

var firstTimeThrough = true
//declare variables to be defined by pickerviews
var startTime = Foundation.Date()

class OrientationTask: BaseViewController {
    // MARK: - Outlet
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var btnComplete: GradientButton!
    
    @IBOutlet weak var vShadowCurrentDate: UIView!
    @IBOutlet weak var vCurrentDate: UIView!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var currentDate: UIDatePicker!
    @IBOutlet weak var btnDontKnowMonth: UIButton!
    @IBOutlet weak var btnDontKnowDate: UIButton!
    @IBOutlet weak var btnDontKnowYear: UIButton!
    
    @IBOutlet weak var vShadowDayOfTheWeek: UIView!
    @IBOutlet weak var vDayOfTheWeek: UIView!
    @IBOutlet weak var lblDayOfTheWeek: UILabel!
    @IBOutlet weak var WeekPicker: UIPickerView!
    @IBOutlet weak var btnDontKnowWeek: UIButton!
    
    @IBOutlet weak var vShadowCurrentState: UIView!
    @IBOutlet weak var vCurrentState: UIView!
    @IBOutlet weak var lblCurrentState: UILabel!
    @IBOutlet weak var StatePicker: UIPickerView!
    @IBOutlet weak var btnDontKnowState: UIButton!
    
    @IBOutlet weak var vShadowCurrentTime: UIView!
    @IBOutlet weak var vCurrentTime: UIView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var currentTime: UIDatePicker!
    @IBOutlet weak var btnDontKnowTime: UIButton!
    
    @IBOutlet weak var vCounterTimer: UIView!
    
    // MARK: - Variable
    var counterTime: CounterTimeView!
    var timerOrientationTask = Timer()
    var startTimeTask = Foundation.Date()
    var body:String?
    let defaultBlueColor: UIColor = UIColor.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
    var Week : String?
    var State : String?
    var Date : String?
    var Time : String?
    var TimeOK : Bool = false
    var DateOK : Bool = false
    
    var dkDate : Bool = false {
        didSet { }
    }
    
    var dkMonth : Bool = false {
        didSet { }
    }
    
    var dkYear : Bool = false {
        didSet { }
    }
    
    var dkWeek : Bool = false {
        didSet { }
    }
    
    var dkState : Bool = false {
        didSet { }
    }
    
    var dkTime : Bool = false {
        didSet { }
    }
    
    let weekData = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Do not know"]
    
    let stateData = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia","Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming", "Don't Know"]
    
    // QuickStart Mode
    var quickStartModeOn: Bool = false
    var didBackToResult: (() -> ())?
    var didCompleted: (() -> ())?
    
    // MARK: - Load Views
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check location permission before continue
        if !LocationManager.shared.isLocationServiceAvailable() && !LocationManager.shared.isLocationServiceNotEnable() {
            let alertController = UIAlertController.init(title: "", message: "Please turn on location permission to do this test.", preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        startTime = Foundation.Date()
        // delegate pickerviews
        WeekPicker.delegate = self
        StatePicker.delegate = self
        
        LocationManager.shared.requestLocationServiceIfNeeded(in: self)
        
        dkDate = false
        dkMonth = false
        dkYear = false
        
        // QuickStart Mode
        if quickStartModeOn {
           lblBack.text = "RESULT"
        }
        
        Status[TestOrientation] = TestStatus.NotStarted
        
        // Get the random State
        let indexState = Int(arc4random_uniform(UInt32(stateData.count)))
        State = stateData[indexState]
        StatePicker.selectRow(indexState, inComponent: 0, animated: true)
        
        let formatter = DateFormatter()
        if let date_random = Foundation.Date().generateRandomDate(daysBack: 20) {
            // Get the random date
            formatter.dateFormat = "y-MM-dd"
            currentDate.setDate( date_random,  animated: false)
            self.Date = formatter.string(from: currentDate.date)
            DateOK = true
            
            // Get the random time
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            currentTime.setDate(date_random,  animated: false)
            formatter.dateFormat = "HH:mm"
            Time = formatter.string(from: currentTime.date)
            TimeOK = TimeDiffOK(date1: startTime, date2: currentDate.date)
            
            // Get the random week
            Week = weekData[WeekPicker.selectedRow(inComponent: 0)]
            formatter.dateFormat = "EEEE"
            let wk = formatter.string(from: date_random)
            let v = weekData.firstIndex(of: wk)
            if (v != nil) {
                Week  = wk
                WeekPicker.selectRow(v!, inComponent: 0, animated: false)
            }
        }
        
        currentDate.isUserInteractionEnabled = true
        currentTime.isUserInteractionEnabled = true
        WeekPicker.isUserInteractionEnabled = true
        StatePicker.isUserInteractionEnabled = true
        currentDate.alpha = 1.0
        currentTime.alpha = 1.0
        WeekPicker.alpha = 1.0
        StatePicker.alpha = 1.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timerOrientationTask.invalidate()
    }
    
    deinit {
        self.timerOrientationTask.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  */
}

// MARK: - Setup UI
extension OrientationTask {
    fileprivate func setupViews() {
        // Label Back
        self.lblBack.font = Font.font(name: Font.Montserrat.bold, size: 28.0)
        self.lblBack.textColor = Color.color(hexString: "#013AA5")
        self.lblBack.addTextSpacing(-0.56)
        
        // View Counter Timer
        self.setupViewCounterTimer()
        
        // Button complete
        let colors = [Color.color(hexString: "#69C394"), Color.color(hexString: "#40B578")]
        let shadowColor = Color.color(hexString: "#69C394").withAlphaComponent(0.7)
        self.btnComplete.setTitle(title: "COMPLETE", withFont: Font.font(name: Font.Montserrat.bold, size: 18.0))
        self.btnComplete.setupShadow(withColor: shadowColor, sketchBlur: 9.0, opacity: 1)
        self.btnComplete.setupGradient(arrColor: colors, direction: .topToBottom)
        self.btnComplete.addTextSpacing(-0.36)
        self.btnComplete.render()
        
        // View Current Date
        self.setupViewCurrentDate()
        
        // 3 button Don't know month, date, year
        self.setupGroupButton()
        
        // View Day Of The Week
        self.setupViewDayOfTheWeek()
        
        // View Current State
        self.setupViewCurrentState()
        
        // View Current Time
        self.setupViewCurrentTime()
    }
    
    // Setup View Current Date
    fileprivate func setupViewCurrentDate() {
        self.lblCurrentDate.font = Font.font(name: Font.Montserrat.bold, size: 18.0)
        
        self.vShadowCurrentDate.layer.cornerRadius = 8.0
        self.vShadowCurrentDate.layer.shadowColor = UIColor.init(red: 100/255.0, green: 155/255.0, blue: 255/255.0, alpha: 0.32).cgColor
        self.vShadowCurrentDate.layer.shadowOpacity = 1.0
        self.vShadowCurrentDate.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vShadowCurrentDate.layer.shadowRadius = 10 / 2.0
        self.vShadowCurrentDate.layer.shadowPath = nil
        self.vShadowCurrentDate.layer.masksToBounds = false
        
        self.vCurrentDate.clipsToBounds = true
        self.vCurrentDate.backgroundColor = UIColor.white
        self.vCurrentDate.layer.cornerRadius = 8.0
    }
    
    // Setup 3 button Don't know month, date, year
    fileprivate func setupGroupButton() {
        // Button Don't Know Month
        self.btnDontKnowMonth.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.btnDontKnowMonth.setTitleColor(UIColor.black, for: .normal)
        self.btnDontKnowMonth.setTitleColor(UIColor.black, for: .selected)
        self.btnDontKnowMonth.tintColor = UIColor.black
        self.btnDontKnowMonth.setTitle("Don't know month", for: .normal)
        self.btnDontKnowMonth.setTitle("Don't know month", for: .selected)
        self.btnDontKnowMonth.backgroundColor = UIColor.white
        self.btnDontKnowMonth.layer.cornerRadius = 8.0
        self.btnDontKnowMonth.layer.borderWidth = 2.0
        self.btnDontKnowMonth.layer.borderColor = Color.color(hexString: "#FE786A").cgColor
        
        // Button Don't Know Date
        self.btnDontKnowDate.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.btnDontKnowDate.setTitleColor(UIColor.black, for: .normal)
        self.btnDontKnowDate.setTitleColor(UIColor.black, for: .selected)
        self.btnDontKnowDate.tintColor = UIColor.white
        self.btnDontKnowDate.setTitle("Don't know date", for: .normal)
        self.btnDontKnowDate.setTitle("Don't know date", for: .selected)
        self.btnDontKnowDate.backgroundColor = UIColor.white
        self.btnDontKnowDate.layer.cornerRadius = 8.0
        self.btnDontKnowDate.layer.borderWidth = 2.0
        self.btnDontKnowDate.layer.borderColor = Color.color(hexString: "#FE786A").cgColor
        
        // Button Don't Know Year
        self.btnDontKnowYear.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.btnDontKnowYear.setTitleColor(UIColor.black, for: .normal)
        self.btnDontKnowYear.setTitleColor(UIColor.black, for: .selected)
        self.btnDontKnowYear.tintColor = UIColor.black
        self.btnDontKnowYear.setTitle("Don't know year", for: .normal)
        self.btnDontKnowYear.setTitle("Don't know year", for: .selected)
        self.btnDontKnowYear.backgroundColor = UIColor.white
        self.btnDontKnowYear.layer.cornerRadius = 8.0
        self.btnDontKnowYear.layer.borderWidth = 2.0
        self.btnDontKnowYear.layer.borderColor = Color.color(hexString: "#FE786A").cgColor
    }
    
    // Setup View Day Of The Week
    fileprivate func setupViewDayOfTheWeek() {
        self.lblDayOfTheWeek.font = Font.font(name: Font.Montserrat.bold, size: 18.0)
        
        self.vShadowDayOfTheWeek.layer.cornerRadius = 8.0
        self.vShadowDayOfTheWeek.layer.shadowColor = UIColor.init(red: 100/255.0, green: 155/255.0, blue: 255/255.0, alpha: 0.32).cgColor
        self.vShadowDayOfTheWeek.layer.shadowOpacity = 1.0
        self.vShadowDayOfTheWeek.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vShadowDayOfTheWeek.layer.shadowRadius = 10 / 2.0
        self.vShadowDayOfTheWeek.layer.shadowPath = nil
        self.vShadowDayOfTheWeek.layer.masksToBounds = false
        
        self.vDayOfTheWeek.clipsToBounds = true
        self.vDayOfTheWeek.backgroundColor = UIColor.white
        self.vDayOfTheWeek.layer.cornerRadius = 8.0
        
        self.btnDontKnowWeek.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.btnDontKnowWeek.setTitleColor(UIColor.black, for: .normal)
        self.btnDontKnowWeek.setTitleColor(UIColor.black, for: .selected)
        self.btnDontKnowWeek.tintColor = UIColor.black
        self.btnDontKnowWeek.setTitle("Don't know", for: .normal)
        self.btnDontKnowWeek.setTitle("Don't know", for: .selected)
        self.btnDontKnowWeek.backgroundColor = UIColor.white
        self.btnDontKnowWeek.layer.cornerRadius = 8.0
        self.btnDontKnowWeek.layer.borderWidth = 2.0
        self.btnDontKnowWeek.layer.borderColor = Color.color(hexString: "#FE786A").cgColor
    }
    
    // Setup View Current State
    fileprivate func setupViewCurrentState() {
        self.lblCurrentState.font = Font.font(name: Font.Montserrat.bold, size: 18.0)
        
        self.vShadowCurrentState.layer.cornerRadius = 8.0
        self.vShadowCurrentState.layer.shadowColor = UIColor.init(red: 100/255.0, green: 155/255.0, blue: 255/255.0, alpha: 0.32).cgColor
        self.vShadowCurrentState.layer.shadowOpacity = 1.0
        self.vShadowCurrentState.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vShadowCurrentState.layer.shadowRadius = 10 / 2.0
        self.vShadowCurrentState.layer.shadowPath = nil
        self.vShadowCurrentState.layer.masksToBounds = false
        
        self.vCurrentState.clipsToBounds = true
        self.vCurrentState.backgroundColor = UIColor.white
        self.vCurrentState.layer.cornerRadius = 8.0
        
        self.btnDontKnowState.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.btnDontKnowState.setTitleColor(UIColor.black, for: .normal)
        self.btnDontKnowState.setTitleColor(UIColor.black, for: .selected)
        self.btnDontKnowState.tintColor = UIColor.black
        self.btnDontKnowState.setTitle("Don't know", for: .normal)
        self.btnDontKnowState.setTitle("Don't know", for: .selected)
        self.btnDontKnowState.backgroundColor = UIColor.white
        self.btnDontKnowState.layer.cornerRadius = 8.0
        self.btnDontKnowState.layer.borderWidth = 2.0
        self.btnDontKnowState.layer.borderColor = Color.color(hexString: "#FE786A").cgColor
    }
    
    // Setup View Current Time
    fileprivate func setupViewCurrentTime() {
        self.lblCurrentTime.font = Font.font(name: Font.Montserrat.bold, size: 18.0)
        
        self.vShadowCurrentTime.layer.cornerRadius = 8.0
        self.vShadowCurrentTime.layer.shadowColor = UIColor.init(red: 100/255.0, green: 155/255.0, blue: 255/255.0, alpha: 0.32).cgColor
        self.vShadowCurrentTime.layer.shadowOpacity = 1.0
        self.vShadowCurrentTime.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vShadowCurrentTime.layer.shadowRadius = 10 / 2.0
        self.vShadowCurrentTime.layer.shadowPath = nil
        self.vShadowCurrentTime.layer.masksToBounds = false
        
        self.vCurrentTime.clipsToBounds = true
        self.vCurrentTime.backgroundColor = UIColor.white
        self.vCurrentTime.layer.cornerRadius = 8.0
        
        self.btnDontKnowTime.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.btnDontKnowTime.setTitleColor(UIColor.black, for: .normal)
        self.btnDontKnowTime.setTitleColor(UIColor.black, for: .selected)
        self.btnDontKnowTime.tintColor = UIColor.black
        self.btnDontKnowTime.setTitle("Don't know", for: .normal)
        self.btnDontKnowTime.setTitle("Don't know", for: .selected)
        self.btnDontKnowTime.backgroundColor = UIColor.white
        self.btnDontKnowTime.layer.cornerRadius = 8.0
        self.btnDontKnowTime.layer.borderWidth = 2.0
        self.btnDontKnowTime.layer.borderColor = Color.color(hexString: "#FE786A").cgColor
    }
    
    // View Counter Timer
    fileprivate func setupViewCounterTimer() {
        // View Couter Timer
        self.counterTime = CounterTimeView()
        self.vCounterTimer.backgroundColor = .clear
        self.vCounterTimer.addSubview(self.counterTime)
        self.counterTime.centerXAnchor.constraint(equalTo: self.vCounterTimer.centerXAnchor).isActive = true
        self.counterTime.centerYAnchor.constraint(equalTo: self.vCounterTimer.centerYAnchor).isActive = true
        self.startTimeTask = Foundation.Date()
        self.timerOrientationTask.invalidate()
        self.runTimer()
    }
    
    fileprivate func runTimer() {
        self.timerOrientationTask = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.timerOrientationTask.fire()
    }
    
    @objc func updateTime(timer: Timer) {
        // Update data into Counter Timer View
        self.counterTime.setTimeWith(startTime: self.startTimeTask, currentTime: Foundation.Date())
    }
}

// MARK: - Action
extension OrientationTask {
    @IBAction func actionBack(_ sender: Any) {
        if Status[TestOrientation] != TestStatus.Done {
            Status[TestOrientation] = TestStatus.NotStarted
        }
        self.timerOrientationTask.invalidate()
        
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            didBackToResult?()
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DoneButton(_ sender: AnyObject) {
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            QuickStartManager.showAlertCompletion(viewController: self, cancel: {
                self.timerOrientationTask.invalidate()
                self.completeTest()
                
                self.didBackToResult?()
            }, ok: {
                self.timerOrientationTask.invalidate()
                self.completeTest()
                
                self.didCompleted?()
            })
            return
        }
        
        let alert = UIAlertController(title: "Confirm", message: "Do you really want to complete this test?", preferredStyle: .alert)
        
        let noAction = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction.init(title: "Yes", style: .default) { (action) in
            self.timerOrientationTask.invalidate()
            self.completeTest()
            // Show MainViewController
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    @IBAction func updateTime(_ sender: Any) {
        let d:UIDatePicker = sender as! UIDatePicker
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        Time = formatter.string(from: d.date)
        TimeOK = TimeDiffOK(date1: startTime, date2: d.date)
        
        dkTime = false
    }
    
    @IBAction func DontKnowMonth(_ sender: UIButton) {
        if !dkMonth {
            self.btnDontKnowMonth.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowMonth.backgroundColor = Color.color(hexString: "#FE786A")
            dkMonth = true
        } else {
            self.btnDontKnowMonth.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowMonth.backgroundColor = UIColor.white
            dkMonth = false
        }
    }
    
    @IBAction func DontKnowDate(_ sender: Any) {
        if !dkDate {
            self.btnDontKnowDate.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowDate.backgroundColor = Color.color(hexString: "#FE786A")
            dkDate = true
        } else {
            self.btnDontKnowDate.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowDate.backgroundColor = UIColor.white
            dkDate = false
        }
    }
    
    @IBAction func DontKnowYear(_ sender: UIButton) {
        if !dkYear {
            self.btnDontKnowYear.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowYear.backgroundColor = Color.color(hexString: "#FE786A")
            dkYear = true
        } else {
            self.btnDontKnowYear.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowYear.backgroundColor = UIColor.white
            dkYear = false
        }
    }
    
    @IBAction func DontKnowWeek(_ sender: Any) {
        if !dkWeek {
            self.btnDontKnowWeek.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowWeek.backgroundColor = Color.color(hexString: "#FE786A")
            Week = "Don't know"
            dkWeek = true
        } else {
            self.btnDontKnowWeek.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowWeek.backgroundColor = UIColor.white
            dkWeek = false
        }
    }
    
    @IBAction func DontKnowState(_ sender: Any) {
        if !dkState {
            self.btnDontKnowState.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowState.backgroundColor = Color.color(hexString: "#FE786A")
            State = "Don't know"
            dkState = true
        } else {
            self.btnDontKnowState.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowState.backgroundColor = UIColor.white
            dkState = false
        }
    }
    
    @IBAction func DontKnowTime(_ sender: Any) {
        if !dkTime {
            self.btnDontKnowTime.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowTime.backgroundColor = Color.color(hexString: "#FE786A")
            Time = "Don't know"
            dkTime = true
            TimeOK = false
        } else {
            self.btnDontKnowTime.setTitleColor(UIColor.black, for: .normal)
            self.btnDontKnowTime.backgroundColor = UIColor.white
            dkTime = false
            TimeOK = true
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
        
        return abs(h1*60 + m1 - h2*60 - m2) < 15
    }
    
    private func completeTest() {
        let d:UIDatePicker = self.currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        Date = dateFormatter.string(from: d.date)
        let v = startTime.timeIntervalSince(d.date)
        if abs(v) < 60*60*24 {
            DateOK = true
        } else {
            DateOK = false
        }
        
        let result = Results()
        result.name = TestName.ORIENTATION
        result.startTime = startTime
        result.endTime = Foundation.Date()
        
        result.json["Week Given"] = Week!
        result.json["State Given"] = State!
        result.json["Date Given"] = Date!
        result.json["Time Given"] = Time!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        let rightDate = formatter.string(from: startTime)
        result.json["Date Tested"] = rightDate
        formatter.dateFormat = "HH:mm"
        let rightTime = formatter.string(from: startTime)
        result.json["Time Tested"] = rightTime
        formatter.dateFormat = "EEEE"
        let rightWeek = formatter.string(from: startTime)
        result.json["Week Tested"] = rightWeek
        let WeekOK = rightWeek == Week!
        
        var stateOK = false
        let currentState = LocationManager.shared.currentState
        if !currentState.isEmpty {
            stateOK = currentState == State!
        }
        
        result.json["Time Correct"] = TimeOK
        result.json["Date Correct"] = DateOK
        result.json["Week Correct"] = WeekOK
        result.json["Don't know date"] = dkDate
        result.json["Don't know month"] = dkMonth
        result.json["Don't know year"] = dkYear
        result.json["State Correct"] = stateOK
        
        var tempNumberErrors = 0
        if stateOK == false {
            result.shortDescription = "State: \(State!)(\(currentState)) "
            tempNumberErrors += 1
        }
        if WeekOK == false {
            result.shortDescription = result.shortDescription! + " Week: \(Week!)(\(rightWeek)) "
            tempNumberErrors += 1
        }
        if DateOK == false {
            result.shortDescription = result.shortDescription! + " Date: \(Date!)(\(rightDate)) "
            tempNumberErrors += 1
        }
        if dkDate {
            result.shortDescription = result.shortDescription! + " Don't know date "
            tempNumberErrors += 1
        }
        if dkMonth {
            result.shortDescription = result.shortDescription! + " Don't know month "
            tempNumberErrors += 1
        }
        
        if dkYear {
            result.shortDescription = result.shortDescription! + " Don't know year "
            tempNumberErrors += 1
        }
        
        if TimeOK == false {
            result.shortDescription = result.shortDescription! + " Time: \(Time!)(\(rightTime)) "
            tempNumberErrors += 1
        }
        result.numErrors = tempNumberErrors
        result.longDescription.add(result.shortDescription!)
        resultsArray.add(result)
        Status[TestOrientation] = TestStatus.Done
    }
}

// MARK: - UIPickerView Delegate
extension OrientationTask: UIPickerViewDelegate, UIPickerViewDataSource {
    //pickerview setup and whatnot
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //returns length of pickerview contents
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == WeekPicker {
            return weekData.count
        }
        else if pickerView == StatePicker {
            return stateData.count
        }
        return 1
    }
    
    ////sets the final variables to selected row of the pickerview's text
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == WeekPicker {
            Week = weekData[row]
            return weekData[row]
        }
        else if pickerView == StatePicker {
            State = stateData[row]
            return stateData[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == WeekPicker {
            var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
                pickerLabel?.textAlignment = .center
                pickerLabel?.addTextSpacing(-0.36)
            }
            pickerLabel?.text = weekData[row]
            pickerLabel?.textColor = UIColor.black
            Week = weekData[row]
            
            return pickerLabel!
        }
        else {
            var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
                pickerLabel?.textAlignment = .center
                pickerLabel?.addTextSpacing(-0.36)
            }
            pickerLabel?.text = stateData[row]
            pickerLabel?.textColor = UIColor.black
            State = stateData[row]
            
            return pickerLabel!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 56.0
    }
}

// MARK: - UITextField Delegate, UITextView Delegate
extension OrientationTask: UITextFieldDelegate, UITextViewDelegate {
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
}

// MARK: - MFMailComposeViewController Delegate
extension OrientationTask: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension Date
extension Date {
    func generateRandomDate(daysBack: Int) -> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        offsetComponents.year = Int.random(in: -10...10)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0))
        
        return randomDate
    }
}
