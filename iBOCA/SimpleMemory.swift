//
//  SimpleMemoryTask.swift
//  iBOCA
//
//  Created by School on 8/29/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import Foundation
import UIKit

var previousSMTest = -1

class MyGlobalSM: NSObject {
    
    static let shared: MyGlobalSM = MyGlobalSM()
    var totalTimer: Timer?
    var internalTimer: Timer? // delay time
    var delay: Int = 0
    var delayInMain: Int = 0
    var total: Int = 0
    var SMDelayTime: Int = 60
    var imagesSM = [String]()
    var imageSetSM = Int()
    var recognizeIncorrectSM = [String]()
    var incorrectImageSetSM = Int()
    
    var resultStartTime: Foundation.Date!
    
    func startDelayTimer() {
        if self.internalTimer == nil {
            self.internalTimer = Timer.scheduledTimer(timeInterval: 1.0 /*seconds*/, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
        }
    }
    
    func startTotalTimer() {
        if self.totalTimer == nil {
            self.totalTimer = Timer.scheduledTimer(timeInterval: 1.0 /*seconds*/, target: self, selector: #selector(fireTotalTimerAction), userInfo: nil, repeats: true)
            self.resultStartTime = Foundation.Date()
        }
    }
    
    func stopDelayTimer(){
        if self.internalTimer != nil {
            self.internalTimer!.invalidate()
            self.internalTimer = nil
            
            self.delayInMain = 0
            let dataDict:[String: Int] = ["SMDelayTime": self.delayInMain]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SMDelayTime"), object: nil, userInfo: dataDict)
        }
    }
    
    func stopTotalTimer(){
        if self.totalTimer != nil {
            self.totalTimer!.invalidate()
            self.totalTimer = nil
        }
    }
    
    @objc func fireTimerAction(sender: AnyObject?){
        delay += 1
        delayInMain += 1
        debugPrint("SM Delay! \(delay)")
        
        let dataDict:[String: Int] = ["SMDelayTime": delayInMain]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SMDelayTime"), object: nil, userInfo: dataDict)
    }
    
    @objc func fireTotalTimerAction(sender: AnyObject?){
        total += 1
        debugPrint("SM Total! \(total)")
    }
    
    func clearAll() {
        self.stopDelayTimer()
        self.imagesSM.removeAll()
        self.imageSetSM = Int()
        self.recognizeIncorrectSM.removeAll()
        self.incorrectImageSetSM = Int()
    }
}

class SimpleMemoryTask: BaseViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var lblDescTask: UILabel!
    
    @IBOutlet weak var collectionViewLevel: UICollectionView!
    
    @IBOutlet weak var vShadowTask: UIView!
    @IBOutlet weak var vTask: UIView!
    
    @IBOutlet weak var ivTask: UIImageView!
    
    @IBOutlet weak var lblSetDelayTime: UILabel!
    @IBOutlet weak var vSetDelayTime: UIView!
    
    @IBOutlet weak var lblChooseDelayTime: UILabel!
    @IBOutlet weak var btnChooseDelayTime: UIButton!
    @IBOutlet weak var btnSetDelayTime: UIButton!
    
    @IBOutlet weak var vDelay: UIView!
    
    @IBOutlet weak var collectionViewObjectName: UICollectionView!
    @IBOutlet weak var originalAnswerButton: UIButton!
    
    @IBOutlet weak var vResults: UIView!
    @IBOutlet weak var lblDelayLength: UILabel!
    @IBOutlet weak var btnStartNew: GradientButton!
    @IBOutlet weak var quitButton: GradientButton!
    
    @IBOutlet weak var lblTimeCompleteTask: UILabel!
    
    @IBOutlet weak var resultScrollView: UIScrollView!
    @IBOutlet weak var resultContentView: UIView!
    @IBOutlet weak var tableViewResults: UITableView!
    @IBOutlet weak var tableViewRegconize: UITableView!
    
    @IBOutlet weak var vCounterTimer: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var resultTitleLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var start: GradientButton!
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var btnArrowLeft: UIButton!
    @IBOutlet weak var btnArrowRight: UIButton!
    
    @IBOutlet weak var nextButtonConstraintBottom: NSLayoutConstraint!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var viewRegconize: UIView!
    
    // MARK: - Variable
    // Check mode is admin or patient
    var mode : TestMode = TestMode.admin
    
    // Check Timer Next Picture
    var timerNextPicture = Timer()
    
    var textInputList: [String]!
    var textDeterminedAdminList: [String]!
    
    var resultList: [String:Any] = [:]
    
    var delayTime = Double()
    let maxSeconds = 60.0
    var totalTime = 60
    
    var ended = false
    
    var isStartNew = false
    
    var testCount = 0
    
    var timeInput = Double()
    
    var recognizeTimes = [Double]()
    var recognizeErrors = [Int]()
    
    var images0 = ["binoculars", "can", "cat", "elbow", "pipe", "rainbow"]
    var images1 = ["bottle", "coral", "ladder", "owl", "saw", "shoe"]
    var images2 = ["bee", "corn", "lamp", "sheep", "violin", "watch"]
    var images3 = ["basket", "candle", "doll", "knife", "skeleton", "star"]
    var images4 = ["briefcase", "chair", "duck", "microphone", "needle", "stairs"]
    var images5 = ["baseball", "drum", "necklace", "shovel", "tank", "toilet"]
    var images6 = ["anchor", "eyebrow", "flashlight", "glove", "moon", "sword"]
    var images7 = ["lion", "nut", "piano", "ring", "scissors", "whisk"]
    
    var imagesLevel = ["binoculars", "bottle", "bee", "basket"]
    
    var buttonList = [UIButton]()
    
    var arrowButton1 = UIButton()
    var arrowButton2 = UIButton()
    
    var orderRecognize = [Int]()
    
    var testSelectButtons : [UIButton] = []
    
    var result: Results!
    
    var resultsTask: [SMResultModel] = [SMResultModel]()
    
    var counterTime: CounterTimeView!
    var totalTimeCounter = Timer()
    var startTimeTask = Foundation.Date()
    
    var mixedImages = [String]()
    var regconizeTimer = Timer()
    
    let dataMinutesDropDown = [
        "1 minute",
        "2 minutes",
        "3 minutes",
        "4 minutes",
        "5 minutes"
    ]
    
    var isRecalledTestMode = false
    
    var dropDownView: DropdownView!
    
    var afterBreakSM = Bool()
    
    var recognizeIncorrectSM = [String]()
    
    var imagesSM = [String]()
    
    var imageSetSM = Int()
    var incorrectImageSetSM = Int()
    
    var startTimeSM = TimeInterval()
    var timerSM = Timer()
    
    // QuickStart Mode
    var quickStartModeOn: Bool = false
    var didBackToResult: (() -> ())?
    var didCompleted: (() -> ())?
    
    // MARK: - Load Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        
        // View Counter Timer
        self.setupViewCounterTimer()
        
        self.startTest()
        
        self.result = Results()
        self.result.name = TestName.SIMPLE_MEMORY
        
        self.nextButton.isHidden = true
        
        // QuickStart Mode
        if quickStartModeOn {
            lblBack.text = "RESULT"
            quitButton.updateTitle(title: "CONTINUE")
        }
        
        self.shouldHiddenImageViewer(true)
        
        self.afterBreakSM = false
        
        // Hide regconize view
        self.isRegconizeViewHidden(true)
        
        self.isResutViewHidden(true)
    
        // MARK: - TODO
        self.start.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.runTimer()
        
        // Check Global time Delay
        if MyGlobalSM.shared.internalTimer != nil {
            // Check VADelayTime in Settings
            self.afterBreakSM = true
            self.collectionViewLevel.isHidden = true
            self.lblDescTask.isHidden = true
            self.vShadowTask.isHidden = false
            self.vTask.isHidden = false
            self.start.removeTarget(nil, action: nil, for: .allEvents)
            self.start.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
            self.beginDelay()
            // Reload data images
            self.textInputList = []
            self.imagesSM = MyGlobalSM.shared.imagesSM
            self.imageSetSM = MyGlobalSM.shared.imageSetSM
            self.recognizeIncorrectSM = MyGlobalSM.shared.recognizeIncorrectSM
            self.incorrectImageSetSM = MyGlobalSM.shared.incorrectImageSetSM
            
            self.delayLabel.text = MyGlobalSM.shared.SMDelayTime / 60 == 1 ? "Recommended Delay : 1 minute" : "Recommended Delay : \(MyGlobalSM.shared.SMDelayTime / 60) minutes"
            if MyGlobalSM.shared.delay > MyGlobalSM.shared.SMDelayTime {
                self.timerLabel.text = "00 : 00"
                self.endTimer()
            }
            else {
                self.totalTime = MyGlobalSM.shared.SMDelayTime - MyGlobalSM.shared.delay
                self.timerLabel.text = "\(self.timeFormatted(self.totalTime))"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
}

// MARK: - Setup UI
extension SimpleMemoryTask {
    fileprivate func setupViews() {
        self.nextButtonConstraintBottom.constant = self.mode == .admin ? 90 : 150
        
        // Label Back
        self.lblBack.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.lblBack.textColor = Color.color(hexString: "#013AA5")
        self.lblBack.addTextSpacing(-0.56)
        self.lblBack.text = "BACK"
        
        // Label Description Task
        self.lblDescTask.font = Font.font(name: Font.Montserrat.mediumItalic, size: 18.0)
        self.lblDescTask.textColor = Color.color(hexString: "#013AA5")
        self.lblDescTask.alpha = 0.67
        self.lblDescTask.text = "Ask Patient to name and remember these images"
        self.lblDescTask.addTextSpacing(-0.36)
        self.lblDescTask.addLineSpacing(10.0)
        
        self.quitButton.setTitle(title: "QUIT", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        self.quitButton.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        self.quitButton.setupGradient(arrColor: [Color.color(hexString: "FFAFA6"),Color.color(hexString: "FE786A")],
                                      direction: .topToBottom)
        self.quitButton.render()
        self.quitButton.addTextSpacing(-0.36)
        
        // Collection View Level
        self.setupCollectionView()
        
        // View Task
        self.setupViewTask()
        
        // View Delay
        self.setupViewDelay()
        
        // View Object Name
        self.setupViewObjectName()
        
        // View Results
        self.setupViewResults()
        
        self.vShadowTask.isHidden = true
        self.vTask.isHidden = true
        self.shouldHiddenDelayViews(true)
        self.vResults.isHidden = true
        self.collectionViewLevel.isHidden = false
        self.lblDescTask.isHidden = false
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
        self.setupViewSetDelayTime()
        
        self.delayLabel.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.delayLabel.textColor = Color.color(hexString: "#013AA5")
        self.delayLabel.text = MyGlobalSM.shared.SMDelayTime / 60 == 1 ? "Recommended Delay : 1 minute" : "Recommended Delay : \(MyGlobalSM.shared.SMDelayTime / 60) minutes"
        self.delayLabel.addTextSpacing(-0.56)
        
        self.timerLabel.font = Font.font(name: Font.Montserrat.semiBold, size: 72.0)
        self.timerLabel.textColor = Color.color(hexString: "#013AA5")
        self.timerLabel.addTextSpacing(-1.44)
        
        self.start.setTitle(title: "START NOW", withFont: Font.font(name: Font.Montserrat.bold, size: 22.0))
        self.start.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        self.start.setupGradient(arrColor: [Color.color(hexString: "#FFDC6E"),Color.color(hexString: "#FFC556")], direction: .topToBottom)
        self.start.render()
        self.start.addTextSpacing(-0.44)
    }
    
    fileprivate func setupViewSetDelayTime() {
        self.lblSetDelayTime.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.lblSetDelayTime.textColor = Color.color(hexString: "#8A9199")
        self.lblSetDelayTime.text = "Setting delay time"
        self.lblSetDelayTime.addTextSpacing(-0.36)
        
        self.vSetDelayTime.clipsToBounds = true
        self.vSetDelayTime.backgroundColor = Color.color(hexString: "#F7F7F7")
        self.vSetDelayTime.layer.cornerRadius = 5.0
        self.vSetDelayTime.layer.borderWidth = 1.0
        self.vSetDelayTime.layer.borderColor = Color.color(hexString: "#EAEAEA").cgColor
        
        self.lblChooseDelayTime.addTextSpacing(-0.36)
        self.lblChooseDelayTime.text = self.minuteOfString()
        self.lblChooseDelayTime.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.lblChooseDelayTime.textColor = .black
        
        self.btnChooseDelayTime.tintColor = .clear
        self.btnChooseDelayTime.setTitleColor(UIColor.clear, for: .normal)
        
        // MARK: - Config Dropdown minute
        let x = self.vSetDelayTime.origin.x
        let y = self.vSetDelayTime.origin.y + self.vSetDelayTime.bounds.height + 6.0
        let frame = CGRect.init(x: x, y: y, width: self.vSetDelayTime.size.width, height: 200.0)
        self.dropDownView = DropdownView.init(frame: frame, style: .plain)
        self.dropDownView.isScrollEnabled = false
        self.dropDownView.dataArray = self.dataMinutesDropDown
        if let timeChoose = self.lblChooseDelayTime.text {
            self.dropDownView.itemSelected = timeChoose
        }
        self.dropDownView.dropdownDelegate = self
        self.vTask.addSubview(self.dropDownView)
        
        self.btnSetDelayTime.addTextSpacing(-0.36)
        self.btnSetDelayTime.layer.cornerRadius = 5.0
        self.btnSetDelayTime.setTitle("SET", for: .normal)
        self.btnSetDelayTime.setTitleColor(Color.color(hexString: "#013AA5"), for: .normal)
        self.btnSetDelayTime.titleLabel?.font = Font.font(name: Font.Montserrat.semiBold, size: 18.0)
        self.btnSetDelayTime.backgroundColor = Color.color(hexString: "#EEF3F9")
    }
    
    private func shouldHiddenImageViewer(_ isHidden: Bool) {
        self.ivTask.isHidden = isHidden
        self.btnArrowLeft.isHidden = isHidden
        self.btnArrowRight.isHidden = isHidden
    }
    
    private func shouldHiddenDelayViews(_ isHidden: Bool) {
        self.vDelay.isHidden = isHidden
        self.lblSetDelayTime.isHidden = isHidden
        self.vSetDelayTime.isHidden = isHidden
        self.btnSetDelayTime.isHidden = isHidden
        self.timerLabel.isHidden = isHidden
        self.delayLabel.isHidden = isHidden
    }
    
    fileprivate func minuteOfString() -> String {
        return MyGlobalSM.shared.SMDelayTime / 60 == 1 ? "1 minute" : "\(MyGlobalSM.shared.SMDelayTime / 60) minutes"
    }
    
    fileprivate func setupViewObjectName() {
        // Table View
        self.collectionViewObjectName.register(SimpleMemoryCell.nib(), forCellWithReuseIdentifier: SimpleMemoryCell.identifier())
        self.collectionViewObjectName.delegate = self
        self.collectionViewObjectName.dataSource = self
        self.collectionViewObjectName.isHidden = true
        self.originalAnswerButton.isHidden = true
        
        // Button complete
        self.nextButton.titleLabel?.font = Font.font(name: Font.Montserrat.bold, size: 22.0)
        self.nextButton.backgroundColor = Color.color(hexString: "#EEF3F9")
        self.nextButton.tintColor = Color.color(hexString: "#013AA5")
        self.nextButton.setTitle("CONTINUE", for: .normal)
        self.nextButton.layer.cornerRadius = 8
        self.nextButton.layer.masksToBounds = true
    }
    
    fileprivate func setupViewResults() {
        self.vResults.clipsToBounds = true
        self.vResults.backgroundColor = UIColor.white
        self.vResults.layer.cornerRadius = 8.0
        
        self.resultTitleLabel.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.resultTitleLabel.textColor = Color.color(hexString: "#013AA5")
        self.resultTitleLabel.addTextSpacing(-0.56)
        
        self.lblDelayLength.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.lblDelayLength.addTextSpacing(-0.36)
        self.lblDelayLength.textColor = Color.color(hexString: "#8A9199")
        
        self.lblTimeCompleteTask.font = Font.font(name: Font.Montserrat.mediumItalic, size: 18.0)
        self.lblTimeCompleteTask.textColor = UIColor.black
        self.lblTimeCompleteTask.addTextSpacing(-0.36)
        self.lblTimeCompleteTask.textAlignment = .center
        
        // Button Start New
        self.btnStartNew.setTitle(title: "RESET", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        self.btnStartNew.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        self.btnStartNew.setupGradient(arrColor: [Color.color(hexString: "#FFDC6E"),Color.color(hexString: "#FFC556")], direction: .topToBottom)
        self.btnStartNew.render()
        self.btnStartNew.addTextSpacing(-0.36)
        self.btnStartNew.addTarget(self, action: #selector(startNewTask), for:.touchUpInside)
        
        // TableView Results
        self.tableViewResults.register(SMResultCell.nib(), forCellReuseIdentifier: SMResultCell.identifier())
        self.tableViewResults.delegate = self
        self.tableViewResults.dataSource = self
        self.tableViewResults.alwaysBounceVertical = false
        
        self.tableViewRegconize.delegate = self
        self.tableViewRegconize.dataSource = self
        self.tableViewRegconize.allowsSelection = false
        self.tableViewRegconize.separatorStyle = .none
        self.tableViewRegconize.register(VACell.nib(), forCellReuseIdentifier: VACell.identifier())
        
    }
    
    fileprivate func setupViewCounterTimer() {
        // View Couter Timer
        self.counterTime = CounterTimeView()
        self.vCounterTimer.backgroundColor = .clear
        self.vCounterTimer.addSubview(self.counterTime)
        self.counterTime.centerXAnchor.constraint(equalTo: self.vCounterTimer.centerXAnchor).isActive = true
        self.counterTime.centerYAnchor.constraint(equalTo: self.vCounterTimer.centerYAnchor).isActive = true
        self.startTimeTask = Foundation.Date()
        self.totalTimeCounter.invalidate()
    }
    
    fileprivate func runTimer() {
        self.totalTimeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.totalTimeCounter.fire()
    }
    
    @objc func updateTime(timer: Timer) {
        self.counterTime.setSeconds(seconds: MyGlobalSM.shared.total)
    }
    
    @objc func startAlert() {
        self.nextButton.isHidden = true
        
        // Update item Selected Dropdown & hide Dropdown
        self.updateDataDropDown()
        
        if self.isStartNew == false {
            let startAlert = UIAlertController(title: "Start", message: "Choose start option.", preferredStyle: .alert)
            startAlert.addAction(UIAlertAction(title: "Start New Task", style: .default, handler: { (action) -> Void in
                self.startNewTask()
            }))
            
            if(afterBreakSM == true){
                startAlert.addAction(UIAlertAction(title: "Resume Task", style: .default, handler: { (action) -> Void in
                    for b in self.testSelectButtons {
                        b.isHidden = true
                    }
                    
                    self.start.isHidden = true
                    
                    self.resumeTask()
                }))
            }
            
            startAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            }))
            
            self.present(startAlert, animated: true, completion: nil)
        } else {
            self.startNewTask()
        }
    }
    
    @objc func startNewTask() {
        
        // Update SMDelayTime of singleton
        if MyGlobalSM.shared.internalTimer != nil {
            if let delayTime = Settings.SMDelayTime {
                MyGlobalSM.shared.SMDelayTime = delayTime*60
            }
        }
        
        MyGlobalSM.shared.clearAll()
        MyGlobalSM.shared.stopTotalTimer()
        MyGlobalSM.shared.total = 0
        MyGlobalSM.shared.delay = 0
        MyGlobalSM.shared.stopDelayTimer()
        
        self.isRecalledTestMode = false
        
        regconizeTimer.invalidate()
        self.isRegconizeViewHidden(true)
        self.isResutViewHidden(true)
        
        self.delayLabel.text = MyGlobalSM.shared.SMDelayTime / 60 == 1 ? "Recommended Delay : 1 minute" : "Recommended Delay : \(MyGlobalSM.shared.SMDelayTime / 60) minutes"
        self.lblChooseDelayTime.text = self.minuteOfString()
        // Update item Selected Dropdown & hide DropDown
        self.updateDataDropDown()
        
        self.collectionViewObjectName.isHidden = true
        self.originalAnswerButton.isHidden = true
        
        self.vShadowTask.isHidden = true
        self.vTask.isHidden = true
        self.shouldHiddenDelayViews(true)
        self.vResults.isHidden = true
        self.nextButton.isHidden = true
        
        self.timerNextPicture.invalidate()
        self.ivTask.image = nil
        
        self.startTest()
        
        self.collectionViewLevel.reloadData()
        self.collectionViewObjectName.reloadData()
        
        startTime = Foundation.Date()
        self.startTimeTask = Foundation.Date()
        self.totalTimeCounter.invalidate()
        self.runTimer()
        
        result = Results()
        result.name = TestName.SIMPLE_MEMORY
        ended = true
        self.isStartNew = true
        self.collectionViewObjectName.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isStartNew = false
        }
        timerSM.invalidate()
        afterBreakSM = false
        Status[TestSimpleMemory] = TestStatus.NotStarted
        
        testCount = 0
        orderRecognize = [Int]()
        afterBreakSM = false
    }
    
    func startTest() {
        switch self.mode {
        case .admin:
            self.collectionViewLevel.isHidden = false
            self.lblDescTask.isHidden = false
        case .patient:
            MyGlobalSM.shared.startTotalTimer()
            self.randomTest()
            if MyGlobalSM.shared.internalTimer == nil {
                self.startDisplayAlert()
            }
        }
    }
    
    func startDisplayAlert() {
        self.collectionViewLevel.isHidden = true
        self.lblDescTask.isHidden = true
        
        self.vShadowTask.isHidden = false
        self.vTask.isHidden = false
        
        Status[TestSimpleMemory] = TestStatus.Running
        
        start.isHidden = true
        
        for b in testSelectButtons {
            b.isHidden = true
        }
        
        self.textInputList = []
        self.textDeterminedAdminList = []
        
        let newStartAlert = UIAlertController(title: "Display", message: "Ask patient to name and remember these images.", preferredStyle: .alert)
        newStartAlert.addAction(UIAlertAction(title: "Start", style: .default, handler: { (action) -> Void in
            self.ivTask.isHidden = false
            self.display()
        }))
        self.present(newStartAlert, animated: true, completion: nil)
    }
    
    func display(){
        testCount = 0
        
        debugPrint("testCount = \(testCount), imagesSM = \(imagesSM)")
        debugPrint("imagesSM[testCount] = \(imagesSM[testCount])")
        
        self.outputImage(withImageName: imagesSM[testCount])
        self.createTimerNextPicture()
    }
    
    func outputImage(withImageName name: String) {
        self.ivTask.image = UIImage(named: name)!
    }
    
    func createTimerNextPicture() {
        self.timerNextPicture.invalidate()
        self.timerNextPicture = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerNextPictureAction), userInfo: nil, repeats: true)
    }
    
