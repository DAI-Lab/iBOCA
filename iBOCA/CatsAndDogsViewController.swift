//
//  CatsAndDogsViewController.swift
//  CatsAndDogs
//
//  Created by School on 7/25/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import UIKit

import Darwin
import Foundation

class CatsAndDogsViewController: ViewController {
    
    var buttonList = [UIButton]()
    var imageList = [UIImageView]()
    var boxList = [UIImageView]()
    var places:[(Int,Int)] = [(150, 250), (450, 300), (350, 500), (600, 450), (800, 200), (700, 650), (850, 550), (250, 350), (150, 600), (300, 650)]
    //SHORTER LIST FOR TESTING: var places:[(Int,Int)] = [(100, 200), (450, 250), (350, 450), (600, 400)]
    var order = [Int]() //randomized order of buttons
    
    var pressed = [Int]()
    var correctDogs = [Int]()
    var missedDogs = [Int]()
    var incorrectCats = [Int]()
    var missedCats = [Int]()
    var incorrectRandom = [Int]()
    var times = [Double]()
    var button_times = [Double]()
    
    var resultTmpList : [String:Any] = [:]
    
    var dogList = [Int]()
    var catList = [Int]()
    var break1 = Int()
    var break2 = Int()
    
    var timePassed = Double()
    var timeOfTap = Double()    // timer to figure out how long after the last tap
    var timeOfStart = Double()  // timer to figure out how long after the start of the round
    
    @IBOutlet weak var sequenceSelectionButton: UIButton!
    @IBOutlet weak var btn_start: UIButton!
    
    var iTimer: Timer?
    var startTime = TimeInterval()
    var startTime2 = Foundation.Date()
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var cats = Int() //# cats
    var dogs = Int() //# dogs
    var level = 0 //current level
    var repetition = 0
    
    var ended = false
    
    @IBOutlet weak var backButton: UIButton!
    
//    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var endButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    //start from 1st button; reset all info
    
    @IBAction func Reset(_ sender: Any) {
        print("in reset")
        
        for k in 0 ..< buttonList.count {
            buttonList[k].removeFromSuperview()
        }
        
        for j in 0 ..< imageList.count {
            imageList[j].removeFromSuperview()
        }
        
        for j in 0 ..< boxList.count {
            boxList[j].removeFromSuperview()
        }
        
        dogList = [Int]()
        catList = [Int]()
        buttonList = [UIButton]()
        imageList = [UIImageView]()
        boxList = [UIImageView]()
        order = [Int]()
        pressed = [Int]()
        correctDogs = [Int]()
        missedDogs = [Int]()
        incorrectCats = [Int]()
        missedCats = [Int]()
        incorrectRandom = [Int]()
        times = [Double]()
        button_times = [Double]()
        resultTmpList = [:]
        timePassed = Double()
        startTime = TimeInterval()
        startTime2 = Foundation.Date()
        level = 0 //current level
        repetition = 0
        ended = false
//        startButton.isEnabled = false
        endButton.isEnabled = false
        resetButton.isEnabled = false
        backButton.isEnabled = true
        timeOfTap = -1.0
        timeOfStart = -1.0
        
        setSequence()
        
//        StartTest(resetButton)
//        startAlert()
    }
    
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var field1 = UITextField()
    var field2 = UITextField()
    var field3 = UITextField()
    
    
    func setSequence(){
        label1 = UILabel(frame: CGRect(x: 50, y: 200, width: 350, height: 100))
        label1.textAlignment = .left
        label1.numberOfLines = 2
        label1.text = "Dogs Alone:\n(Format: #dogs1,#dogs2,#dogs3...))"
        self.view.addSubview(label1)
        
        label2 = UILabel(frame: CGRect(x: 50, y: 350, width: 350, height: 100))
        label2.textAlignment = .left
        label2.numberOfLines = 2
        label2.text = "Dogs with Cat Distractors:\n(Format: (#dogs1,#cats1),(#dogs2,#cats2)...)"
        self.view.addSubview(label2)
        
        label3 = UILabel(frame: CGRect(x: 50, y: 500, width: 350, height: 100))
        label3.textAlignment = .left
        label3.numberOfLines = 2
        label3.text = "Cats with Dog Distractors:\n(Format: (#dogs1,#cats1),(#dogs2,#cats2)...)"
        self.view.addSubview(label3)
        
        field1 = UITextField(frame: CGRect(x: 450, y: 200, width: 510, height: 100))
        if(UserDefaults.standard.object(forKey: "CandD-Dogs") != nil) {
             field1.text = (UserDefaults.standard.object(forKey: "CandD-Dogs") as! String)
        } else {
            field1.text = "2,3,4"
        }
        field1.borderStyle = UITextBorderStyle.roundedRect
        field1.keyboardType = UIKeyboardType.numbersAndPunctuation
        field1.isEnabled = true
        self.view.addSubview(field1)
        
        field2 = UITextField(frame: CGRect(x: 450, y: 350, width: 510, height: 100))
        if(UserDefaults.standard.object(forKey: "CandD-Dogs-no-Cats") != nil) {
            field2.text = (UserDefaults.standard.object(forKey: "CandD-Dogs-no-Cats") as! String)
        } else {
            field2.text = "(2,2),(3,2),(4,2),(2,4),(3,4),(4,4)"
        }
        field2.borderStyle = UITextBorderStyle.roundedRect
        field2.keyboardType = UIKeyboardType.numbersAndPunctuation
        field2.isEnabled = true
        self.view.addSubview(field2)
        
        field3 = UITextField(frame: CGRect(x: 450, y: 500, width: 510, height: 100))
        if(UserDefaults.standard.object(forKey: "CandD-Cats-no-Dogs") != nil) {
            field3.text = (UserDefaults.standard.object(forKey: "CandD-Cats-no-Dogs") as! String)
        } else {
            field3.text = "(2,2),(2,3),(2,4),(4,2),(4,3),(4,4)"
        }
        field3.borderStyle = UITextBorderStyle.roundedRect
        field3.keyboardType = UIKeyboardType.numbersAndPunctuation
        field3.isEnabled = true
        self.view.addSubview(field3)
        
        sequenceSelectionButton.isHidden = false
        sequenceSelectionButton.isEnabled = true
        sequenceSelectionButton.isUserInteractionEnabled = false
        btn_start.isHidden = false
        btn_start.isEnabled = true
    }
    
