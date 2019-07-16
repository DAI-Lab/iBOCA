//
//  Setup.swift
//  iBOCA
//
//  Created by saman on 6/25/17.
//  Copyright © 2017 sunspot. All rights reserved.
//

import Foundation
import UIKit
import MessageUI



var transmitOn : Bool = false
var atBIDMCOn  : Bool = false
var emailOn    : Bool = false
var emailAddress       : String = ""
var serverEmailAddress : String = "datacollect@bostoncognitive.org"
var theTestClass : Int = 0
let testClassName = ["CNU", "COMM", "ECT", "DW", "PHY", "ICU", "B1", "B2", "B3", "TEST"]
let BIDMCpassKey = "PressOn"

class Setup: ViewController, UIPickerViewDelegate  {
    var autoID: Int = Int()
    
    @IBOutlet weak var atBIDMCOnOff:  UISwitch!
    @IBOutlet weak var emailOnOff:    UISwitch!
    @IBOutlet weak var adminInitials: UILabel!
    @IBOutlet weak var testClass: UIPickerView!
    @IBOutlet weak var testClassLabel: UILabel!
    
    // MARK: Outlet
    @IBOutlet weak var backTitleLabel: UILabel!
    @IBOutlet weak var beginButton: GradientButton!
    
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var adminNameTextField: UITextField!
    
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var patiantIDTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var provideDataSwitch: UISwitch!
    @IBOutlet weak var provideDataLabel: UILabel!
    
    @IBOutlet weak var testingPasscodeLabel: UILabel!
    @IBOutlet weak var testingPasscodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupView()
        
        if let email = UserDefaults.standard.string(forKey: "emailAddress") {
            emailTextField.text = email
        }
        provideDataSwitch.isOn = UserDefaults.standard.bool(forKey: "Transmit")
        patiantIDTextField.text = PID.getID()
        adminNameTextField.text = PID.getName()
        
        
        
        
        atBIDMCOn = UserDefaults.standard.bool(forKey: "AtBIDMC")
        atBIDMCOnOff.isOn = atBIDMCOn
        
//        emailOn = UserDefaults.standard.bool(forKey: "emailOn")
//        emailTextField.isEnabled = emailOn
//        emailLabel.isEnabled = emailOn
//        emailOnOff.isOn = emailOn
        
        testClass.delegate = self
        //        if atBIDMCOn == true {
        //            testClass.isHidden = false
        //            testClassLabel.isHidden = false
        //        } else {
        //            testClass.isHidden = true
        //            testClassLabel.isHidden = true
        //        }
        theTestClass = UserDefaults.standard.integer(forKey: "TheTestClass")
        testClass.selectRow(theTestClass, inComponent: 0, animated: true)
        