    // called every time interval from the timer
    @objc func timerNextPictureAction() {
        testCount += 1
        if testCount == imagesSM.count {
            self.timerNextPicture.invalidate()
            self.start.removeTarget(nil, action: nil, for: .allEvents)
            self.start.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
            self.beginDelay()
        } else {
            self.outputImage(withImageName: imagesSM[testCount])
        }
    }
    
    func beginDelay() {
        // Hide Arrow
        self.shouldHiddenImageViewer(true)
        
        self.shouldHiddenDelayViews(false)
        
        self.afterBreakSM = true
        
        self.start.isHidden = false
        
        self.delayTime = Double(MyGlobalSM.shared.SMDelayTime)
        self.totalTime = MyGlobalSM.shared.SMDelayTime - MyGlobalSM.shared.delay
        
        if MyGlobalSM.shared.internalTimer == nil {
            MyGlobalSM.shared.startDelayTimer()
            MyGlobalSM.shared.imagesSM = self.imagesSM
            MyGlobalSM.shared.imageSetSM = self.imageSetSM
            MyGlobalSM.shared.recognizeIncorrectSM = self.recognizeIncorrectSM
            MyGlobalSM.shared.incorrectImageSetSM = self.incorrectImageSetSM
        }
        
        timerSM = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeDecreases), userInfo: nil, repeats: true)
        timerSM.fire()
        startTimeSM = NSDate.timeIntervalSinceReferenceDate
    }
    
    func updateInDelay(timer:Timer){
        
        let currTime = NSDate.timeIntervalSinceReferenceDate
        var diff: TimeInterval = currTime - startTimeSM
        
        let minutes = UInt8(diff / self.maxSeconds)
        
        diff -= (TimeInterval(minutes) * self.maxSeconds)
        
        let seconds = UInt8(diff)
        
        diff = TimeInterval(seconds)
        
        let strMinutes = minutes > 9 ? String(minutes):"0"+String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0"+String(seconds)
        if strMinutes != "00", strSeconds != "00"  {
            timerLabel.textColor = UIColor.red
        }
        timerLabel.text = "\(strMinutes) : \(strSeconds)"
    }
    
    @objc func updateTimeDecreases(timer:Timer) {
        timerLabel.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            self.updateDataDropDown()
            endTimer()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d : %02d", minutes, seconds)
    }
    
    func endTimer() {
        timerSM.invalidate()
        self.start.isHidden = true
        self.resumeTask()
    }
    
    func resumeTask() {
        MyGlobalSM.shared.stopDelayTimer()
        timerSM.invalidate()
        self.isRecalledTestMode = true
        self.shouldHiddenDelayViews(true)
        
        delayTime = delayTime - Double(self.totalTime)
        
        let recallAlert = UIAlertController(title: "Recall", message: "Ask patients to name the items that were displayed earlier. Record their answers.", preferredStyle: .alert)
        recallAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
            
            //action
            self.collectionViewObjectName.isHidden = false
            self.originalAnswerButton.isHidden = self.mode == .patient
            self.collectionViewObjectName.reloadData()
            
            self.nextButton.isHidden = false
            self.nextButton.isEnabled = true
            self.nextButton.addTarget(self, action: #selector(self.doneSM), for: UIControl.Event.touchUpInside)
        }))
        self.present(recallAlert, animated: true, completion: nil)
    }
    
    func findTime() -> Double {
        let currTime = NSDate.timeIntervalSinceReferenceDate
        let time = Double(Int((currTime - startTimeSM)*10))/10.0
        debugPrint("time: \(time)")
        return time
    }
    
    private func randomTest() {
        var randomNumber: Int!
        
        repeat {
            randomNumber = Int.random(in: 0...3)
        } while randomNumber == previousSMTest
        previousSMTest = randomNumber
        
        switch randomNumber {
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
    }
}

