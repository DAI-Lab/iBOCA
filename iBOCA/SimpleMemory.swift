//
//  SimpleMemoryTask.swift
//  iBOCA
//
//  Created by School on 8/29/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import Foundation

import UIKit

var afterBreakSM = Bool()

var recognizeIncorrectSM = [String]()

var imagesSM = [String]()

var imageSetSM = Int()
var incorrectImageSetSM = Int()

var startTimeSM = TimeInterval()
var timerSM = Timer()
var StartTimer = Foundation.Date()
class SimpleMemoryTask: ViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var delayLabel: UILabel!
    
    @IBOutlet weak var resultTitleLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var testPicker: UIPickerView!
    var TestTypes : [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    @IBOutlet weak var incorrectPicker: UIPickerView!
    var IncorrectTypes: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    @IBOutlet weak var testPickerLabel: UILabel!
    @IBOutlet weak var incorrectPickerLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultList : [String:Any] = [:]
    var recognizeErrors = [Int]()
    var recognizeTimes = [Double]()
    var recallTimes = [Double]()
    var recallIncorrectTimes = [Double]()
    
    var delayTime = Double()
    
    var totalTime = 60
    
    var ended = false
    var isStartNew = false
    
    @IBOutlet weak var next1: UIButton!
    @IBOutlet weak var start: GradientButton!
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var btnArrowLeft: UIButton!
    @IBOutlet weak var btnArrowRight: UIButton!
    
    var testCount = 0
    
    var images0 = ["binoculars", "can", "cat", "elbow", "pipe", "rainbow"]
    var images1 = ["bottle", "coral", "ladder", "owl", "saw", "shoe"]
    var images2 = ["bee", "corn", "lamp", "sheep", "violin", "watch"]
    var images3 = ["basket", "candle", "doll", "knife", "skeleton", "star"]
    var images4 = ["briefcase", "chair", "duck", "microphone", "needle", "stairs"]
    var images5 = ["baseball", "drum", "necklace", "shovel", "tank", "toilet"]
    var images6 = ["anchor", "eyebrow", "flashlight", "glove", "moon", "sword"]
    var images7 = ["lion", "nut", "piano", "ring", "scissors", "whisk"]
    
    var imageName = ""
    var image = UIImage()
    var imageView = UIImageView()
    
    var imageName1 = ""
    var image1 = UIImage()
    
    var imageName2 = ""
    var image2 = UIImage()
    
    var buttonList = [UIButton]()
    
    var buttonTaps = [Bool]()
    
    var recallIncorrect = Int()
    var recallPlus = UIButton()
    var recallLabel = UILabel()
    
    var arrowButton1 = UIButton()
    var arrowButton2 = UIButton()
    
    var orderRecognize = [Int]()
    
    var testSelectButtons : [UIButton] = []
    
    var result: Results!
    
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var lblDescTask: UILabel!
    
    @IBOutlet weak var collectionViewLevel: UICollectionView!
    
    @IBOutlet weak var vShadowTask: UIView!
    @IBOutlet weak var vTask: UIView!
    @IBOutlet weak var ivTask: UIImageView!
    
    @IBOutlet weak var vDelay: UIView!
    @IBOutlet weak var lblDescDelay: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupViews()
        
        result = Results()
        result.name = "Simple Memory"
        result.startTime = StartTimer
        
        testPicker.delegate = self
        testPicker.transform = CGAffineTransform(scaleX: 0.8, y: 1.0)
        
        incorrectPicker.delegate = self
        incorrectPicker.transform = CGAffineTransform(scaleX: 0.8, y: 1.0)
        
        arrowButton1 = UIButton(type: UIButtonType.custom) as UIButton
        
        arrowButton2 = UIButton(type: UIButtonType.custom) as UIButton
        
        next1.isHidden = true
        
        //back.isEnabled = true
        
        start.isHidden = false
        
        // Hide arrow
        self.btnArrowLeft.isHidden = true
        self.btnArrowRight.isHidden = true
        
        afterBreakSM = false
        
        // Setup tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        
        if(afterBreakSM == true){
//            timerSM = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateInDelay), userInfo: nil, repeats: true)
            timerSM = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeDecreases), userInfo: nil, repeats: true)
            timerSM.fire()
            delayLabel.text = "Recommended delay: 1 minute"
