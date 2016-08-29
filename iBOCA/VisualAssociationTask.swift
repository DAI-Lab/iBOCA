//
//  VisualAssociationTask.swift
//  iBOCA
//
//  Created by School on 8/6/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import Foundation

import UIKit

var mixedImages = [String]()
var halfImages = [String]()
var recognizeIncorrect = [String]()

var afterBreak = Bool()

var imageSet = Int()

var startTime = NSTimeInterval()
var startTime2 = NSDate()
var timer = NSTimer()

var recallErrors = [Int]()
var recallTimes = [Double]()

var recognizeErrors = [Int]()
var recognizeTimes = [Double]()

class VisualAssociationTask: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var start: UIButton!
    
    @IBOutlet weak var next: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var delayLabel: UILabel!
    
    @IBOutlet weak var correct: UIButton!
    @IBOutlet weak var incorrect: UIButton!
    @IBOutlet weak var dk: UIButton!
    
    var mixed1 = ["orange", "green", "purple", "grey"]
    var half1 = ["red", "yellow", "blue", "black"]
    var incorrect1 = ["red", "yellow", "blue", "black"]
    
    var imageName = ""
    var image = UIImage()
    var imageView = UIImageView()
    var gesture = UIPanGestureRecognizer()
    
    var imageName1 = ""
    var image1 = UIImage()
    var imageView1 = UIImageView()
    
    var imageName2 = ""
    var image2 = UIImage()
    var imageView2 = UIImageView()
    
    var arrowButton1 = UIButton()
    var arrowButton2 = UIButton()
    
    var orderRecognize = [Int]()
    
    var firstDisplay = Bool()
    
    var testCount = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationItem.title = "back"
        
        gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        
        if(afterBreak == true){
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateInDelay:", userInfo: nil, repeats: true)
            delayLabel.text = "Recommended delay: 5 minutes"
        }
        
        print(afterBreak)
        
        let arrowpic = UIImage(named: "arrow") as UIImage?
        
        arrowButton1 = UIButton(type: UIButtonType.Custom) as UIButton
        arrowButton1.frame = CGRectMake(211, 670, 90, 90)
        arrowButton1.setImage(arrowpic, forState: .Normal)
        arrowButton1.addTarget(self, action: "recognize1:", forControlEvents:.TouchUpInside)
        arrowButton1.hidden = true
        self.view.addSubview(arrowButton1)
        
        arrowButton2 = UIButton(type: UIButtonType.Custom) as UIButton
        arrowButton2.frame = CGRectMake(723, 670, 90, 90)
        arrowButton2.setImage(arrowpic, forState: .Normal)
        arrowButton2.addTarget(self, action: "recognize2:", forControlEvents:.TouchUpInside)
        arrowButton2.hidden = true
        self.view.addSubview(arrowButton2)
        
        back.enabled = true
        start.enabled = true
        
        correct.hidden = true
        incorrect.hidden = true
        dk.hidden = true
        next.hidden = true
        
    }
    
    @IBAction func startButton(sender: AnyObject) {
        
        start.enabled = false
        back.enabled = false
        
        let startAlert = UIAlertController(title: "Start", message: "Choose start option", preferredStyle: .Alert)
        
        startAlert.addAction(UIAlertAction(title: "Start New Task", style: .Default, handler: { (action) -> Void in
            print("start new")
            self.startNewTask()
            //action
        }))
        
        if(afterBreak == true){
            startAlert.addAction(UIAlertAction(title: "Resume Task", style: .Default, handler: { (action) -> Void in
                print("resume old")
                self.resumeTask()
                //action
            }))
        }
        
        startAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            print("cancel")
            self.back.enabled = true
            //action
        }))
        
        self.presentViewController(startAlert, animated: true, completion: nil)
        
    }
    
    func startNewTask(){
        
        mixedImages = [String]()
        halfImages = [String]()
        recognizeIncorrect = [String]()
        recallErrors = [Int]()
        recallTimes = [Double]()
        recognizeErrors = [Int]()
        recognizeTimes = [Double]()
        orderRecognize = [Int]()
        testCount = 0
        resultLabel.text = ""
        timerLabel.text = ""
        delayLabel.text = ""
        
        chooseImageSet()
        
        firstDisplay = true
        
        let newStartAlert = UIAlertController(title: "Display", message: "Name and try to remember these images", preferredStyle: .Alert)
        newStartAlert.addAction(UIAlertAction(title: "Start", style: .Default, handler: { (action) -> Void in
            print("start")
            self.displayRecursively(0)
            //action
        }))
        self.presentViewController(newStartAlert, animated: true, completion: nil)
    }
    
    func displayRecursively(num : Int){
        
        if(num < mixedImages.count){
            self.outputImage(mixedImages[num])
            delay(2.0){
                self.displayRecursively(num+1)
            }
        }
        else{
            if(firstDisplay == false){
                beginDelay()
            }
            else{
                
                imageView.removeFromSuperview()
                
                firstDisplay = false
                
                let nextAlert = UIAlertController(title: "Display", message: "Name and try to remember these images again", preferredStyle: .Alert)
                nextAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
                        print("continuing")
                        self.displayRecursively(0)
                        //action
                    }))
                presentViewController(nextAlert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func beginDelay(){
        imageView.removeFromSuperview()
        print("in delay...")
        
        delayLabel.text = "Recommended delay: 5 minutes"
        
        afterBreak = true
        
        back.enabled = true
        start.enabled = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateInDelay:", userInfo: nil, repeats: true)
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    func updateInDelay(timer: NSTimer) {
        
        let currTime = NSDate.timeIntervalSinceReferenceDate()
        var diff: NSTimeInterval = currTime - startTime
        
        let minutes = UInt8(diff / 60.0)
        
        diff -= (NSTimeInterval(minutes)*60.0)
        
        let seconds = UInt8(diff)
        
        diff = NSTimeInterval(seconds)
        
        let strMinutes = minutes > 9 ? String(minutes):"0"+String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0"+String(seconds)
        
        timerLabel.text = "\(strMinutes) : \(strSeconds)"
        
    }
    
    /*
    func updateInRecall(timer: NSTimer) {
        
    }
*/
    
    func outputImage(name: String) {
        
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
        
        imageView = UIImageView(frame:CGRectMake((512.0-(x/2)), (471.0-(y/2)), x, y))
        
        imageView.image = image
        
        imageView.userInteractionEnabled = false
        
        self.view.addSubview(imageView)
        
    }
    
    func outputRecognizeImages(name1: String, name2: String){
        
        imageView1.removeFromSuperview()
        imageView2.removeFromSuperview()
        
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
        
        imageView1 = UIImageView(frame: CGRectMake((256.0-(x1/2)), (471.0-(y1/2)), x1, y1))
        imageView2 = UIImageView(frame: CGRectMake((768.0-(x2/2)), (471.0-(y2/2)), x2, y2))
        
        imageView1.image = image1
        imageView2.image = image2
        
        self.view.addSubview(imageView1)
        self.view.addSubview(imageView2)
        
    }
    
    func chooseImageSet(){
        imageSet = 0
        mixedImages = mixed1
        halfImages = half1
        recognizeIncorrect = incorrect1
    }
    
    
    func resumeTask(){
        timer.invalidate()
        timerLabel.text = ""
        delayLabel.text = ""
        
        let recallAlert = UIAlertController(title: "Recall", message: "Which item is missing from the picture?", preferredStyle: .Alert)
        recallAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
            print("recalling...")
            self.recall()
            //action
        }))
        self.presentViewController(recallAlert, animated: true, completion: nil)
        
        
    }
    
    func recall(){
        
        correct.hidden = false
        incorrect.hidden = false
        dk.hidden = false
        
        testCount = 0
        
        outputImage(halfImages[testCount])
        
        //timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateInRecall:", userInfo: nil, repeats: true)
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    @IBAction func correctButton(sender: AnyObject) {
        
        correct.enabled = false
        incorrect.enabled = false
        dk.enabled = false
        
        recallErrors.append(0)
        recallTimes.append(findTime())
        
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
    }
    
    @IBAction func incorrectButton(sender: AnyObject) {
        
        correct.enabled = false
        incorrect.enabled = false
        dk.enabled = false
        
        recallErrors.append(1)
        recallTimes.append(findTime())
        
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
    }
    
    @IBAction func dkButton(sender: AnyObject) {
        
        correct.enabled = false
        incorrect.enabled = false
        dk.enabled = false
        
        recallErrors.append(2)
        recallTimes.append(findTime())
        
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
    }
    
    func findTime()->Double{
        
        let currTime = NSDate.timeIntervalSinceReferenceDate()
        var diff: NSTimeInterval = currTime - startTime
        let minutes = UInt8(diff / 60.0)
        diff -= (NSTimeInterval(minutes)*60.0)
        let seconds = Double(Int(diff*1000))/1000.0
        return seconds
        
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        
        let img = gesture.view!
        img.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: 471.0)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if img.center.x < 200 {
                
                testCount += 1
                if(testCount == halfImages.count){
                    
                    imageView.removeFromSuperview()
                    correct.hidden = true
                    incorrect.hidden = true
                    dk.hidden = true
                    
                    let recognizeAlert = UIAlertController(title: "Recognize", message: "Which picture have you previously seen?", preferredStyle: .Alert)
                    recognizeAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
                        print("recognizing...")
                        self.recognize()
                        //action
                    }))
                    self.presentViewController(recognizeAlert, animated: true, completion: nil)
                    
                }
                    
                else{
                    
                    print("next pic!")
                    img.center = CGPoint(x: 512.0, y: 471.0)
                    
                    outputImage(halfImages[testCount])
                    
                    correct.enabled = true
                    incorrect.enabled = true
                    dk.enabled = true
                    
                    startTime = NSDate.timeIntervalSinceReferenceDate()
                    
                }
                
            }
                
            else{
                
                print("back to center!")
                img.center = CGPoint(x: 512.0, y: 471.0)
                
            }
            
        }
        
    }
    
    func recognize(){
        
        print("IN RECOGNIZE!!!")
        
        testCount = 0
        
        randomizeRecognize()
        
        if(orderRecognize[testCount] == 0) {
            outputRecognizeImages(mixedImages[testCount], name2: recognizeIncorrect[testCount])
        }
        else{
            outputRecognizeImages(recognizeIncorrect[testCount], name2: mixedImages[testCount])
        }
        
        arrowButton1.hidden = false
        arrowButton1.enabled = true
        
        arrowButton2.hidden = false
        arrowButton2.enabled = true
        
        next.hidden = false
        next.enabled = false
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    func randomizeRecognize(){
        
        //if 0, correct image on left; if 1, correct on right
        
        for(var k = 0; k < 4; k++){
            orderRecognize.append(Int(arc4random_uniform(2)))
        }
        
    }
    
    @IBAction func recognize1(sender: AnyObject){
        
        arrowButton1.enabled = false
        arrowButton2.enabled = false
        next.enabled = true
        
        if(orderRecognize[testCount] == 0){
            recognizeErrors.append(0)
            recognizeTimes.append(findTime())
        }
        else{
            recognizeErrors.append(1)
            recognizeTimes.append(findTime())
        }
        
    }
    
    @IBAction func recognize2(sender: AnyObject){
        
        arrowButton1.enabled = false
        arrowButton2.enabled = false
        next.enabled = true
        
        if(orderRecognize[testCount] == 0){
            recognizeErrors.append(1)
            recognizeTimes.append(findTime())
        }
        else{
            recognizeErrors.append(0)
            recognizeTimes.append(findTime())
        }
        
    }
    
    @IBAction func recognizeNext(sender: AnyObject) {
        
        testCount += 1
        
        if(testCount == mixedImages.count){
            
            arrowButton1.hidden = true
            arrowButton2.hidden = true
            next.hidden = true
            
            imageView1.removeFromSuperview()
            imageView2.removeFromSuperview()
            
            done()
            
        }
        
        else{
            
            next.enabled = false
            arrowButton1.enabled = true
            arrowButton2.enabled = true
            
            if(orderRecognize[testCount] == 0) {
                outputRecognizeImages(mixedImages[testCount], name2: recognizeIncorrect[testCount])
            }
            else{
                outputRecognizeImages(recognizeIncorrect[testCount], name2: mixedImages[testCount])
            }
            
        }
        
    }
    
    func done(){
        back.enabled = true
        start.enabled = true
        
        afterBreak = false
        
        var recallResult = ""
        var recognizeResult = ""
        
        for(var k = 0; k < mixedImages.count; k++){
            
            if(recallErrors[k] == 0){
                recallResult += "Recalled \(mixedImages[k]) correctly in \(recallTimes[k]) seconds\n"
            }
            if(recallErrors[k] == 1){
                recallResult += "Recalled \(mixedImages[k]) incorrectly in \(recallTimes[k]) seconds\n"
            }
            if(recallErrors[k] == 2){
                recallResult += "Couldn't recall \(mixedImages[k]) in \(recallTimes[k]) seconds\n"
            }
            
            
            if(recognizeErrors[k] == 0){
                recognizeResult += "Recognized \(mixedImages[k]) correctly in \(recognizeTimes[k]) seconds\n"
            }
            if(recognizeErrors[k] == 1){
                recognizeResult += "Recognized \(mixedImages[k]) incorrectly in \(recognizeTimes[k]) seconds\n"
            }
            
        }
        
        resultLabel.text = recallResult + recognizeResult
        
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    
}