    @IBAction func btnStartSelected(_ sender: UIButton) {
        // BUGBUG: Need to make sure a bad input will not crash the app
        
        let dogsAlone = field1.text
        var dogsCats1 = field2.text
        var dogsCats2 = field3.text
        
        dogsCats1?.remove(at: (dogsCats1?.index(before: (dogsCats1?.endIndex)!))!)
        dogsCats1?.remove(at: (dogsCats1?.startIndex)!)
        
        dogsCats2?.remove(at: (dogsCats2?.index(before: (dogsCats2?.endIndex)!))!)
        dogsCats2?.remove(at: (dogsCats2?.startIndex)!)
        
        label1.isHidden = true
        label2.isHidden = true
        label3.isHidden = true
        field1.isHidden = true
        field1.isEnabled = false
        field2.isHidden = true
        field2.isEnabled = false
        field3.isHidden = true
        field3.isEnabled = false
        sequenceSelectionButton.isHidden = true
        btn_start.isHidden = true
        
        do {
            let dogsAloneArr = dogsAlone?.components(separatedBy: ",")
            
            //        print(dogsAloneArr)
            
            let up0 = (dogsAloneArr?.count) ?? 0
            for i in 0...up0 - 1 {
                let x =  (dogsAloneArr?[i]) ?? "1"
                let y =  Int(x) ?? 0
                dogList.append(y)
                catList.append(0)
            }
            
            //        let separators = CharacterSet(charactersIn: "),(")
            
            let dogsCats1Arr = dogsCats1?.components(separatedBy: String("),("))
            
            //        print(dogsCats1Arr)
            
            let up1 = (dogsCats1Arr?.count) ?? 0
            for i in 0...up1 - 1 {
                let split1 = dogsCats1Arr?[i].components(separatedBy: ",")
                let x1 = (split1?[0]) ?? "1"
                let y1 = Int(x1) ?? 1
                dogList.append(y1)
                let x2 = (split1?[1]) ?? "1"
                let y2 = Int(x2) ?? 1
                catList.append(y2)
            }
            
            let dogsCats2Arr = dogsCats2?.components(separatedBy: String("),("))
            
            //        print(dogsCats2Arr)
            
            let up2 = (dogsCats2Arr?.count) ?? 0
            for i in 0...up2 - 1 {
                let split2 = dogsCats2Arr?[i].components(separatedBy: ",")
                let x1 = (split2?[0]) ?? "1"
                let y1 = Int(x1) ?? 1
                dogList.append(y1)
                let x2 = (split2?[1]) ?? "1"
                let y2 = Int(x2) ?? 1
                catList.append(y2)
            }
            
            break1 = up0
            break2 = up0 + up1
            
            UserDefaults.standard.set(field1.text, forKey:"CandD-Dogs")
            UserDefaults.standard.set(field2.text, forKey:"CandD-Dogs-no-Cats")
            UserDefaults.standard.set(field3.text, forKey:"CandD-Cats-no-Dogs")
            UserDefaults.standard.synchronize()
            
            cats = catList[0]
            dogs = dogList[0]
            
            //print("doglist:", dogList)
            //print("catlist:", catList)
            //print("breaks:", break1, break2)
            
            startAlert()
        } catch {
            break1 = 0
            break2 = 0
            resultsLabel.text = "Invalid Sequence Data"
        }
    }
    