// MARK: - UICollectionView Delegate, DataSource, DelegateFlowLayout
extension SimpleMemoryTask: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionViewLevel ? self.imagesLevel.count : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewLevel {
            let widthCollectionView: CGFloat = self.collectionViewLevel.frame.size.width
            let widthCell = ((widthCollectionView - 60) / 4)
            return CGSize.init(width: widthCell, height: 235.0)
        } else {
            let widthCollectionView: CGFloat = self.collectionViewObjectName.frame.size.width
            let widthCell = ((widthCollectionView - 27) / 2)
            return CGSize.init(width: widthCell, height: self.mode == .admin ? 105.0 : 78.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionViewLevel {
            return 20.0
        } else {
            return self.mode == .admin ? 20.0 : 27.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == self.collectionViewLevel ? 20.0 : 27.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewLevel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.identifier(), for: indexPath) as! LevelCell
            let idx = indexPath.row + 1
            let strImageName = self.imagesLevel[indexPath.row]
            cell.ivLevel.image = UIImage.init(named: strImageName)
            cell.lblTitle.text = "Test \(idx)"
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleMemoryCell.identifier(), for: indexPath) as! SimpleMemoryCell
            cell.configureView(mode: self.mode)
            cell.lblTitle.text = "Object name \(indexPath.row + 1):"
            cell.showError = {
                let warningAlert = UIAlertController(title: "Warning",
                                                     message: "Please enter this field.",
                                                     preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                    warningAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(warningAlert, animated: true, completion: nil)
            }
            if self.isStartNew == true {
                cell.tfObjectName.text = ""
                cell.textDeterminedAdmin = ""
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewLevel {
            let idx = indexPath.item
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

            MyGlobalSM.shared.startTotalTimer()
            if MyGlobalSM.shared.internalTimer == nil {
                self.startDisplayAlert()
            }
        }
    }
}

// MARK: - UITableView Delegate, DataSource
extension SimpleMemoryTask: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewResults {
            let cell = tableView.dequeueReusableCell(withIdentifier: SMResultCell.identifier(), for: indexPath) as! SMResultCell
            if indexPath.row == 0 {
                cell.isHeader = true
            }
            else {
                cell.isHeader = false
            }
            
            if self.resultsTask.count > 0 {
                cell.model = self.resultsTask[indexPath.row]
                if indexPath.row < self.resultsTask.count - 1 {
                    cell.arrayConstraintLineBottom.forEach{ $0.constant = 0 }
                }
                else {
                    cell.arrayConstraintLineBottom.forEach{ $0.constant = 1 }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: VACell.identifier(), for: indexPath) as! VACell
            cell.configRegconizedTest(imageNameList: mixedImages, recognizeErrors: recognizeErrors, timeList: recognizeTimes, indexPath: indexPath)
            
            return cell
        }
    }
}