//            start.isHidden = false
            testPicker.isHidden = true
            incorrectPicker.isHidden = true
            
            testPickerLabel.isHidden = true
            incorrectPickerLabel.isHidden = true
            for b in testSelectButtons {
                b.isHidden = true
            }
            
            start.removeTarget(self, action: #selector(startNewTask), for:.touchUpInside)
            start.removeTarget(self, action: #selector(startDisplayAlert), for:.touchUpInside)
            start.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
        }
        else{
//            start.isHidden = true
            testPicker.reloadAllComponents()
            incorrectPicker.reloadAllComponents()
            
            testPicker.selectRow(0, inComponent: 0, animated: true)
            incorrectPicker.selectRow(0, inComponent: 0, animated: true)
            
            testPicker.isHidden = false
            incorrectPicker.isHidden = false
            
            testPickerLabel.isHidden = false
            incorrectPickerLabel.isHidden = false
            setupTestSelectButtons()
            
            imageSetSM = 0
            incorrectImageSetSM = 0
            recognizeIncorrectSM = images0
            imagesSM = images0
            
            start.isEnabled = false
            
            start.removeTarget(self, action: #selector(startNewTask), for:.touchUpInside)
            start.removeTarget(self, action: #selector(startAlert), for:.touchUpInside)
            start.addTarget(self, action: #selector(startDisplayAlert), for:.touchUpInside)
//            startAlert()
        }
        
        // MARK: - TODO
        self.testPicker.isHidden = true
        self.incorrectPicker.isHidden = true
        self.testPickerLabel.isHidden = true
        self.incorrectPickerLabel.isHidden = true
        self.start.isHidden = true
    }
    
    func setupTestSelectButtons() {
        testSelectButtons = []
        for (i, val) in ["Test A", "Test B", "Test C", "Test D"].enumerated() {
            let button  = UIButton(frame: CGRect(x: 150+200*i, y: 250, width: 150, height: 50))
            button.setTitle(String(val), for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40.0)
            button.addTarget(self, action: #selector(SimpleMemoryTask.StartSelectButtonTapped), for: .touchDown)
            button.isHidden = false
            testSelectButtons.append(button)
            
            // MARK: - TODO
//            view.addSubview(button)
        }
    }
    
    @objc fileprivate func StartSelectButtonTapped(button: UIButton){
        let title = button.title(for: .normal)!
        switch title {
        case "Test A":
            testPicker.selectRow(0, inComponent: 0, animated: true)
            incorrectPicker.selectRow(4, inComponent: 0, animated: true)
            imagesSM = images0
            imageSetSM = 0
            recognizeIncorrectSM = images4
            incorrectImageSetSM = 4
        case "Test B":
            testPicker.selectRow(1, inComponent: 0, animated: true)
            incorrectPicker.selectRow(5, inComponent: 0, animated: true)
            imagesSM = images1
            imageSetSM = 1
            recognizeIncorrectSM = images5
            incorrectImageSetSM = 5
        case "Test C":
            testPicker.selectRow(2, inComponent: 0, animated: true)
            incorrectPicker.selectRow(6, inComponent: 0, animated: true)
            imagesSM = images2
            imageSetSM = 2
            recognizeIncorrectSM = images6
            incorrectImageSetSM = 6
        case "Test D":
            testPicker.selectRow(3, inComponent: 0, animated: true)
            incorrectPicker.selectRow(7, inComponent: 0, animated: true)
            imagesSM = images3
            imageSetSM = 3
            recognizeIncorrectSM = images7
            incorrectImageSetSM = 7
        default:
            testPicker.selectRow(0, inComponent: 0, animated: true)
            incorrectPicker.selectRow(0, inComponent: 0, animated: true)
            imagesSM = images0
            imageSetSM = 0
            recognizeIncorrectSM = images0
            incorrectImageSetSM = 0
        }
        
        if(TestTypes[testPicker.selectedRow(inComponent: 0)] == IncorrectTypes[incorrectPicker.selectedRow(inComponent: 0)]){
            start.isEnabled = false
        }
        else{
            start.isEnabled = true
        }

        
    }
    
    func startAlert(){
        
        //back.isEnabled = false
        next1.isHidden = true
        
        let startAlert = UIAlertController(title: "Start", message: "Choose start option.", preferredStyle: .alert)
        
        startAlert.addAction(UIAlertAction(title: "Start New Task", style: .default, handler: { (action) -> Void in
            print("start new")
//            Status[TestSimpleMemory] = TestStatus.Running
//            self.startNewTask()
            
            recognizeIncorrectSM = self.images0
            imagesSM = self.images0
            imageSetSM = 0
            incorrectImageSetSM = 0
            
            self.testPicker.reloadAllComponents()
            self.incorrectPicker.reloadAllComponents()
            
            self.testPicker.selectRow(0, inComponent: 0, animated: true)
            self.incorrectPicker.selectRow(0, inComponent: 0, animated: true)
            
            self.testPicker.isHidden = false
            self.incorrectPicker.isHidden = false
            
            self.testPickerLabel.isHidden = false
            self.incorrectPickerLabel.isHidden = false
            self.setupTestSelectButtons()
            
            self.startNewTask()
            
            //action
        }))
        
        if(afterBreakSM == true){
            startAlert.addAction(UIAlertAction(title: "Resume Task", style: .default, handler: { (action) -> Void in
                print("resume old")
                
                self.testPicker.isHidden = true
                self.incorrectPicker.isHidden = true
                
                self.testPickerLabel.isHidden = true
                self.incorrectPickerLabel.isHidden = true
                for b in self.testSelectButtons {
                    b.isHidden = true
                }
                
                self.start.isHidden = true
                
                self.resumeTask()
                //action
            }))
        }
        
        startAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            print("cancel")
            //self.back.isEnabled = true
            //action
        }))
        
        self.present(startAlert, animated: true, completion: nil)
    }
    
    func startNewTask(){
        result = Results()
        result.name = "Simple Memory"
        result.startTime = Foundation.Date()
        totalTime = 60
        ended = true
        self.isStartNew = true
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isStartNew = false
        }
        timerSM.invalidate()
        afterBreakSM = false
        Status[TestSimpleMemory] = TestStatus.NotStarted
        
        buttonTaps = [Bool]()
        testCount = 0
        recognizeTimes = [Double]()
        recognizeErrors = [Int]()
        orderRecognize = [Int]()
        resultTitleLabel.text = ""
        resultLabel.text = ""
        timerLabel.text = ""
        delayLabel.text = ""
        afterBreakSM = false
        
        
        start.isHidden = false
        start.isEnabled = false
        timerLabel.isHidden = false
        
        start.setTitle("Start", for: .normal)
        start.setTitle("Start", for: .selected)
        
        start.removeTarget(self, action: #selector(startNewTask), for:.touchUpInside)
        start.removeTarget(self, action: #selector(startAlert), for:.touchUpInside)
        start.addTarget(self, action: #selector(startDisplayAlert), for:.touchUpInside)
        
    }
    
    func startDisplayAlert(){
        // TODO: -
        self.collectionViewLevel.isHidden = true
        self.lblBack.text = "BACK"
        self.lblDescTask.isHidden = true
        
        self.vShadowTask.isHidden = false
        self.vTask.isHidden = false
        
        Status[TestSimpleMemory] = TestStatus.Running
        
        start.isHidden = true
        testPicker.isHidden = true
        incorrectPicker.isHidden = true
        
        testPickerLabel.isHidden = true
        incorrectPickerLabel.isHidden = true
        for b in testSelectButtons {
            b.isHidden = true
        }
        
        //back.isEnabled = false
        
        let newStartAlert = UIAlertController(title: "Display", message: "Ask patient to name and remember these images.", preferredStyle: .alert)
        newStartAlert.addAction(UIAlertAction(title: "Start", style: .default, handler: { (action) -> Void in
            print("start")
            self.display()
            //action
        }))
        self.present(newStartAlert, animated: true, completion: nil)
        
    }
    
    func numberOfComponentsInPickerView(_ pickerView : UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == testPicker {
            
            return TestTypes.count
        }
        if pickerView == incorrectPicker {
            
            return IncorrectTypes.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == testPicker {
            
            return TestTypes[row]
        }
        if pickerView == incorrectPicker {
            
            return IncorrectTypes[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print("2:", pickerView)
        if pickerView == testPicker {
            
            if row == 0 {
                imagesSM = images0
                imageSetSM = 0
            }
            if row == 1 {
                imagesSM = images1
                imageSetSM = 1
            }
            if row == 2 {
                imagesSM = images2
                imageSetSM = 2
            }
            if row == 3 {
                imagesSM = images3
                imageSetSM = 3
            }
            if row == 4 {
                imagesSM = images4
                imageSetSM = 4
            }
            if row == 5 {
                imagesSM = images5
                imageSetSM = 5
            }
            if row == 6 {
                imagesSM = images6
                imageSetSM = 6
            }
            if row == 7 {
                imagesSM = images7
                imageSetSM = 7
            }
            
            if(TestTypes[testPicker.selectedRow(inComponent: 0)] == IncorrectTypes[incorrectPicker.selectedRow(inComponent: 0)]){
                start.isEnabled = false
            }
            else{
                start.isEnabled = true
            }

        }
        else if pickerView == incorrectPicker {
            if row == 0 {
                recognizeIncorrectSM = images0
                incorrectImageSetSM = 0
            }
            if row == 1 {
                recognizeIncorrectSM = images1
                incorrectImageSetSM = 1
            }
            if row == 2 {
                recognizeIncorrectSM = images2
                incorrectImageSetSM = 2
            }
            if row == 3 {
                recognizeIncorrectSM = images3
                incorrectImageSetSM = 3
            }
            if row == 4 {
                recognizeIncorrectSM = images4
                incorrectImageSetSM = 4
            }
            if row == 5 {
                recognizeIncorrectSM = images5
                incorrectImageSetSM = 5
            }
            if row == 6 {
                recognizeIncorrectSM = images6
                incorrectImageSetSM = 6
            }
            if row == 7 {
                recognizeIncorrectSM = images7
                incorrectImageSetSM = 7
            }
            
            if(TestTypes[testPicker.selectedRow(inComponent: 0)] == IncorrectTypes[incorrectPicker.selectedRow(inComponent: 0)]){
                start.isEnabled = false
            }
            else{
                start.isEnabled = true
            }
            
        }
        
        print("imagesSM = \(imagesSM), recognizeIncorrectSM = \(recognizeIncorrectSM)")
    }
    
    func display(){
        
        testCount = 0
        
        print("testCount = \(testCount), imagesSM = \(imagesSM)")
        print("imagesSM[testCount] = \(imagesSM[testCount])")
        
        // Show Arrow
        self.btnArrowRight.isHidden = false
        self.btnArrowLeft.isHidden = true
//        outputImage(name: imagesSM[testCount])
        self.outputImage(withImageName: imagesSM[testCount])
    }
    
    func outputImage(name: String){
        
        imageView.removeFromSuperview()
        imageName = name
        image = UIImage(named: imageName)!
        
        var x = CGFloat()
        var y = CGFloat()
        if 0.56*image.size.width < image.size.height {
            y = 575.0
            x = (575.0*(image.size.width)/(image.size.height))
        }
        else {
            x = 575.0
            y = (575.0*(image.size.height)/(image.size.width))
        }
        
        imageView = UIImageView(frame:CGRect(x: (512.0-(x/2)), y: (471.0-(y/2)), width: x, height: y))
        
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        // Check Show/ Hide Arrow
        if testCount == 0 {
            self.btnArrowLeft.isHidden = true
            self.btnArrowRight.isHidden = false
        }
        else if testCount == imagesSM.count {
            self.btnArrowLeft.isHidden = false
            self.btnArrowRight.isHidden = true
        }
        else {
            self.btnArrowLeft.isHidden = false
            self.btnArrowRight.isHidden = false
        }
        
        self.view.addSubview(imageView)
        
    }
    
    func outputImage(withImageName name: String) {
        // Check Show/ Hide Arrow
        if testCount == 0 {
            self.btnArrowLeft.isHidden = true
            self.btnArrowRight.isHidden = false
        }
        else if testCount == imagesSM.count {
            self.btnArrowLeft.isHidden = false
            self.btnArrowRight.isHidden = true
        }
        else {
            self.btnArrowLeft.isHidden = false
            self.btnArrowRight.isHidden = false
        }
        
        self.ivTask.image = UIImage(named: name)!
    }
    
    func outputRecognizeImages(name1: String, name2: String){
        
        arrowButton1.removeFromSuperview()
        arrowButton2.removeFromSuperview()
        
        imageName1 = name1
        imageName2 = name2
        
        image1 = UIImage(named: name1)!
        image2 = UIImage(named: name2)!
        
        var x1 = CGFloat()
        var x2 = CGFloat()
        
        var y1 = CGFloat()
        var y2 = CGFloat()
        
        if 0.56*image1.size.width < image1.size.height {
            y1 = 350.0
            x1 = (350.0*(image1.size.width)/(image1.size.height))
        }
        else {
            x1 = 350.0
            y1 = (350.0*(image1.size.height)/(image1.size.width))
        }
        
        if 0.56*image2.size.width < image2.size.height {
            y2 = 350.0
            x2 = (350.0*(image2.size.width)/(image2.size.height))
        }
        else {
            x2 = 350.0
            y2 = (350.0*(image2.size.height)/(image2.size.width))
        }
        
        arrowButton1.frame = CGRect(x: (256.0-(x1/2)), y: (471.0-(y1/2)), width: x1, height: y1)
        arrowButton1.setImage(image1, for: .normal)
        arrowButton1.removeTarget(nil, action:nil, for: .allEvents)
        
        arrowButton2.frame = CGRect(x: (768.0-(x2/2)), y: (471.0-(y2/2)), width: x2, height: y2)
        arrowButton2.setImage(image2, for: .normal)
        arrowButton2.removeTarget(nil, action:nil, for: .allEvents)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.arrowButton1.addTarget(self, action: #selector(SimpleMemoryTask.recognize1), for:.touchUpInside)
            self.arrowButton2.addTarget(self, action: #selector(SimpleMemoryTask.recognize2), for:.touchUpInside)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.view.addSubview(self.arrowButton1)
            self.view.addSubview(self.arrowButton2)
        }
    }
    
    func beginDelay(){
        // Hide Arrow
        self.btnArrowLeft.isHidden = true
        self.btnArrowRight.isHidden = true
        self.ivTask.isHidden = true
        self.vDelay.isHidden = false
        imageView.removeFromSuperview()
        print("in delay!")
        
        self.delayLabel.text = "Recommended delay: 1 minute"
        
        afterBreakSM = true
        
        self.start.removeTarget(self, action: #selector(startNewTask), for:.touchUpInside)
        self.start.removeTarget(self, action: #selector(startDisplayAlert), for:.touchUpInside)
        self.start.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
        
        self.start.isHidden = false
        
        timerSM = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeDecreases), userInfo: nil, repeats: true)
        timerSM.fire()
        startTimeSM = NSDate.timeIntervalSinceReferenceDate
    }
    
    func updateInDelay(timer:Timer){
        
        let currTime = NSDate.timeIntervalSinceReferenceDate
        var diff: TimeInterval = currTime - startTimeSM
        
        let minutes = UInt8(diff / 60.0)
        
        diff -= (TimeInterval(minutes)*60.0)
        
        let seconds = UInt8(diff)
        
        diff = TimeInterval(seconds)
        
        let strMinutes = minutes > 9 ? String(minutes):"0"+String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0"+String(seconds)
        if strMinutes != "00", strSeconds != "00"  {
            timerLabel.textColor = UIColor.red
        }
        timerLabel.text = "\(strMinutes) : \(strSeconds)"
    }
    
    func updateTimeDecreases(timer:Timer) {
        timerLabel.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d : %02d", minutes, seconds)
    }
    
    func endTimer() {
        timerSM.invalidate()
        self.totalTime = 60
        self.testPicker.isHidden = true
        self.incorrectPicker.isHidden = true
        
        self.testPickerLabel.isHidden = true
        self.incorrectPickerLabel.isHidden = true
        for b in self.testSelectButtons {
            b.isHidden = true
        }
        
        self.start.isHidden = true
        self.resumeTask()
    }
    
    func resumeTask(){
        
        timerSM.invalidate()
        
        timerLabel.isHidden = true
        
        delayTime = 60.0 - Double(self.totalTime)//findTime()
        
//        timerLabel.text = ""
        delayLabel.text = ""
        
        let recallAlert = UIAlertController(title: "Recall", message: "Ask patients to name the items that were displayed earlier. Record their answers.", preferredStyle: .alert)
        recallAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
            print("recalling...")
//            self.recall()
            //action
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.next1.isHidden = false
            self.next1.isEnabled = true
            self.next1.addTarget(self, action: #selector(self.doneSM), for: UIControlEvents.touchUpInside)
        }))
        self.present(recallAlert, animated: true, completion: nil)
        
    }
    
    func findTime()->Double{
        
        let currTime = NSDate.timeIntervalSinceReferenceDate
        let time = Double(Int((currTime - startTimeSM)*10))/10.0
        print("time: \(time)")
        return time
        
    }
    
    func recall(){
        
        next1.isHidden = false
        next1.isEnabled = true
        
        next1.addTarget(self, action: #selector(nextButtonRecall), for: UIControlEvents.touchUpInside)
        
        var places = [(312, 175), (312, 250), (312, 325), (312, 400), (312, 475), (312, 550)]
        
        //deleted: , (312, 625)
        
        for k in 0 ..< 6 {
            let(a,b) = places[k]
            
            let x : CGFloat = CGFloat(a)
            let y : CGFloat = CGFloat(b)
            
            let button = UIButton(type: UIButtonType.system)
            buttonList.append(button)
            buttonTaps.append(false)
            button.frame = CGRect(x: x, y: y, width: 400, height: 70)
            button.titleLabel!.font = UIFont.systemFont(ofSize: 50)
            
            button.setTitle(imagesSM[k], for: UIControlState.normal)
            
            /*
            if(k < 6){
                button.setTitle(imagesSM[k], for: UIControlState.normal)
            }
            else{
                button.setTitle("incorrect", for: UIControlState.normal)
            }
            */
            button.tintColor = UIColor.lightGray
            
            button.addTarget(self, action: #selector(recallTapped), for: UIControlEvents.touchUpInside)
            
            self.view.addSubview(button)
        }
        
        recallPlus = UIButton(type: UIButtonType.system)
        recallPlus.frame = CGRect(x: 312, y: 650, width: 400, height: 70)
        recallPlus.titleLabel!.font = UIFont.systemFont(ofSize: 50)
        recallPlus.setTitle("add incorrect", for: UIControlState.normal)
        recallPlus.tintColor = UIColor.blue
        recallPlus.addTarget(self, action: #selector(recallPlusTapped), for: UIControlEvents.touchUpInside)
        self.view.addSubview(recallPlus)
        
        recallLabel.frame = CGRect(x: 820, y: 650, width: 100, height: 70)
        recallLabel.font = UIFont.systemFont(ofSize: 50)
        recallLabel.text = "0"
        self.view.addSubview(recallLabel)
        
        for _ in 0...5{
            recallTimes.append(-1)
        }
        
        startTimeSM = NSDate.timeIntervalSinceReferenceDate
        
        print("here!!")
        
    }
    
    func recallPlusTapped(sender: UIButton!){
        
        recallIncorrect += 1
        recallLabel.text = String(recallIncorrect)
        
        recallIncorrectTimes.append(findTime())
        
    }
    
    func recallTapped(sender: UIButton!){
        for i in 0...buttonList.count-1 {
            if sender == buttonList[i] {
                print("In button \(i)")
                
                buttonTaps[i] = !(buttonTaps[i])
                
                if(buttonTaps[i] == true){
                    buttonList[i].tintColor = UIColor.blue
                    
                    recallTimes[i] = findTime()
                    
                }
                else{
                    buttonList[i].tintColor = UIColor.lightGray
                    
                    recallTimes[i] = -1
                    
                }
                
                /*
                 //change color to indicate tap
                 sender.backgroundColor = UIColor.darkGrayColor()
                 sender.enabled = false
                 
                 pressed.append(i)
                 */
                
            }
        }
    }
    
    
    @IBAction func nextButtonRecall(sender: AnyObject) {
        
        next1.isHidden = true
        next1.isEnabled = false
        
        for k in 0 ..< buttonList.count {
            buttonList[k].removeFromSuperview()
        }
        buttonList = [UIButton]()
        
        recallPlus.removeFromSuperview()
        recallLabel.removeFromSuperview()
        
        let recognizeAlert = UIAlertController(title: "Recognize", message: "Asl patient to choose the item they have seen before.", preferredStyle: .alert)
        recognizeAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
            print("recognizing...")
            self.recognize()
            //action
        }))
        self.present(recognizeAlert, animated: true, completion: nil)
        
        
    }
    
    func recognize(){
        
        testCount = 0
        
        randomizeRecognize()
        
        if(orderRecognize[testCount] == 0){
            outputRecognizeImages(name1: imagesSM[testCount], name2: recognizeIncorrectSM[testCount])
        }
        else{
            outputRecognizeImages(name1: recognizeIncorrectSM[testCount], name2: imagesSM[testCount])
        }
        
        arrowButton1.isHidden = false
        arrowButton1.isEnabled = true
        
        arrowButton2.isHidden = false
        arrowButton2.isEnabled = true
        
        print("in recognize()")
        
        startTimeSM = NSDate.timeIntervalSinceReferenceDate
        
    }
    
    @IBAction func recognize1(sender: AnyObject){
        arrowButton1.isEnabled = false
        arrowButton2.isEnabled = false
        
        if(orderRecognize[testCount] == 0){
            recognizeErrors.append(0)
            recognizeTimes.append(findTime())
        }
        else{
            recognizeErrors.append(1)
            recognizeTimes.append(findTime())
        }
        
        nextButtonRecognize()
        
    }
    
    @IBAction func recognize2(sender: AnyObject){
        
        arrowButton1.isEnabled = false
        arrowButton2.isEnabled = false
        
        if(orderRecognize[testCount] == 0){
            recognizeErrors.append(1)
            recognizeTimes.append(findTime())
        }
        else{
            recognizeErrors.append(0)
            recognizeTimes.append(findTime())
        }
        
        nextButtonRecognize()
        
    }
    
    func nextButtonRecognize(){
        
        testCount += 1
        
        if(testCount == imagesSM.count){
            
            arrowButton1.isHidden = true
            arrowButton2.isHidden = true
            
            done()
            
        }
            
        else{
            arrowButton1.isEnabled = true
            arrowButton2.isEnabled = true
            
            print("in nextButtonRecognize, testcount = \(testCount), orderRecognie.count = \(orderRecognize.count)")
            
            if(orderRecognize[testCount] == 0) {
                outputRecognizeImages(name1: imagesSM[testCount], name2: recognizeIncorrectSM[testCount])
            }
            else{
                outputRecognizeImages(name1: recognizeIncorrectSM[testCount], name2: imagesSM[testCount])
            }
            
        }
        
    }
    
    func done(){
        ended = true
        //back.isEnabled = true
        totalTime = 60
        self.tableView.isHidden = true
        afterBreakSM = false
        var numErrors = 0
        
        var imageSetResult = ""
        var delayResult = ""
        var recallResult = ""
        var recognizeResult = ""
        
        imageSetResult = imageSetResult + delayResult + recallResult + recognizeResult
        delayResult = "Delay length of \(delayTime) seconds\n"
        
        var correctRecall = 0
        var incorrectRecall = 0
        var correctRecognize = 0
        var incorrectRecognize = 0
        for k in 0 ..< imagesSM.count {
            
            if(buttonTaps[k] == true) {
                recallResult += "Recalled \(imagesSM[k]) - Correct in \(recallTimes[k]) seconds\n"
                correctRecall += 1
            }
            if(buttonTaps[k] == false) {
                recallResult += "Did not recall \(imagesSM[k])\n"
                numErrors += 1
                incorrectRecall += 1
            }
            
            if(recognizeErrors[k] == 0){
                recognizeResult += "Recognized \(imagesSM[k]) - Correct in \(recognizeTimes[k]) seconds\n"
                correctRecognize += 1
            }
            if(recognizeErrors[k] == 1){
                recognizeResult += "Recognized \(imagesSM[k]) - Incorrect in \(recognizeTimes[k]) seconds\n"
                numErrors += 1
                incorrectRecognize += 1
            }
            
            /*
            let result = Results()
            result.name = "Simple Memory"
            result.startTime = StartTimer
            result.endTime = Foundation.Date()
            result.shortDescription = "(\(recognizeResult) and \(recallResult))"
            result.json = ["None":""]
            resultsArray.add(result)
 */
        }
        
        recallResult += "\(recallIncorrect) item(s) - Incorrect recalled at times \(recallIncorrectTimes)\n"
        resultTitleLabel.text = "Result"
        resultLabel.text = imageSetResult + delayResult + recallResult + recognizeResult
        let result = Results()
        result.name = "Simple Memory"
        result.startTime = StartTimer
        result.endTime = Foundation.Date()
        result.shortDescription = "Recall: \(correctRecall) correct, \(incorrectRecall) incorrect.  Recognize: \(correctRecognize) correct, \(incorrectRecognize) incorrect. (Sets correct:\(imageSetSM), incorrect:\(incorrectImageSetSM))"
        result.numErrors = numErrors
        
        resultList["CorrectImageSet"] = imageSetSM
        resultList["IncorrectImageSet"] = incorrectImageSetSM
        resultList["DelayTime"] = delayTime
        
        resultList["Recall Correct"] =  correctRecall
        resultList["Recall Incorrect"] =  incorrectRecall
        resultList["Recognize Correct"] =   correctRecognize
        resultList["Recognize Incorrect"] =   incorrectRecognize

        
        var tmpResultList : [String:Any] = [:]
        
        for i in 0...recognizeErrors.count - 1 {
            var res = "Correct"
            if recognizeErrors[i] == 1 {
                res = "Incorrect"
            }
            tmpResultList[imagesSM[i]] = ["Condition":res, "Time":recognizeTimes[i]]
        }
        resultList["Recognize"] = tmpResultList
        
        if recallIncorrect > 0{
            var tmpResultList0 : [String:Any] = [:]
            for i in 0...recallIncorrect - 1 {
                tmpResultList0["Time\(i)"] = recallIncorrectTimes[i]
            }
            
            resultList["IncorrectRecognize"] = tmpResultList0
        }
        
        
        var tmpResultList1 : [String:Any] = [:]
        
        for i in 0...buttonTaps.count - 1 {
            var res = "Correct"
            if buttonTaps[i] == false {
                res = "Incorrect"
            }
            tmpResultList1[imagesSM[i]] = ["Condition":res, "Time":recognizeTimes[i]]
        }

        resultList["Recall"] = tmpResultList1
        
        result.json = resultList
        resultsArray.add(result)
        
        resultList = [:]
        
        Status[TestSimpleMemory] = TestStatus.Done
        
        start.isHidden = false
        start.isEnabled = true
        start.setTitle("Start New", for: .normal)
        start.setTitle("Start New", for: .selected)
        start.removeTarget(self, action: #selector(startNewTask), for:.touchUpInside)
        start.removeTarget(self, action: #selector(startDisplayAlert), for:.touchUpInside)
        start.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
        
    }
    
    func randomizeRecognize(){
        
        //if 0, correct image on left; if 1, correct on right
        
        for _ in 0 ..< 6 {
            orderRecognize.append(Int(arc4random_uniform(2)))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    // MARK: - Action
    @IBAction func btnArrowLeftTapped(_ sender: Any) {
        print("Arrow Left Tapped")
        testCount -= 1
        if testCount >= 0 {
            print("pic: \(testCount)")
            self.outputImage(withImageName: imagesSM[testCount])
        }
    }
    
    @IBAction func btnArrowRightTapped(_ sender: Any) {
        print("Arrow Right Tapped")
        testCount += 1
        if(testCount == imagesSM.count) {
            imageView.removeFromSuperview()
            print("delay")
            self.beginDelay()
        }
        else {
            print("pic: \(testCount)")
            self.outputImage(withImageName: imagesSM[testCount])
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        ended = true
        timerSM.invalidate()
        afterBreakSM = false
        Status[TestSimpleMemory] = TestStatus.NotStarted
    }
    
    @objc private func doneSM() {
        self.view.endEditing(true)
        if checkValid() == false {
            let warningAlert = UIAlertController(title: "Warning", message: "Please enter all fields.", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                warningAlert.dismiss(animated: true, completion: nil)
            }))
            self.present(warningAlert, animated: true, completion: nil)
        }
        else {
            ended = true
            totalTime = 60
            self.tableView.isHidden = true
            afterBreakSM = false
            self.next1.isHidden = true
            
            let delayResult = "Delay length of \(delayTime) seconds\n"
            var outputResult = ""
            var exactEsults = "Exact results are:"
            let timeComplete = "\nTest completed in \(findTime()) seconds"
            var correct = 0
            var incorrect = 0
            
            for i in 0 ..< imagesSM.count {
                exactEsults += " \(imagesSM[i]),"
                let cell = self.tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as! SMCell
                guard let inputValue = cell.textField.text else {return}
                if imagesSM.contains(inputValue.lowercased()) {
                    outputResult += "Input \(inputValue) - Correct\n"
                    correct += 1
                }
                else {
                    incorrect += 1
                    outputResult += "Input \(inputValue) - Incorrect\n"
                }
            }
            
            resultTitleLabel.text = "Result"
            resultLabel.text = delayResult + outputResult + exactEsults + timeComplete
            
            // Save Results
            result.endTime = Foundation.Date()
            result.shortDescription = "Recall: \(correct) correct, \(incorrect) incorrect. (Sets correct:\(imageSetSM), incorrect:\(incorrectImageSetSM))"
            result.numErrors = incorrect
            
            resultList["CorrectImageSet"] = imageSetSM
            resultList["IncorrectImageSet"] = incorrectImageSetSM
            resultList["DelayTime"] = delayTime
            resultList["Recall Correct"] =  correct
            resultList["Recall Incorrect"] =  incorrect
            resultList["CompleteTime"] = findTime()
            
            result.json = resultList
            resultsArray.add(result)
            
            resultList = [:]
            
            Status[TestSimpleMemory] = TestStatus.Done
            
            start.isHidden = false
            start.isEnabled = true
            start.setTitle("Start New", for: .normal)
            start.setTitle("Start New", for: .selected)
            start.removeTarget(self, action: #selector(startNewTask), for:.touchUpInside)
            start.removeTarget(self, action: #selector(startDisplayAlert), for:.touchUpInside)
            start.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
        }
    }
    
    private func checkValid() -> Bool {
        var countEmpty = 0
        for i in 0 ..< imagesSM.count {
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as! SMCell
            if let inputValue = cell.textField.text, inputValue.isEmpty {
                countEmpty += 1
            }
        }
        
        if countEmpty != 0 {
            return false
        }
        else {
            return true
        }
    }
    
}
// MARK: - TableView Delegate, DataSource
extension SimpleMemoryTask: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesSM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SMCell", for: indexPath) as! SMCell
        cell.lbTitle.text = "Object name \(indexPath.row + 1):"
        if self.isStartNew == true {
            cell.textField.text = ""
        }
        return cell
    }
}

// MARK: - Setup UI
extension SimpleMemoryTask {
    fileprivate func setupViews() {
        // Label Back
        self.lblBack.font = Font.font(name: Font.Montserrat.bold, size: 28.0)
        self.lblBack.textColor = Color.color(hexString: "#013AA5")
        self.lblBack.addTextSpacing(-0.56)
        self.lblBack.text = "SIMPLE MEMORY"
        
        // Label Description Task
        self.lblDescTask.font = Font.font(name: Font.Montserrat.mediumItalic, size: 18.0)
        self.lblDescTask.textColor = Color.color(hexString: "#013AA5")
        self.lblDescTask.alpha = 0.67
        self.lblDescTask.text = "Ask Patient to name and remember these images"
        self.lblDescTask.addLineSpacing(15.0)
        self.lblDescTask.addTextSpacing(-0.36)
        
        // Collection View Level
        self.setupCollectionView()
        
        // View Task
        self.setupViewTask()
        
        // View Delay
        self.setupViewDelay()
        
        self.vShadowTask.isHidden = true
        self.vTask.isHidden = true
        self.vDelay.isHidden = true
    }
    
    fileprivate func setupCollectionView() {
        self.collectionViewLevel.backgroundColor = UIColor.clear
        self.collectionViewLevel.register(LevelCell.nib(), forCellWithReuseIdentifier: LevelCell.identifier())
        self.collectionViewLevel.delegate = self
        self.collectionViewLevel.dataSource = self
    }
    
    fileprivate func setupViewTask() {
        self.vShadowTask.layer.cornerRadius = 8.0
        self.vShadowTask.layer.shadowColor = Color.color(hexString: "#649BFF").withAlphaComponent(0.32).cgColor
        self.vShadowTask.layer.shadowOpacity = 1.0
        self.vShadowTask.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vShadowTask.layer.shadowRadius = 10 / 2.0
        self.vShadowTask.layer.shadowPath = nil
        self.vShadowTask.layer.masksToBounds = false
        
        self.vTask.clipsToBounds = true
        self.vTask.backgroundColor = UIColor.white
        self.vTask.layer.cornerRadius = 8.0
        
        // Button Arrow Left, Right
        self.btnArrowLeft.backgroundColor = Color.color(hexString: "#EEF3F9")
        self.btnArrowLeft.layer.cornerRadius = self.btnArrowLeft.frame.size.height / 2.0
        self.btnArrowRight.backgroundColor = Color.color(hexString: "#EEF3F9")
        self.btnArrowRight.layer.cornerRadius = self.btnArrowRight.frame.size.height / 2.0
    }
    
    fileprivate func setupViewDelay() {
        self.lblDescDelay.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.lblDescDelay.textColor = Color.color(hexString: "#8A9199")
        self.lblDescDelay.text = "Ask Patient to name the items that were displayed  earlier. Record their answers"
        self.lblDescDelay.addLineSpacing(15.0)
        self.lblDescDelay.addTextSpacing(-0.36)
        self.lblDescDelay.textAlignment = .center
        
        self.delayLabel.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.delayLabel.textColor = Color.color(hexString: "#013AA5")
        self.delayLabel.text = "Recommended Delay : 1 minute"
        self.delayLabel.addTextSpacing(-0.56)
        
        self.timerLabel.font = Font.font(name: Font.Montserrat.semiBold, size: 72.0)
        self.timerLabel.textColor = Color.color(hexString: "#013AA5")
        self.timerLabel.addTextSpacing(-1.44)
        
        let colors = [Color.color(hexString: "#FFDC6E"), Color.color(hexString: "#FFC556")]
        self.start.setTitle(title: "START NOW", withFont: Font.font(name: Font.Montserrat.bold, size: 18.0))
        self.start.setupShadow(withColor: .clear, sketchBlur: 0, opacity: 0)
        self.start.setupGradient(arrColor: colors, direction: .topToBottom)
        self.start.addTextSpacing(-0.36)
        self.start.render()
    }
}


extension SimpleMemoryTask: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCollectionView: CGFloat = self.collectionViewLevel.frame.size.width
        let widthCell = (widthCollectionView / 4) - 20
        return CGSize.init(width: widthCell, height: 235.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.identifier(), for: indexPath) as! LevelCell
        let idx = indexPath.row + 1
        cell.ivLevel.image = UIImage.init(named: "level_\(idx)")
        cell.lblTitle.text = "LEVEL \(idx)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.item
        print("Selected Item \(idx)")
        switch idx {
        case 0:
            imagesSM = images0
            imageSetSM = 0
            recognizeIncorrectSM = images4
            incorrectImageSetSM = 4
        case 1:
            imagesSM = images1
            imageSetSM = 1
            recognizeIncorrectSM = images5
            incorrectImageSetSM = 5
        case 2:
            imagesSM = images2
            imageSetSM = 2
            recognizeIncorrectSM = images6
            incorrectImageSetSM = 6
        case 3:
            imagesSM = images3
            imageSetSM = 3
            recognizeIncorrectSM = images7
            incorrectImageSetSM = 7
        default:
            imagesSM = images0
            imageSetSM = 0
            recognizeIncorrectSM = images0
            incorrectImageSetSM = 0
        }
        
        self.startDisplayAlert()
        
    }
}
