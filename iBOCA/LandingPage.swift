//
//  LandingPage.swift
//  iBOCA
//
//  Created by saman on 6/27/17.
//  Copyright © 2017 sunspot. All rights reserved.
//

import Foundation
import UIKit

let TestOrientation = 1
let TestSimpleMemory = 2
let TestVisualAssociation = 3
let TestTrails = 4
let TestForwardDigitSpan = 5
let TestBackwardsDigitSpan = 6
let TestCatsAndDogs = 7
let Test3DFigureCopy = 8
let TestSerialSevens = 9
let TestForwardSpatialSpan = 10
let TestBackwardSpatialSpan = 11
let TestNampingPictures = 12
let TestSemanticListGeneration = 13
let TestMOCAResults = 14
let TestGDTResults = 15
let TestGoldStandard = 16
let TestSpeechToText = 17


enum TestStatus {
    case NotStarted, Running, Done
}

var Status  = [TestStatus](repeating: TestStatus.NotStarted, count: 20)

var doneSetup = false

// Patient ID use through app
let PID = PatientID()

class LandingPage: BaseViewController {
    
    @IBOutlet weak var GotoTests: UIButton!
    
    @IBOutlet weak var mBtnSelfAdmin: GradientButton!
    
    @IBOutlet weak var mBtnProctored: UIButton!
    
    @IBOutlet weak var mAcknowled: UIButton!
    
    
    @IBAction func GotoTests(_ sender: UIButton) {
        if Settings.isGotoTest == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
            presentViewController(viewController: vc, animated: true, completion: nil)
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Demographics")
            presentViewController(viewController: nextViewController, animated:true, completion:nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        
        Status[TestOrientation] = TestStatus.NotStarted
        Status[TestSimpleMemory] = TestStatus.NotStarted
        Status[TestVisualAssociation] = TestStatus.NotStarted
        Status[TestTrails] = TestStatus.NotStarted
        Status[TestForwardDigitSpan] = TestStatus.NotStarted
        Status[TestBackwardsDigitSpan] = TestStatus.NotStarted
        Status[TestCatsAndDogs] = TestStatus.NotStarted
        Status[Test3DFigureCopy] = TestStatus.NotStarted
        Status[TestSerialSevens] = TestStatus.NotStarted
        Status[TestForwardSpatialSpan] = TestStatus.NotStarted
        Status[TestBackwardSpatialSpan] = TestStatus.NotStarted
        Status[TestNampingPictures] = TestStatus.NotStarted
        Status[TestSemanticListGeneration] = TestStatus.NotStarted
        Status[TestMOCAResults] = TestStatus.NotStarted
        Status[TestGDTResults] = TestStatus.NotStarted
        Status[TestGoldStandard] = TestStatus.NotStarted
        
        if Settings.patientID != nil {
            GotoTests.isEnabled = true
        } else {
            GotoTests.isEnabled = false
        }
        
        setupUI()
        
        setupPIDFirstTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - NEW UI
    func setupUI(){
        //self administered button
        
        mBtnSelfAdmin.setTitle(title: "SELF ADMINISTERED", withFont: Font.font(name: Font.Montserrat.bold, size: 22))
        mBtnSelfAdmin.setupShadow(withColor: .clear, sketchBlur: 0, opacity: 0)
        mBtnSelfAdmin.setupGradient(arrColor: [Color.color(hexString: "FFDC6E"),Color.color(hexString: "FFC556")], direction: .topToBottom)
        mBtnSelfAdmin.render()
        mBtnSelfAdmin.addTextSpacing(-0.44)
        mBtnSelfAdmin.layer.cornerRadius = 8
        mBtnSelfAdmin.layer.masksToBounds = true
        //proctored button
        mBtnProctored.setTitle("PROCTORED", for: .normal)
        mBtnProctored.setBackgroundColor(Color.color(hexString: "EEF3F9"), forState: .normal)
        mBtnProctored.titleLabel?.font = Font.font(name: Font.Montserrat.bold, size: 22)
        mBtnProctored.setTitleColor(Color.color(hexString: "013AA5"), for: .normal)
        mBtnProctored.layer.cornerRadius = 8
        mBtnProctored.layer.masksToBounds = true
        //
        mAcknowled.setTitle("ACKNOWLEDGEMENTS", for: .normal)
        mAcknowled.setBackgroundColor(Color.color(hexString: "EEF3F9"), forState: .normal)
        mAcknowled.titleLabel?.font = Font.font(name: Font.Montserrat.bold, size: 22)
        mAcknowled.setTitleColor(Color.color(hexString: "013AA5"), for: .normal)
        mAcknowled.layer.cornerRadius = 8
        mAcknowled.layer.masksToBounds = true
    }
    
    @IBAction func tapSelfAdmin(_ sender: Any) {
        performSegue(withIdentifier: "tap-administered", sender: nil)
    }
    
    @IBAction func tapProctored(_ sender: Any) {
        //tap-proctored
        performSegue(withIdentifier: "tap-proctored", sender: nil)
    }
    
    @IBAction func tapAcknowled(_ sender: Any) {
        //tap-acknowled
        performSegue(withIdentifier: "tap-acknowled", sender: nil)
    }
    
    //MARK: - Logic Method
    func setupPIDFirstTime(){
        // Get Current Date time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let auto_id = Int("\(hour)\(minutes)")!
        PID.currNum = auto_id
        debugPrint("generated PID \(PID.getID())")
    }
    
}