// MARK: - Action
extension SimpleMemoryTask {
    @IBAction func originalAnswerAction(_ sender: Any) {
        let originalAnswerVC = OriginalAnswerVC(frame: CGSize(width: self.view.frame.width / 4,
                                                              height: self.view.frame.height / 3))
        originalAnswerVC.nameList = self.imagesSM
        
        //        self.presentPopover(originalAnswerVC, sourceRect: self.originalAnswerButton.frame, permittedArrowDirections: .up)
        self.presentPopover(originalAnswerVC,
                            sourceRect: CGRect(x: 886, y: 180, width: 0, height: 0),
                            permittedArrowDirections: .up)
    }
    
    @IBAction func btnArrowLeftTapped(_ sender: Any) {
        testCount -= 1
        if testCount >= 0 {
            print("pic: \(testCount)")
            self.outputImage(withImageName: imagesSM[testCount])
        }
    }
    
    @IBAction func btnArrowRightTapped(_ sender: Any) {
        testCount += 1
        if(testCount == imagesSM.count) {
            self.start.removeTarget(nil, action: nil, for: .allEvents)
            self.start.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
            self.beginDelay()
        }
        else {
            self.outputImage(withImageName: imagesSM[testCount])
        }
    }
    
    @IBAction func btnChooseDelayTimeTapped(_ sender: Any) {
        self.dropDownView.showDropDown()
        if self.dropDownView.isDropDownShowing == true {
            // Border color selected
            self.vSetDelayTime.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        }
        else {
            // Border color normal
            self.vSetDelayTime.layer.borderColor = Color.color(hexString: "#EAEAEA").cgColor
        }
    }
    