        doneSetup = true
    }
    
    private func validate() -> Bool {
        if !emailTextField.text!.isEmpty {
            if !emailTextField.text!.isValidEmail() {
                self.showPopup(ErrorMessage.errorTitle, message: "Email is invalid", okAction: {})
                return false
            } else {
                UserDefaults.standard.set(emailTextField.text, forKey:"emailAddress")
                return true
            }
        }
        
        return true
    }
    
    private func showAlertTurnOnConsent(){
//        CustomAlertView.showAlert(withTitle: "Conset Request", andTextContent: "Please confirm your consent to\nprovide test data", andItems:
//        [.cre(title: "Cancel", itag: 0, istyle: .cancel),                                                                                                                      .cre(title: "Approve", itag: 1, istyle: .normal)], inView: self.view) {[weak self](alert, title, itag) in
//            if itag == 0 || itag == -1{
//                //-1 is this when user tap close button
//                self?.provideDataSwitch.isOn = false
//            } else {
//                UserDefaults.standard.set(self!.provideDataSwitch.isOn, forKey: "Transmit")
//                UserDefaults.standard.synchronize()
//            }
//            alert.dismiss()
//        }
        
        let alert = UIAlertController.init(title: "Conset Request", message: "Please confirm your consent to\nprovide test data", preferredStyle: .alert)
        alert.addAction(.init(title: "CANCEL", style: .cancel, handler: { (iaction) in
            self.provideDataSwitch.isOn = false
        }))
        alert.addAction(.init(title: "APPROVE", style: .default, handler: { (iaction) in
            UserDefaults.standard.set(self.provideDataSwitch.isOn, forKey: "Transmit")
            UserDefaults.standard.synchronize()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Action
    @IBAction func actionBegin(_ sender: Any) {
        if validate() {
            guard let _patiantID = self.patiantIDTextField.text else { return }
            Settings.patiantID = _patiantID
            Settings.isGotoTest = true
            
            if let passcode = testingPasscodeTextField.text {
                if !passcode.isEmpty {
                    UserDefaults.standard.set(BIDMCpassKey, forKey: "BIDMCproceedKey")
                }
            }
            
            if provideDataSwitch.isOn == true {
                // Consent to provide data
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "Demographics") as? Demographics {
                    self.present(vc, animated:true, completion:nil)
                }
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "main") as? MainViewController{
                    vc.mode = .patient
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        if validate() {
            guard let _patiantID = self.patiantIDTextField.text else { return }
            Settings.patiantID = _patiantID
            
            if let passcode = testingPasscodeTextField.text {
                if !passcode.isEmpty {
                    UserDefaults.standard.set(BIDMCpassKey, forKey: "BIDMCproceedKey")
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionProvideData(_ sender: UISwitch) {
        if provideDataSwitch.isOn {
            showAlertTurnOnConsent()
        } else {
            UserDefaults.standard.set(provideDataSwitch.isOn, forKey: "Transmit")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func adminNameChanged(_ sender: UITextField) {
        let curNum = PID.currNum
        PID.nameSet(name: adminNameTextField.text!)
        PID.currNum = curNum
        patiantIDTextField.text = PID.getID()
    }
    
    @IBAction func patiantIDEdited(_ sender: UITextField) {
        if !PID.changeID(proposed: patiantIDTextField.text!) {
            patiantIDTextField.text = PID.getID()
        } else {
            patiantIDTextField.text = PID.getID()
        }
    }
    
    // MARK: Unused code
    @IBAction func atBIDMCOnOff(_ sender: UISwitch) {
        if(atBIDMCOnOff.isOn) { // Trying to use BIDMC content
            if(UserDefaults.standard.object(forKey: "BIDMCproceedKey") == nil) { // See if the person has permission
                // Ask for the key pharse
                let alertController = UIAlertController(title: "Enter passkey", message: "Enter Pass Key to use BIDMC Features", preferredStyle: .alert)
                
                //the confirm action taking the inputs
                let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
                    //getting the input values from user
                    let key = alertController.textFields?[0].text
                    if (key == BIDMCpassKey) { // Got the right key
                        UserDefaults.standard.set(key, forKey: "BIDMCproceedKey")
                        UserDefaults.standard.synchronize()
                        self.setAtBIDMC()
                    } else { // bad key
                        self.atBIDMCOnOff.isOn = false
                    }
                }
                
                //the cancel action, no key
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    self.atBIDMCOnOff.isOn = false
                }
                
                //adding textfields to our dialog box
                alertController.addTextField { (textField) in
                    textField.placeholder = "Enter Pass Key"
                }
                //adding the action to dialogbox
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                //finally presenting the dialog box
                self.present(alertController, animated: true, completion: nil)
            } else { // key exist in the system, should be OK
                setAtBIDMC()
            }
        } else { // trying to set it off, should be OK
            setAtBIDMC()
        }
    }
    
    func setAtBIDMC() {
        atBIDMCOn = atBIDMCOnOff.isOn
        UserDefaults.standard.set(atBIDMCOn, forKey: "AtBIDMC")
        UserDefaults.standard.synchronize()
        patiantIDTextField.text = PID.getID()
        if atBIDMCOn == true {
            testClass.isHidden = false
            testClassLabel.isHidden = false
        } else {
            testClass.isHidden = true
            testClassLabel.isHidden = true
        }
    }
    
    @IBAction func emailOnOff(_ sender: Any) {
        emailOn = emailOnOff.isOn
//        emailTextField.isEnabled = emailOn
        emailLabel.isEnabled = emailOn
        UserDefaults.standard.set(emailOn, forKey: "emailOn")
        UserDefaults.standard.synchronize()
    }
    
    func numberOfComponentsInPickerView(_ pickerView : UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == testClass {
            return testClassName.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == testClass {
            return testClassName[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == testClass {
            theTestClass = row
            UserDefaults.standard.set(row, forKey:"TheTestClass")
        } else  {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Setup {
    fileprivate func setupView() {
        // Label Back
        self.backTitleLabel.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.backTitleLabel.textColor = Color.color(hexString: "#013AA5")
        self.backTitleLabel.addTextSpacing(-0.56)
        self.backTitleLabel.text = "PROCTORED"
        
        // Button Start New
        self.beginButton.setTitle(title: "BEGIN", withFont: Font.font(name: Font.Montserrat.bold, size: 22.0))
        self.beginButton.setupShadow(withColor: .clear, sketchBlur: 0, opacity: 0)
        self.beginButton.setupGradient(arrColor: [Color.color(hexString: "#FFDC6E"),Color.color(hexString: "#FFC556")], direction: .topToBottom)
        self.beginButton.addTextSpacing(-0.36)
        self.beginButton.render()
        
        self.adminNameLabel.font = Font.font(name: Font.Montserrat.medium, size: 16.0)
        self.adminNameLabel.textColor = Color.color(hexString: "#8A9199")
        self.adminNameLabel.addTextSpacing(-0.36)
        
        self.adminNameTextField.layer.borderWidth = 1
        self.adminNameTextField.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        self.adminNameTextField.layer.cornerRadius = 5
        self.adminNameTextField.layer.masksToBounds = true
        
        self.patientIdLabel.font = Font.font(name: Font.Montserrat.medium, size: 16.0)
        self.patientIdLabel.textColor = Color.color(hexString: "#8A9199")
        self.patientIdLabel.addTextSpacing(-0.36)
        
        self.patiantIDTextField.layer.borderWidth = 1
        self.patiantIDTextField.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        self.patiantIDTextField.layer.cornerRadius = 5
        self.patiantIDTextField.layer.masksToBounds = true
        
        self.emailLabel.font = Font.font(name: Font.Montserrat.medium, size: 16.0)
        self.emailLabel.textColor = Color.color(hexString: "#8A9199")
        self.emailLabel.addTextSpacing(-0.36)
        
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        self.emailTextField.layer.cornerRadius = 5
        self.emailTextField.layer.masksToBounds = true
        
        self.provideDataLabel.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.provideDataLabel.textColor = Color.color(hexString: "#000000")
        self.provideDataLabel.addTextSpacing(-0.36)
        
        self.testingPasscodeLabel.font = Font.font(name: Font.Montserrat.medium, size: 16.0)
        self.testingPasscodeLabel.textColor = Color.color(hexString: "#8A9199")
        self.testingPasscodeLabel.addTextSpacing(-0.36)
        
        self.testingPasscodeTextField.layer.borderWidth = 1
        self.testingPasscodeTextField.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        self.testingPasscodeTextField.layer.cornerRadius = 5
        self.testingPasscodeTextField.layer.masksToBounds = true
    }
}

extension Setup: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