    @IBAction func sequenceSelected(_ sender: Any) {
        // BUGBUG: Need to make sure a bad input will not crash the app
        
        let dogsAlone = field1.text
        var dogsCats1 = field2.text
        var dogsCats2 = field3.text
        
        dogsCats1?.remove(at: (dogsCats1?.index(before: (dogsCats1?.endIndex)!))!)
        dogsCats1?.remove(at: (dogsCats1?.startIndex)!)
        
        dogsCats2?.remove(at: (dogsCats2?.index(before: (dogsCats2?.endIndex)!))!)
        dogsCats2?.remove(at: (dogsCats2?.startIndex)!)
        
        label1.isHidden = true
        label2.isHidden = true
        label3.isHidden = true
        field1.isHidden = true
        field1.isEnabled = false
        field2.isHidden = true
        field2.isEnabled = false
        field3.isHidden = true
        field3.isEnabled = false
        sequenceSelectionButton.isHidden = true
        btn_start.isHidden = true
        
        do {
            let dogsAloneArr = dogsAlone?.components(separatedBy: ",")
            
            //        print(dogsAloneArr)
            
            let up0 = (dogsAloneArr?.count) ?? 0
            for i in 0...up0 - 1 {
                let x =  (dogsAloneArr?[i]) ?? "1"
                let y =  Int(x) ?? 0
                dogList.append(y)
                catList.append(0)
            }
            
            //        let separators = CharacterSet(charactersIn: "),(")
            
            let dogsCats1Arr = dogsCats1?.components(separatedBy: String("),("))
            
            //        print(dogsCats1Arr)
            
            let up1 = (dogsCats1Arr?.count) ?? 0
            for i in 0...up1 - 1 {
                let split1 = dogsCats1Arr?[i].components(separatedBy: ",")
                let x1 = (split1?[0]) ?? "1"
                let y1 = Int(x1) ?? 1
                dogList.append(y1)
                let x2 = (split1?[1]) ?? "1"
                let y2 = Int(x2) ?? 1
                catList.append(y2)
            }
            
            let dogsCats2Arr = dogsCats2?.components(separatedBy: String("),("))
            
            //        print(dogsCats2Arr)
            
            let up2 = (dogsCats2Arr?.count) ?? 0
            for i in 0...up2 - 1 {
                let split2 = dogsCats2Arr?[i].components(separatedBy: ",")
                let x1 = (split2?[0]) ?? "1"
                let y1 = Int(x1) ?? 1
                dogList.append(y1)
                let x2 = (split2?[1]) ?? "1"
                let y2 = Int(x2) ?? 1
                catList.append(y2)
            }
            
            break1 = up0
            break2 = up0 + up1
            
            UserDefaults.standard.set(field1.text, forKey:"CandD-Dogs")
            UserDefaults.standard.set(field2.text, forKey:"CandD-Dogs-no-Cats")
            UserDefaults.standard.set(field3.text, forKey:"CandD-Cats-no-Dogs")
            UserDefaults.standard.synchronize()
            
            cats = catList[0]
            dogs = dogList[0]
            
            //print("doglist:", dogList)
            //print("catlist:", catList)
            //print("breaks:", break1, break2)
            
            startAlert()
        } catch {
            break1 = 0
            break2 = 0
            resultsLabel.text = "Invalid Sequence Data"
        }
    }
    
    
    
