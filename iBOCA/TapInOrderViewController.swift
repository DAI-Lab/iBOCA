//
//  TapInOrderViewController.swift
//  Integrated test v1
//
//  Created by Seth Amarasinghe on 7/14/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//

import UIKit

import Darwin

class TapInOrderViewController: BaseViewController {
    
    
    
    var buttonList = [UIButton]()
    var places:[(Int,Int)] = [(100, 250),  (450, 300), (350, 500), (600, 450), (800, 200), (700, 650), (850, 550), (200, 350), (100, 600), (300, 650)]
    //SHORTER LIST FOR TESTING: var places:[(Int,Int)] = [(100, 200), (450, 250), (350, 450), (600, 400)]
    var order = [Int]() //randomized order of buttons
    var numplaces = 1 //current # of buttons that light up in a row, -1
    var currpressed = 0 //order of button that is about to be pressed
    var numRepeats = 0 //how many times user messed up on the same numplaces, calling repeat()
    var numErrors = 0
    var numCorrects = 0
    var forwardNotBackward = true
    var shouldAppendResult = true
    
    var startTime2 = Foundation.Date()
    
    var ended = false
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var endButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var resultTmpList : [String:Any] = [:]
    var levelStartTime = Foundation.Date()
    var resultList : [String:Any] = [:]
    var testStatus = -1

    //MARK: NEW UI
    @IBOutlet weak var mViewMain: UIView!
    @IBOutlet weak var mBtnBack: UIButton!
    @IBOutlet weak var mImgBack: UIImageView!
    @IBOutlet weak var mLbBack: UILabel!
    @IBOutlet weak var mBtnQuit: GradientButton!
    @IBOutlet weak var mBtnReset: GradientButton!
    @IBOutlet weak var mViewContent: UIView!
    @IBOutlet weak var mNextRound: GradientButton!
    
    
    // QuickStart Mode
    var quickStartModeOn: Bool = false
    var didBackToResult: (() -> ())?
    var didCompleted: (() -> ())?
    
    
    /// true when user tap reset and become false when start test
    var isReseting : Bool = false
    
    var mCounterView : CounterTimeView?
    var mTimerCounting : Timer?
    private var isPause: Bool = false
    private var pressedNextRound: Bool = false
    private var enableNextRound: Bool = false {
        didSet {
            mNextRound.titleLabel?.textColor = enableNextRound ? .white : Color.color(hexString: "#D5C9C4")
            mNextRound.alpha = enableNextRound ? 1 : 0.8
            mNextRound.isUserInteractionEnabled = enableNextRound
        }
    }
    
    //randomize 1st order; light up 1st button
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if testName == "ForwardSpatialSpan" {
            forwardNotBackward = true
            testStatus = TestForwardSpatialSpan
            self.navigationItem.title = "Forward Spatial Span"
        } else if testName == "BackwardSpatialSpan" {
            forwardNotBackward = false
            testStatus = TestBackwardSpatialSpan
            self.navigationItem.title = "Backward Spatial Span"
        }
        
        Status[testStatus] = TestStatus.NotStarted

        endButton.isEnabled = false
        resetButton.isEnabled = false
        //backButton.isEnabled = true
        
        statusLabel.text = ""
        
        randomizeBoard()
        