    @IBAction func btnSetDelayTimeTapped(_ sender: Any) {
        if let item = self.lblChooseDelayTime.text, let idx = self.dataMinutesDropDown.firstIndex(of: item) {
            Settings.SMDelayTime = idx + 1
        }
        self.updateDataDropDown()
    }
    
    @IBAction func actionQuit(_ sender: Any) {
        self.startTimeTask = Foundation.Date()
        
        if quickStartModeOn {
            QuickStartManager.showAlertCompletion(viewController: self, cancel: {
            }, ok: {
                self.clearTimer()
                self.didCompleted?()
            }) {
                self.clearTimer()
            }
        } else {
            self.clearTimer()
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func clearTimer() {
        // Update SMDelayTime of singleton
        if MyGlobalSM.shared.internalTimer != nil {
            if let delayTime = Settings.SMDelayTime {
                MyGlobalSM.shared.SMDelayTime = delayTime*60
            }
        }
        
        self.view.endEditing(true)
        if Status[TestSimpleMemory] != TestStatus.Done {
            Status[TestSimpleMemory] = TestStatus.NotStarted
        }
        
        self.timerSM.invalidate()
        self.regconizeTimer.invalidate()
        self.timerNextPicture.invalidate()
        self.totalTimeCounter.invalidate()
        
        MyGlobalSM.shared.clearAll()
        MyGlobalSM.shared.stopTotalTimer()
        MyGlobalSM.shared.total = 0
        MyGlobalSM.shared.delay = 0
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        ended = true
        timerSM.invalidate()
        regconizeTimer.invalidate()
        
        self.totalTimeCounter.invalidate()
        self.timerNextPicture.invalidate()
        
        if Status[TestSimpleMemory] != TestStatus.Done {
            Status[TestSimpleMemory] = TestStatus.NotStarted
        }
        
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            self.didBackToResult?()
            return
        }
        
        afterBreakSM = false
        
        // Check global delay time not runing
        if MyGlobalSM.shared.internalTimer == nil {
            MyGlobalSM.shared.clearAll()
            MyGlobalSM.shared.stopTotalTimer()
            MyGlobalSM.shared.total = 0
            MyGlobalSM.shared.delay = 0
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc fileprivate func doneSM() {
        self.view.endEditing(true)
        
        if !checkValid() {
            let message = self.mode == .admin ? "Please determine all fields." : "Please enter all fields."
            let warningAlert = UIAlertController(title: "Warning",
                                                 message: message,
                                                 preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                warningAlert.dismiss(animated: true, completion: nil)
            }))
            self.present(warningAlert, animated: true, completion: nil)
        }
        else {
            self.isRegconizeViewHidden(false)
            regconizeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeInput), userInfo: nil, repeats: true)
            regconizeTimer.fire()
            recognize()
            
        }
    }
    
    fileprivate func recognize() {
        self.collectionViewObjectName.isHidden = true
        self.originalAnswerButton.isHidden = true
        self.collectionViewLevel.isHidden = true
        self.nextButton.isHidden = true
        self.vDelay.isHidden = true
        mixedImages = []
        recognizeErrors = []
        timeInput = 0
        testCount = 0
        randomizeRecognize()
    
        if (orderRecognize[testCount] == 0) {
            outputRecognizeImages(MyGlobalSM.shared.imagesSM[testCount], name2: MyGlobalSM.shared.recognizeIncorrectSM[testCount])
        } else {
            outputRecognizeImages(MyGlobalSM.shared.recognizeIncorrectSM[testCount], name2: MyGlobalSM.shared.imagesSM[testCount])
        }

    }
    
    fileprivate func outputRecognizeImages(_ name1: String, name2: String) {
        
        firstButton.setImage(UIImage(named: name1)!, for: .normal)
        firstButton.removeTarget(nil, action:nil, for: .allEvents)
        
        secondButton.setImage(UIImage(named: name2)!, for: .normal)
        secondButton.removeTarget(nil, action:nil, for: .allEvents)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.firstButton.addTarget(self, action: #selector(self.firstButtonTapped), for:.touchUpInside)
            self.secondButton.addTarget(self, action: #selector(self.secondButtonTapped), for:.touchUpInside)
        }
    }
    
    fileprivate func isRegconizeViewHidden(_ isHidden:Bool) {
        self.viewRegconize.isHidden = isHidden
        self.firstButton.isHidden = isHidden
        self.secondButton.isHidden = isHidden
    }
    
    fileprivate func isResutViewHidden(_ isHidden:Bool) {
        self.tableViewResults.isHidden = isHidden
        self.tableViewRegconize.isHidden = isHidden
        self.resultScrollView.isHidden = isHidden
    }
    
    fileprivate func randomizeRecognize() {
        //if 0, correct image on left; if 1, correct on right
        for _ in 0 ..< imagesSM.count {
            self.orderRecognize.append(Int(arc4random_uniform(2)))
        }
    }
    
    @IBAction func firstButtonTapped(_ sender: Any) {
        recognizeTimes.append(roundedNumber(number: timeInput))
        mixedImages.append("\(imagesSM[testCount])-\(recognizeIncorrectSM[testCount])")
        timeInput = 0
        if (orderRecognize[testCount] == 0) {
            recognizeErrors.append(0)
        } else {
            recognizeErrors.append(1)
        }
        
        recognizeNext()
    }
    @IBAction func secondButtonTapped(_ sender: Any) {
        recognizeTimes.append(roundedNumber(number: timeInput))
        mixedImages.append("\(imagesSM[testCount])-\(recognizeIncorrectSM[testCount])")
        timeInput = 0
        if (orderRecognize[testCount] == 0) {
            recognizeErrors.append(1)
        } else {
            recognizeErrors.append(0)
        }
        
        recognizeNext()
    }

    fileprivate func recognizeNext() {
        testCount += 1
        if testCount == imagesSM.count {
            self.isResutViewHidden(false)
            
            displayResult()
            
        } else {
            if(orderRecognize[testCount] == 0) {
                outputRecognizeImages(MyGlobalSM.shared.imagesSM[testCount], name2: MyGlobalSM.shared.recognizeIncorrectSM[testCount])
            } else {
                outputRecognizeImages(MyGlobalSM.shared.recognizeIncorrectSM[testCount], name2: MyGlobalSM.shared.imagesSM[testCount])
            }
        }
    }
    
    fileprivate func roundedNumber(number: Double) -> Double {
        return (number * 10).rounded() / 10
    }
    
    @objc fileprivate func updateTimeInput(timer: Timer) -> Double {
        self.timeInput += 0.1
        return self.timeInput
    }
    
    fileprivate func displayResult() {
        self.ended = true
        
        if let time = Settings.SMDelayTime {
            MyGlobalSM.shared.SMDelayTime = time * 60
        }
        
        MyGlobalSM.shared.clearAll()
        MyGlobalSM.shared.stopTotalTimer()
        self.counterTime.setSeconds(seconds: MyGlobalSM.shared.total)

//        if MyGlobalSM.shared.delay > MyGlobalSM.shared.SMDelayTime {
//            self.delayTime = Double(MyGlobalSM.shared.SMDelayTime)
//        }
//        else {
//            self.delayTime = Double(MyGlobalSM.shared.delay)
//        }
        self.delayTime = Double(MyGlobalSM.shared.delay)
        
        self.collectionViewObjectName.isHidden = true
        self.originalAnswerButton.isHidden = true
        afterBreakSM = false
        self.nextButton.isHidden = true
        var correct = 0
        var incorrect = 0
        self.resultsTask.removeAll()
        self.resultsTask.append(SMResultModel.init())
        
        // Mode patient
        if self.mode == .patient {
            var inputValues: [String] = [String]()
            var correctRecall = [String]()
            var isResulRecall = [Bool]()
            
            // Get List Input
            for i in 0 ..< imagesSM.count {
                let cell = self.collectionViewObjectName.cellForItem(at: IndexPath.init(row: i, section: 0)) as! SimpleMemoryCell
                guard let inputValue = cell.tfObjectName.text else {return}
                inputValues.append(inputValue)
            }
            
            for i in 0 ..< inputValues.count {
                if imagesSM.contains(inputValues[i]) && !correctRecall.contains(inputValues[i]) {
                    correctRecall.append(inputValues[i])
                    isResulRecall.append(true)
                }
                else {
                    isResulRecall.append(false)
                }
            }
            
            for i in 0 ..< isResulRecall.count {
                var result: SMResultModel
                let objectName = "Object \(i+1)"
                if isResulRecall[i] == true {
                    correct += 1
                } else {
                    incorrect += 1
                }
                result = SMResultModel.init(objectName: objectName,
                                            input: inputValues[i],
                                            exactResult: imagesSM[i],
                                            result: isResulRecall[i])
                self.resultsTask.append(result)
            }
        }
        
        for i in 0 ..< imagesSM.count {
            var result: SMResultModel
            let objectName = "Object \(i+1)"
            let exactResult = imagesSM[i]
            
            let cell = self.collectionViewObjectName.cellForItem(at: IndexPath.init(row: i, section: 0)) as! SimpleMemoryCell
            guard let inputValue = cell.tfObjectName.text else {return}
            
             // Mode admin
            if self.mode == .admin {
                if cell.textDeterminedAdmin == "Correct" {
                    correct += 1
                } else if cell.textDeterminedAdmin == "Incorrect" {
                    incorrect += 1
                }
                
                result = SMResultModel.init(objectName: objectName,
                                            input: inputValue,
                                            exactResult: exactResult,
                                            adminDetermine: cell.textDeterminedAdmin)
                self.resultsTask.append(result)
            }
            
            if (recognizeErrors[i] == 0) {
                self.result.longDescription.add("Recognized \(mixedImages[i]) - Correct in \(recognizeTimes[i]) seconds")
                correct += 1
            }
            if (recognizeErrors[i] == 1) {
                self.result.longDescription.add("Recognized \(mixedImages[i]) - Incorrect in \(recognizeTimes[i]) seconds ")
                incorrect += 1
            }
        }
        
        var tmpResultList : [String:Any] = [:]
        
        for i in 0...recognizeErrors.count-1 {
            var res = "Correct"
            if recognizeErrors[i] == 1 {
                res = "Incorrect"
            }
            tmpResultList[mixedImages[i]] = ["Condition":res, "Time":recognizeTimes[i]]
        }
        resultList["Recognize"] = tmpResultList
        //delayResult + outputResult + exactEsults + timeComplete
        
        result.imageVA = mixedImages
        
        // Save Results
        self.totalTimeCounter.invalidate()
        result.startTime = MyGlobalSM.shared.resultStartTime
        result.endTime = Foundation.Date()
        let completeTime = result.totalElapsedSeconds()
        result.shortDescription = "Recall: \(correct) correct, \(incorrect) incorrect. (Sets correct:\(imageSetSM), incorrect:\(incorrectImageSetSM))"
        result.numCorrects = correct
        result.numErrors = incorrect
        resultList["CorrectImageSet"] = imageSetSM
        resultList["IncorrectImageSet"] = incorrectImageSetSM
        resultList["DelayTime"] = delayTime
        resultList["Recall Correct"] =  correct
        resultList["Recall Incorrect"] =  incorrect
        resultList["CompleteTime"] = completeTime//findTime()
        // get list result remove header
        for i in 0..<self.resultsTask.count {
            if i != 0 {
                result.arrSMResult.append(self.resultsTask[i])
            }
        }
        
        result.json = resultList
        resultsArray.add(result)
        
        resultList = [:]
        
        Status[TestSimpleMemory] = TestStatus.Done
        
        // Update SMDelayTime of singleton
        if let delayTime = Settings.SMDelayTime {
            MyGlobalSM.shared.SMDelayTime = delayTime * 60
        }
        
        // Set attributed into lblDelayLength
        let attrs1 = [NSAttributedString.Key.font : Font.font(name: Font.Montserrat.medium, size: 18.0), NSAttributedString.Key.foregroundColor : Color.color(hexString: "#8A9199")]
        let attrs2 = [NSAttributedString.Key.font : Font.font(name: Font.Montserrat.medium, size: 18.0), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrDelayTitle = NSMutableAttributedString(string:"Delay length :", attributes:attrs1)
        let attrDelayContent = NSMutableAttributedString(string:" \(delayTime) seconds", attributes:attrs2)
        
        attrDelayTitle.append(attrDelayContent)
        self.lblDelayLength.text = ""
        self.lblDelayLength.attributedText = attrDelayTitle
        self.lblTimeCompleteTask.text = "Test complete in \(completeTime) seconds"
        
        // Set regconize result
        self.tableViewResults.reloadData()
        self.tableViewRegconize.reloadData()
        
        self.vResults.isHidden = false
        self.btnStartNew.isHidden = false
        self.btnStartNew.addTarget(self, action: #selector(startAlert), for:.touchUpInside)
    }
    
    
    private func checkValid() -> Bool {
        for i in 0 ..< imagesSM.count {
            let cell = self.collectionViewObjectName.cellForItem(at: IndexPath.init(row: i, section: 0)) as! SimpleMemoryCell
            switch self.mode {
            case .admin:
                if cell.textDeterminedAdmin == "" {
                    return false
                }
            case .patient:
                if let inputValue = cell.tfObjectName.text, inputValue.trimmingCharacters(in: .whitespaces).isEmpty {
                    return false
                }
            }
        }
        return true
    }
}

// MARK: - Dismiss Dropdown
extension SimpleMemoryTask {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        if touches.first?.view != self.dropDownView {
            self.vSetDelayTime.layer.borderColor = Color.color(hexString: "#EAEAEA").cgColor
            self.dropDownView.hideDropDown()
        }
    }
}

// MARK: - DropdownView Delegate Get Item Selected
extension SimpleMemoryTask: DropdownViewDelegate {
    func returnItemSelected(item: String) {
        self.vSetDelayTime.layer.borderColor = Color.color(hexString: "#EAEAEA").cgColor
        self.lblChooseDelayTime.text = item
    }
    
    /// Update data Item Selected, hide Dropdown and update State normal into button show dropdown
    func updateDataDropDown() {
        self.dropDownView.itemSelected = MyGlobalSM.shared.SMDelayTime / 60 == 1 ? "1 minute" : "\(MyGlobalSM.shared.SMDelayTime / 60) minutes"
        self.vSetDelayTime.layer.borderColor = Color.color(hexString: "#EAEAEA").cgColor
        self.dropDownView.hideDropDown()
    }
}
