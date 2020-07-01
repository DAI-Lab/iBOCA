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

var proctoredTransmitOn : Bool = false
var atBIDMCOn  : Bool = false
var emailOn    : Bool = false
var emailAddress       : String = ""
var serverEmailAddress : String = "datacollect@bostoncognitive.org"
var theTestClass : Int = 0
let testClassName = ["CNU", "COMM", "ECT", "DW", "PHY", "ICU", "B1", "B2", "B3", "TEST"]
let BIDMCpassKey = "PressOn"

class Setup: BaseViewController  {
    var autoID: Int = Int()
    
    // MARK: Outlet
    @IBOutlet weak var backTitleLabel: UILabel!
    @IBOutlet weak var beginButton: GradientButton!
    
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var adminNameTextField: UITextField!
    
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var patientIDTextField: UITextField!
    
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
        
        if let email = Settings.resultsEmailAddressByProctored { //UserDefaults.standard.string(forKey: "emailAddress")
            emailTextField.text = email
        }
        provideDataSwitch.isOn = UserDefaults.standard.bool(forKey: "Transmit")
        proctoredTransmitOn = provideDataSwitch.isOn
        patientIDTextField.text = PID.getID()
        adminNameTextField.text = PID.getName()
        
        doneSetup = true
    }
    
    fileprivate func validate() -> Bool {
        if !emailTextField.text!.isEmpty {
            if !emailTextField.text!.isValidEmail() {
                self.showPopup(ErrorMessage.errorTitle, message: "Email is invalid", okAction: {})
                return false
            } else {
                // UserDefaults.standard.set(emailTextField.text, forKey:"emailAddress")
                Settings.resultsEmailAddressByProctored = emailTextField.text
                return true
            }
        } else {
            Settings.resultsEmailAddressByProctored = nil
        }
        
        return true
    }
    
    fileprivate func showAlertTurnOnConsent(){
        let alert = UIAlertController.init(title: "Conset Request", message: "Please confirm your consent to\nprovide test data", preferredStyle: .alert)
        alert.addAction(.init(title: "CANCEL", style: .cancel, handler: { (iaction) in
            self.provideDataSwitch.isOn = false
            proctoredTransmitOn = self.provideDataSwitch.isOn
        }))
        alert.addAction(.init(title: "APPROVE", style: .default, handler: { (iaction) in
            UserDefaults.standard.set(self.provideDataSwitch.isOn, forKey: "Transmit")
            UserDefaults.standard.synchronize()
            proctoredTransmitOn = self.provideDataSwitch.isOn
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Action
extension Setup {
    @IBAction func actionBegin(_ sender: Any) {
        if validate() {
            guard let _patientID = self.patientIDTextField.text else { return }
            Settings.patientID = _patientID
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
                    vc.mode = .patient
                    presentViewController(viewController: vc, animated:true, completion:nil)
                }
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "main") as? MainViewController{
                    vc.mode = .patient
                    presentViewController(viewController: vc, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        if validate() {
            guard let _patientID = self.patientIDTextField.text else { return }
            Settings.patientID = _patientID
            
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
            proctoredTransmitOn = self.provideDataSwitch.isOn
        }
    }
    
    @IBAction func adminNameChanged(_ sender: UITextField) {
        let curNum = PID.currNum
        PID.nameSet(name: adminNameTextField.text!)
        PID.currNum = curNum
        patientIDTextField.text = PID.getID()
    }
    
    @IBAction func patientIDEdited(_ sender: UITextField) {
        if !PID.changeID(proposed: patientIDTextField.text!) {
            patientIDTextField.text = PID.getID()
        } else {
            patientIDTextField.text = PID.getID()
        }
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
        
        self.patientIDTextField.layer.borderWidth = 1
        self.patientIDTextField.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        self.patientIDTextField.layer.cornerRadius = 5
        self.patientIDTextField.layer.masksToBounds = true
        
        self.emailLabel.font = Font.font(name: Font.Montserrat.medium, size: 16.0)
        self.emailLabel.textColor = Color.color(hexString: "#8A9199")
        self.emailLabel.addTextSpacing(-0.36)
        
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        self.emailTextField.layer.cornerRadius = 5
        self.emailTextField.layer.masksToBounds = true
        self.emailTextField.delegate = self
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