        randomizeOrder()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPause {
            isPause = false
            reset()
        }
        else {
            startTest()
        }
    }
    
    
    
    @IBAction func ibaNexRound(_ sender: Any) {
        guard numplaces < buttonList.count - 1 else {return}
        self.enableNextRound = false
        self.pressedNextRound = true
        // Skip to next round, mean error increase 1
        self.numErrors += 1
        
        let alert = UIAlertController.init(title: "", message: "Observe the pattern", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { (iaction) in
            self.next(skipChecking: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //start from 1st button; reset all info
    
    @IBAction func Reset(_ sender: Any) {
        
        //backButton.isEnabled = false
        startButton.isEnabled = false
        endButton.isEnabled = true
        resetButton.isEnabled = true
        
        numplaces = 1
        numRepeats = 0
        numErrors = 0
        numCorrects = 0
        currpressed = 0
        self.statusLabel.text = ""
        
        randomizeOrder()
        
        for (index, _) in self.order.enumerated() {
            self.buttonList[index].backgroundColor = UIColor.red
        }
        
        StartTest(resetButton as Any)
    }
    
    //allow buttons to be pressed
    func enableButtons() {
        for (index, _) in order.enumerated() {
            buttonList[index].addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        }
    }
    
    //stop buttons from being pressed
    func disableButtons() {
        for (index, _) in order.enumerated() {
            buttonList[index].removeTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        }
    }
    
    
    //Rotate (180 degrees) or mirror (on x or y) the point
    var xt:Bool = true
    var yt:Bool = true
    func transform(coord:(Int, Int)) -> (Int, Int) {
        var x = coord.0
        var y = coord.1
        if xt  {
            x  = 950 - x
        }
        if yt {
            y = 850 - y
        }
        
        //return (Int(CGFloat(x)*screenSize!.maxX/1024.0), Int(CGFloat(y)*screenSize!.maxY/768.0))
        return (x, y)
    }
    
    
    func randomizeBoard() {
        xt = arc4random_uniform(2000) < 1000
        yt = arc4random_uniform(2000) < 1000
        places = places.map(transform)
    }
    
    
    //changes 'order' and 'buttonList' arrays, adds buttons; called in next, reset and viewDidLoad
    func randomizeOrder() {
        
        debugPrint("randomizing order")
        
        order = [Int]()
        //numplaces = 0
        
        var array = [Int]()
        for i in 0...places.count-1 {
            array.append(i)
        }
        
//        for var k=places.count-1; k>=0; --k{
        for k in 0...places.count-1{
            
            let j = places.count-1-k
            
            let random = Int(arc4random_uniform(UInt32(j)))
            order.append(array[random])
            array.remove(at: random)
        }
        
        buttonList = [UIButton]()
        
        for (_, i) in order.enumerated() {
            let(a,b) = places[i]
            
            let x : CGFloat = CGFloat(a)
            let y : CGFloat = CGFloat(b - 50)
            
            let button = UIButton(type: UIButton.ButtonType.system)
            buttonList.append(button)
            button.frame = CGRect(x: x, y: y, width: 61, height: 61)
            button.backgroundColor = Color.color(hexString: "649BFF")
            self.view.addSubview(button)
            
        }
        
//        print("order is \(order)")
    }
    
    
    @IBAction func StartTest(_ sender: Any) {
        
//delay(1.5){}
        ended = false
        
        //self.navigationItem.setHidesBackButton(true, animated:true)
        
        startButton.isEnabled = false
        endButton.isEnabled = true
        resetButton.isEnabled = true
        //backButton.isEnabled = false
        
        numplaces = 1
        numRepeats = 0
        numErrors = 0
        numCorrects = 0
        
        randomizeOrder()
        
/*
        if let wnd = self.view{
            
            let v = UIView(frame: wnd.bounds)
            v.backgroundColor = UIColor.white
            v.alpha = 1
            
            wnd.addSubview(v)
            UIView.animate(withDuration: 2, animations: {
                v.alpha = 0.0
            }, completion: {(finished:Bool) in
                print("inside")
                v.removeFromSuperview()
            })
        }
 */
        statusLabel.text = "Observe the pattern"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
            guard let iself = self else {
                return
            }
            if iself.forwardNotBackward {
                iself.checkAndDrawSequence(num: 0)
            } else {
                iself.checkAndDrawSequence(num: iself.numplaces)
            }
            iself.startTime2 = Foundation.Date()
            iself.currpressed = 0
        }
        
        //self.statusLabel.text = ""
    }
    
    @IBAction func EndTest(_ sender: Any) {
        //self.navigationItem.setHidesBackButton(false, animated:true)
        startButton.isEnabled = false
        endButton.isEnabled = false
        resetButton.isEnabled = true
        //backButton.isEnabled = true
        donetest()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if !ended {
            donetest()
        }
    }
    
    private func pauseTest() {
        ended = true
        
        startButton.isEnabled = false
        endButton.isEnabled = false
        resetButton.isEnabled = true
        
        mCounterView?.setTimeWith(startTime: Date(), currentTime: Date())
        stopCounter()
    }
    
    func donetest() {
        ended = true
        
        startButton.isEnabled = false
        endButton.isEnabled = false
        resetButton.isEnabled = true
        //backButton.isEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//            self.navigationItem.setHidesBackButton(false, animated:true)
//            self.startButton.isEnabled = true
//           self.endButton.isEnabled = false
//            self.resetButton.isEnabled = false
            
            let result = Results()
            
            if self.forwardNotBackward {
                result.name = TestName.FORWARD_SPATIAL_SPAN
            } else {
                result.name = TestName.BACKWARD_SPATIAL_SPAN
            }
            
//some weird result stuff going on here (as date) if there are errors....
            result.startTime = self.startTime2
            result.endTime = Foundation.Date()
            
            for (index, _) in self.order.enumerated() {
                self.buttonList[index].backgroundColor = Color.color(hexString: "D8E5FA")
            }
            
            self.statusLabel.text = "Spatial span: \(self.numplaces)"
            result.longDescription.add("Spatial span: \(self.numplaces)")
            
            result.json["Places"] = self.numplaces
            result.json["Levels"] = self.resultList
            result.json["Errors"] = self.numErrors
            result.numErrors = self.numErrors
            result.numCorrects = self.numCorrects
            result.shortDescription = "Spatial span of \(self.numplaces) with \(self.numErrors) errors"
            debugPrint("json: \(result.json)")
            debugPrint("Spatial span of \(self.numplaces) with \(self.numErrors) errors")
            if self.shouldAppendResult {
                resultsArray.add(result)
                self.shouldAppendResult = false
            }
            if self.forwardNotBackward {
                Status[TestForwardSpatialSpan] = TestStatus.Done
            } else {
                Status[TestBackwardSpatialSpan] = TestStatus.Done
            }
            
            self.numplaces = 1
            self.numRepeats = 0
            self.numErrors = 0
            self.stopCounter()
        }
    }
    
    func checkAndDrawSequence(num: Int, skipChecking: Bool = false) {
        // In case user press Next Round
        if skipChecking {
            self.pressedNextRound = false
            drawSequenceRecursively(num: num)
        }
        else {
            guard !self.pressedNextRound else {
                self.pressedNextRound = false
                return
            }
            
            drawSequenceRecursively(num: num)
        }
    }
    
    func drawSequenceRecursively(num:Int){
        if (forwardNotBackward && num > numplaces) ||
            (!forwardNotBackward && num < 0){
            var textAlert = "Tap in the order of the pattern observed"
            if self.forwardNotBackward == false {
                textAlert = "Tap in reverse order of the pattern observed"
            }
            self.statusLabel.text = textAlert
            debugPrint("...enabling buttons...numplaces = \(self.numplaces+2)")
            
            let alert = UIAlertController.init(title: "", message: textAlert, preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default, handler: { (iaction) in
                    for (index, _) in self.order.enumerated() {
                        self.buttonList[index].backgroundColor = Color.color(hexString: "649BFF")
                    }

                    self.enableNextRound = self.numplaces < self.buttonList.count - 1
                    self.enableButtons()
                    self.levelStartTime = Foundation.Date()
                    self.resultTmpList.removeAll()
            }))
            if isReseting == false {
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if ended == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){ [weak self] in
                    if self?.ended == false {
                        self?.buttonList[num].backgroundColor = Color.color(hexString: "3EE48D")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
                            if self?.ended == false{
                                self?.buttonList[num].backgroundColor = Color.color(hexString: "649BFF")
                                
                                var num2 : Int = num
                                if self?.forwardNotBackward == true{
                                    num2 += 1
                                } else {
                                    num2 -= 1
                                }
                                
                                self?.checkAndDrawSequence(num: num2)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //call when a mistake is made (-> repeat(), or finish if repeated already)
    //OR call when finished sequence (-> next() if numplaces is not maxxed out, otherwise finish)
    func selectionDone(n:Int, status:Bool) {
        
        disableButtons()
        
        var reslist: [String:Any] = [:]
        reslist["Status"] = status
        reslist["level"] = numplaces + 1
        reslist["keystrokes"] = resultTmpList
        resultList[String((numplaces + 1)*100+numRepeats)] = reslist
        resultTmpList.removeAll()
        
        debugPrint("selection done")
        
        //false means user hit incorrect button
        if status == false {
            
            if numRepeats < 1 {
                `repeat`()
                
                //if user has already repeated this level color changes to gray and test finishes
            } else {
                //account for delay when changing black back to red for most recently pressed button
                donetest()
            }
            
            //true means user finished the sequence correctly up to numplaces
            //if numplaces is not maxxed out, light up one more button (-> next()), otherwise finish w/ perfect score
        } else {
            
            if numplaces < buttonList.count - 1{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
                    let alert = UIAlertController.init(title: "", message: "Observe the pattern", preferredStyle: .alert)
                    alert.addAction(.init(title: "Ok", style: .default, handler: { (iaction) in
                        self?.next()
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            } else {
                //account for delay when changing black back to red for most recently pressed button
                donetest()
            }
        }
        
        // Check tapped correct
        if status == true {
            numCorrects += 1
        }
        debugPrint("Done in \(n)! \(status)")
    }
    
    
    //user messed up; replay same sequence
    func `repeat`(){
        //change color to gray to indicate mistake
        /*
         for (index, i) in enumerate(order) {
         buttonList[index].backgroundColor = UIColor.lightGrayColor()
         }
         */
        //account for delay when changing black back to red for most recently pressed button
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
            guard let iself = self else{
                return
            }
            if iself.ended == false {
                for (index, _) in iself.order.enumerated() {
                    iself.buttonList[index].backgroundColor = Color.color(hexString: "D8E5FA")
                }
            }
        }
        
        //return color to normal, currpressed to zero (restarting that sequence), record the repeat, light up buttons
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if self.ended == false {
//                self.statusLabel.text = "Repeating, Observe the pattern"
                let alert = UIAlertController.init(title: "", message: "Repeating, Observe the pattern", preferredStyle: .alert)
                alert.addAction(.init(title: "Ok", style: .default, handler: { (iaction) in
                    for (index, _) in self.order.enumerated() {
                        self.buttonList[index].backgroundColor = UIColor.red
                    }
                    
                    self.currpressed = 0
                    self.numRepeats += 1
                    self.numErrors += 1
                    self.randomizeOrder()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        if self.forwardNotBackward {
                            self.checkAndDrawSequence(num: 0)
                        } else {
                            self.checkAndDrawSequence(num: self.numplaces)
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    //user completed sequence; reset repeats, increase numplaces so 1 more button lights up
    func next(skipChecking: Bool = false){
        
        numplaces = numplaces + 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            if self.ended == false {
                debugPrint("next; DRAWING RECURSIVE SEQUENCE")
                self.numRepeats = 0
                self.currpressed = 0
                self.randomizeOrder()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                    self.statusLabel.text = "Observe the pattern"
                    for (index, _) in self.order.enumerated() {
                        self.buttonList[index].backgroundColor = Color.color(hexString: "649BFF")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        if self.forwardNotBackward {
                            self.checkAndDrawSequence(num: 0, skipChecking: skipChecking)
                        } else {
                            self.checkAndDrawSequence(num: self.numplaces, skipChecking: skipChecking)
                        }
                    }
                }
            }
        }
    }
    
    //what happens when a user taps a button (if buttons are enabled at the time)
    @objc func buttonAction(sender:UIButton!)
    {
        debugPrint("Button tapped")
        let currTime = Foundation.Date()
        resultTmpList[String(currpressed)] = Int(1000*currTime.timeIntervalSince(levelStartTime))
        
        //find which button user has tapped
        for i in 0...buttonList.count-1 {
            if sender == buttonList[i] {
                debugPrint("In button \(i)")
                
                //change color to indicate tap
                sender.backgroundColor = UIColor.black
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                    sender.backgroundColor = Color.color(hexString: "649BFF")
//                }
                
                //get out of loop if it's the wrong button; will eventually lead to repeat()
                if i != currpressed {
                    debugPrint("BA: Problem \(i) is not \(currpressed)")
                    selectionDone(n: i, status:false)
                    return
                }
                    //if it's the right button AND it's the last in the current sequence exit loop; will eventually go to next()
                else if currpressed == numplaces {
                    debugPrint("BA: at end of list cp=\(currpressed) i=\(i) - all OK")
                    selectionDone(n: i, status:true)
                    return
                }
                debugPrint("BA: \(i) is good")
                
                //if it's the correct button but there are more in sequence, curpressed increases by 1 to check next tap
                currpressed = currpressed + 1
                
                // Delete the action itself
                sender.removeTarget(self, action: #selector(self.buttonAction(sender:)), for: .touchUpInside)
            }
        }
    }
/*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    //delay function
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
        
    }
 */
    
    //MARK: - NEW UI
    func setupUI(){
        mLbBack.font = Font.font(name: Font.Montserrat.semiBold, size: 28)
        mLbBack.textColor = Color.color(hexString: "013AA5")
        //
        mBtnQuit.setTitle(title: "QUIT", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        mBtnQuit.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        mBtnQuit.setupGradient(arrColor: [Color.color(hexString: "#FFAFA6"),Color.color(hexString: "#FE786A")], direction: .topToBottom)
        mBtnQuit.render()
        mBtnQuit.addTextSpacing(-0.36)
        //
        mBtnReset.setTitle(title: "RESET", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        mBtnReset.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        mBtnReset.setupGradient(arrColor: [Color.color(hexString: "#FCD24B"),Color.color(hexString: "#FFC556")], direction: .topToBottom)
        mBtnReset.render()
        mBtnReset.addTextSpacing(-0.36)
        
        mNextRound.setTitle(title: "NEXT", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        mNextRound.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
//        mNextRound.setupGradient(arrColor: [Color.color(hexString: "#FCD24B"),Color.color(hexString: "#FFC556")], direction: .topToBottom)
        mNextRound.render()
        mNextRound.addTextSpacing(-0.36)
        enableNextRound = false
        
        //
        mViewContent.layer.cornerRadius = 8.0
        mViewContent.layer.shadowColor = Color.color(hexString: "#649BFF").withAlphaComponent(0.32).cgColor
        mViewContent.layer.shadowOpacity = 1.0
        mViewContent.layer.shadowOffset = CGSize(width: 0, height: 2)
        mViewContent.layer.shadowRadius = 10 / 2.0
        mViewContent.layer.shadowPath = nil
        mViewContent.layer.masksToBounds = false
        //
        mCounterView = CounterTimeView()
        mViewMain.addSubview(mCounterView!)
        mCounterView?.centerXAnchor.constraint(equalTo: mViewMain.centerXAnchor).isActive = true
        mCounterView?.topAnchor.constraint(equalTo: mViewMain.topAnchor, constant:  60).isActive = true
        
        // Change back button title if quickStartMode is On
        if quickStartModeOn {
            mLbBack.text = "RESULTS"
            mBtnQuit.updateTitle(title: "CONTINUE")
        }
    }
    
    func startTest(){
        isReseting = false
        ended = false
        startButton.isEnabled = false
        endButton.isEnabled = true
        resetButton.isEnabled = true
    
        numplaces = 1
        numRepeats = 0
        numErrors = 0
        
        randomizeOrder()
        self.startTime2 = Foundation.Date()
        self.currpressed = 0
        self.startCounter()
        statusLabel.text = "Observe the pattern"
        let alert = UIAlertController.init(title: "", message: "Observe the pattern" , preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { (iaction) in
            if self.forwardNotBackward {
                self.checkAndDrawSequence(num: 0)
            } else {
                self.checkAndDrawSequence(num: self.numplaces)
            }
          
        }))
        if let oldAlert =  self.presentedViewController{
            oldAlert.dismiss(animated: false) {
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func reset(){
        //backButton.isEnabled = false
        isReseting = true
        startButton.isEnabled = false
        endButton.isEnabled = true
        resetButton.isEnabled = true
        
        numplaces = 1
        numRepeats = 0
        numErrors = 0
        currpressed = 0
        self.statusLabel.text = ""
        
        randomizeOrder()
        
        for (index, _) in self.order.enumerated() {
            self.buttonList[index].backgroundColor = Color.color(hexString: "649BFF")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
            guard let iself = self else {
                return
            }
            iself.startTest()
        }
    }
    
    func startCounter(){
        mTimerCounting?.invalidate()
        mTimerCounting = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (itimer) in
            self.mCounterView?.setTimeWith(startTime: self.startTime2, currentTime: Date())
        })
    }
    
    func stopCounter(){
        mTimerCounting?.invalidate()
    }
    
    @IBAction func tapBtnBack(_ sender: Any) {
        debugPrint("tap btn back")
        
        if Status[testStatus] != TestStatus.Done {
            Status[testStatus] = TestStatus.NotStarted
        }
        
        // Stop the test
        pauseTest()
        
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            isPause = true
            didBackToResult?()
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapBtnQuit(_ sender: Any) {
        //self.navigationItem.setHidesBackButton(false, animated:true)
        startButton.isEnabled = false
        endButton.isEnabled = false
        resetButton.isEnabled = true
        //backButton.isEnabled = true
        
        donetest()
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            
            QuickStartManager.showAlertCompletion(viewController: self, endAllTest: !forwardNotBackward, cancel: {
                self.didBackToResult?()
            }, ok: {
                self.didCompleted?()
            })
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBtnReset(_ sender: Any) {
        reset()
    }
    
}