    func findTime()->Double{
        
        timeOfTap = NSDate.timeIntervalSinceReferenceDate
        
        let currTime = NSDate.timeIntervalSinceReferenceDate
        var diff: TimeInterval = currTime - startTime
        print(diff)
        let minutes = UInt8(diff / 60.0)
        diff -= (TimeInterval(minutes)*60.0)
        let seconds = Double(diff)
        return seconds
        
    }
    
    //what happens when a user taps a button (if buttons are enabled at the time)
    func buttonAction(sender:UIButton!)
    {
        
        //print("Button tapped")
        
        timePassed = findTime()
        button_times.append(timePassed)
        
        //find which button user has tapped
        for i in 0...buttonList.count-1 {
            if sender == buttonList[i] {
                print("In button \(i)")
                
                //change color to indicate tap
                sender.backgroundColor = UIColor.darkGray
                sender.isEnabled = false
                
                pressed.append(i)
            }
        }
        
    }
    
    //allow buttons to be pressed
    func enableButtons() {
        
        for (index, _) in order.enumerated() {
            buttonList[index].addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        }
        print("buttons enabled")
    }
    
    //stop buttons from being pressed
    func disableButtons() {
        for (index, _) in order.enumerated() {
            buttonList[index].removeTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        }
        print("buttons disabled")
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
        
        print("randomizing order")
        
        order = [Int]()
        //numplaces = 0
        
        var array = [Int]()
        for i in 0...places.count-1 {
            array.append(i)
        }
        
//IDK IF THIS WILL WORK BACKWARDS???
        
        for k in 0...places.count-1 {
            
            let j = places.count-1-k
            let random = Int(arc4random_uniform(UInt32(j)))
            order.append(array[random])
            array.remove(at: random)
        }
        
        print("order is \(order)")
    }
    
    //randomize 1st order; light up 1st button
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Cats And Dogs"
        
//        startButton.isEnabled = true
        endButton.isEnabled = false
        resetButton.isEnabled = false
        backButton.isEnabled = true
        print("here")
        print("getting here")
        
        timeOfTap = -1.0
        timeOfStart = -1.0
        
        setSequence()
        
//        startAlert()
    }
    
    func startAlert(){
        
        print("getting to start alert")
                
        let alert = UIAlertController(title: "Start", message: "Follow instructions to tap cats and dogs behind the boxes.", preferredStyle: .alert)
        
        let str = NSMutableAttributedString(string: "\nFollow instructions to tap cats and dogs behind the boxes.", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 30.0)])
        alert.setValue(str, forKey: "attributedMessage")
        
        let header = NSMutableAttributedString(string: "Start", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 25.0)])
        alert.setValue(header, forKey: "attributedTitle")
        
        
        alert.addAction(UIAlertAction(title: "Start", style: .cancel, handler: { (action) -> Void in
            self.StartTest()
        }))
  
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
//        self.present(alert, animated: true, completion: nil)
    }
    
    func update(timer: Timer) {
        let currTime = NSDate.timeIntervalSinceReferenceDate
        if(timeOfTap != -1.0){  // has tapped one of the boxes
            let diff = currTime - timeOfTap
            timeOfStart = -1.0 // reset from start round timer
            if(diff >= 1.5){ // too long after last tap
                timeOfTap = -1.0 // reset the timer
                selectionDone()
            }
        } else if(timeOfStart != -1.0){  // from start timer running
            let diff = currTime - timeOfStart
            if(diff >= 3) { // wated too long to tap anyting
                timeOfStart = -1.0 // reset from start timer
                selectionDone()
            }
        }
    }
    
    func display(){
        print("Displaying...")
        
        endButton.isEnabled = false
        resetButton.isEnabled = false
        
        for index in 0 ..< order.count {
            UIView.animate(withDuration: 0.2, animations:{
//                self.buttonList[index].frame = CGRect(x: self.buttonList[index].frame.origin.x - 110, y: self.buttonList[index].frame.origin.y, width: self.buttonList[index].frame.size.width, height: self.buttonList[index].frame.size.height)
                self.buttonList[index].alpha = 0.0
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
            for index in 0 ..< self.order.count {
                UIView.animate(withDuration: 0.2, animations:{
//                    self.buttonList[index].frame = CGRect(x: self.buttonList[index].frame.origin.x + 110, y: self.buttonList[index].frame.origin.y, width: self.buttonList[index].frame.size.width, height: self.buttonList[index].frame.size.height)
                    self.buttonList[index].alpha = 1.0
                })
            }
            /*
            self.selectionDoneButton.isEnabled = true
            
            self.enableButtons()
            self.startTime = NSDate.timeIntervalSinceReferenceDate
 */
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.endButton.isEnabled = true
            self.resetButton.isEnabled = true
            self.enableButtons()
            self.startTime = NSDate.timeIntervalSinceReferenceDate
            self.timeOfStart = NSDate.timeIntervalSinceReferenceDate
        }
    }
    
    func StartTest() {
        endButton.isEnabled = false
        resetButton.isEnabled = false
//        startButton.isEnabled = false
        backButton.isEnabled = false
        
        randomizeBoard()
        
        randomizeOrder()
        
        for i in 0 ..< order.count {
            let(a,b) = places[order[i]]
            
            let x : CGFloat = CGFloat(a)
            let y : CGFloat = CGFloat(b)
            
            if(i <= dogs - 1) {
                
                let image = UIImage(named: "dog")!
                let imageView = UIImageView(frame:CGRect(x: (x + (100-(100.0*(image.size.width)/(image.size.height)))/2), y: y, width: 100.0*(image.size.width)/(image.size.height), height: 100.0))
                imageView.image = image
                self.view.addSubview(imageView)
                imageList.append(imageView)
            }
                
            else {
                if(i <= cats + dogs - 1) {
                    
                    let image = UIImage(named: "cat1")!
                    let imageView = UIImageView(frame:CGRect(x: (x + (100-(100.0*(image.size.width)/(image.size.height)))/2), y: y, width: 100.0*(image.size.width)/(image.size.height), height: 100.0))
                    imageView.image = image
                    self.view.addSubview(imageView)
                    imageList.append(imageView)
                }
            }
            
         
            let box = UIImageView(frame: CGRect(x: x, y: y, width: 100, height: 100))
            boxList.append(box)
            box.layer.borderColor = UIColor.blue.cgColor
            box.layer.borderWidth = 2
            self.view.addSubview(box)
            
            
            let button = UIButton(type: UIButtonType.system)
            buttonList.append(button)
            button.frame = CGRect(x: x, y: y, width: 100, height: 100)
            button.backgroundColor = UIColor.blue
            self.view.addSubview(button)
            
        }
        
        iTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        startTime = NSDate.timeIntervalSinceReferenceDate
        
        ended = false
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        level = 0
        cats = catList[0]
        dogs = dogList[0]
        
        
        alert(info: "Tap all the dogs", display: true, start: true)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
//            self.display()
//            self.startTime2 = NSDate()
//        }
        
        self.resultsLabel.text = ""
    }
    
    
    @IBAction func EndTest(_ sender: Any) {
        self.navigationItem.setHidesBackButton(false, animated:true)
//        startButton.isEnabled = false
        endButton.isEnabled = false
        resetButton.isEnabled = true
        backButton.isEnabled = true
        iTimer?.invalidate()
        donetest()
        
    }
    
    func drawstart() {
        
    }
    
    func donetest() {
        ended = true
        
        
        let result = Results()
        result.name = "Cats and Dogs"
        result.startTime = startTime2 as Date
        result.endTime = Foundation.Date()
        
        self.buttonList.forEach{ $0.removeFromSuperview() }
        self.imageList.forEach{ $0.removeFromSuperview() }
        self.boxList.forEach{ $0.removeFromSuperview() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.navigationItem.setHidesBackButton(false, animated:true)
//            self.startButton.isEnabled = false
            self.endButton.isEnabled = false
            self.resetButton.isEnabled = true
            self.backButton.isEnabled = true
            
            for (index, _) in self.order.enumerated() {
                self.buttonList[index].backgroundColor = UIColor.darkGray
                
            }
            
            var resulttxt = ""
            result.numErrors = 0
            
            var reslist : [String:Any] = [:]
            
            for k in 0 ..< self.level {
                
                var r = ""
                if k < self.break2 {
                    r = "\(self.correctDogs[k]) dogs correctly selected out of \(self.missedDogs[k]+self.correctDogs[k]) dogs; \(self.incorrectCats[k]) cats incorrectly selected out of \(self.incorrectCats[k]+self.missedCats[k]) cats; \(self.incorrectRandom[k]) empty places incorrectly selected. Time: \(self.times[k]) seconds\n"
                    let errors = self.missedDogs[k] + self.incorrectCats[k] + self.incorrectRandom[k]
                    result.numErrors += errors
                    var rl:[String:Any] = [:]
                    rl["Dogs Correct"] = self.correctDogs[k]
                    rl["Dogs Total"]  = self.missedDogs[k]+self.correctDogs[k]
                    rl["Cats Incorrect"] = self.incorrectCats[k]
                    rl["Cats Total"] = self.incorrectCats[k]+self.missedCats[k]
                    rl["Empty Incorrect"] = self.incorrectRandom[k]
                    rl["Time"] = self.times[k]
                    rl["Num Errors"] = errors
                    reslist[String(k)] = rl
                }
                else {
                    r = "\(self.correctDogs[k]) dogs incorrectly selected out of \(self.missedDogs[k]+self.correctDogs[k]) dogs; \(self.incorrectCats[k]) cats correctly selected out of \(self.incorrectCats[k]+self.missedCats[k]) cats; \(self.incorrectRandom[k]) empty places incorrectly selected. Time: \(self.times[k]) seconds\n"
                    let errors = self.correctDogs[k] + self.missedCats[k] + self.incorrectRandom[k]
                    result.numErrors += errors
                    var rl:[String:Any] = [:]
                    rl["Dogs inorrect"] = self.correctDogs[k]
                    rl["Dogs Total"]  = self.missedDogs[k]+self.correctDogs[k]
                    rl["Cats correct"] = self.incorrectCats[k]
                    rl["Cats Total"] = self.incorrectCats[k]+self.missedCats[k]
                    rl["Empty Incorrect"] = self.incorrectRandom[k]
                    rl["Time"] = self.times[k]
                    rl["Num Errors"] = errors
                    reslist[String(k)] = rl
                }
                
                resulttxt.append(r)
                result.longDescription.add(r)
            }
            
            print(resulttxt)
            self.resultLabel.text = resulttxt
            
            result.json = ["Passes":self.resultTmpList, "Score":reslist]
            resultsArray.add(result)
            
            Status[TestCatsAndDogs] = TestStatus.Done
            
        }
    }
    
    
//    @IBAction func selectionDone(_ sender: Any) {
    func selectionDone(){
        
        disableButtons()
        
        times.append(timePassed)
        timePassed = 0
        
        var tmpres : [String:Any] = [:]
        
        print("selection done; dogs = \(dogs), cats = \(cats)")
        
        var dogCount = 0
        var catCount = 0
        var otherCount = 0
        for k in 0 ..< pressed.count {
            if(pressed[k] < dogs){
                dogCount += 1
                tmpres[String(k)] = ["Type":"Dog", "Time":button_times[k]]
            }
            else {
                if(pressed[k] < dogs + cats){
                    catCount += 1
                    tmpres[String(k)] = ["Type":"Cat", "Time":button_times[k]]
                }
                else {
                    otherCount += 1
                    tmpres[String(k)] = ["Type":"Other", "Time":button_times[k]]
                }
            }
        }
        resultTmpList[String(level)] = ["Dogs":dogs, "Cats":cats, "Dogs found":dogCount, "Cats found":catCount, "Path":tmpres]
        pressed = [Int]()
        
        print("catCount = \(catCount), dogCount = \(dogCount), otherCount = \(otherCount), time = \(timePassed)")
        correctDogs.append(dogCount)
        missedDogs.append(dogs-dogCount)
        incorrectCats.append(catCount)
        missedCats.append(cats-catCount)
        incorrectRandom.append(otherCount)
        
        next()
    }
    
    
    //  level        0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
//    let levelcats = [0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
//    let leveldogs = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4]
    
    //user completed sequence; reset repeats, increase numplaces so 1 more button lights up
    func next(){
        
        level += 1
        
        print("next; level = \(level)")
        button_times = [Double]()
        
        if (level == catList.count){
            if(repetition<0) {
                level = 0
                repetition += 1
            }
            else {
                donetest()
            }
        }
            
        else {
            cats = catList[level]
            dogs = dogList[level]
            
            randomizeOrder()
            print("order randomized; cats = \(cats), dogs = \(dogs)")
            
            for k in 0 ..< buttonList.count {
                buttonList[k].removeFromSuperview()
            }
            for k in 0 ..< imageList.count {
                imageList[k].removeFromSuperview()
            }
            for k in 0 ..< boxList.count {
                boxList[k].removeFromSuperview()
            }
            buttonList = [UIButton]()
            imageList = [UIImageView]()
            boxList = [UIImageView]()
            
            for i in 0 ..< order.count {
                let(a,b) = places[order[i]]
                
                let x : CGFloat = CGFloat(a)
                let y : CGFloat = CGFloat(b)
                
                if(i <= dogs - 1) {
                    
                    let image = UIImage(named: "dog")!
                    let imageView = UIImageView(frame:CGRect(x: (x + (100-(100.0*(image.size.width)/(image.size.height)))/2), y: y, width: 100.0*(image.size.width)/(image.size.height), height: 100.0))
                    imageView.image = image
                    self.view.addSubview(imageView)
                    imageList.append(imageView)
                    
                    //print("shoulda added dog images")
                    
                } else {
                    if(i <= cats + dogs - 1) {
                        
                        let image = UIImage(named: "cat1")!
                        let imageView = UIImageView(frame:CGRect(x: (x + (100-(100.0*(image.size.width)/(image.size.height)))/2), y: y, width: 100.0*(image.size.width)/(image.size.height), height: 100.0))
                        imageView.image = image
                        self.view.addSubview(imageView)
                        imageList.append(imageView)
                        
                        //print("shoulda added cat images")
                    }
                }
                
                let box = UIImageView(frame: CGRect(x: x, y: y, width: 100, height: 100))
                boxList.append(box)
                box.layer.borderColor = UIColor.blue.cgColor
                box.layer.borderWidth = 2
                self.view.addSubview(box)
                
                let button = UIButton(type: UIButtonType.system)
                buttonList.append(button)
                button.frame = CGRect(x: x, y: y, width: 100, height: 100)
                button.backgroundColor = UIColor.blue
                self.view.addSubview(button)
                
                //print("shoulda added buttons")
            }
            
            if(level == 0){
                alert(info: "Tap all the dogs.", display: true, start: true)
            }
            if(level == break1){
                alert(info: "Tap all the dogs.\nDo NOT tap the cats.", display: true, start: false)
            }
            if(level == break2){
                alert(info: "Tap all the cats.\nDo NOT tap the dogs.", display: true, start: false)
            }
            
            if(level != 0 && level != break1 && level != break2){
                display()
            }
            
        }
    }
    
    func alert(info:String, display: Bool, start: Bool){
        
        let alert = UIAlertController(title: "Instructions", message: info, preferredStyle: .alert)
        
        let str = NSMutableAttributedString(string: "\n" + info, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 50.0)])
        alert.setValue(str, forKey: "attributedMessage")
        
        let header = NSMutableAttributedString(string: "Instructions", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 30.0)])
        alert.setValue(header, forKey: "attributedTitle")
        
        /*
         //2. Add the text field. You can configure it however you need.
         
         alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
         textField.text = ""
         
         })
         */
        //3. Grab the value from the text field, and print it when the user clicks OK.
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
            if(display == true){
                self.display()
            }
            if(start == true){
                self.startTime2 = Foundation.Date()
            }
        }))
        
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}



