//
//  AdministeredViewController.swift
//  iBOCA
//
//  Created by MinhLuan on 6/28/19.
//  Copyright © 2019 sunspot. All rights reserved.
//

import UIKit

var adminTransmitOn : Bool = false
class AdministeredViewController: BaseViewController {

    
    @IBOutlet weak var mTitleBack: UILabel!
    
    @IBOutlet weak var mTextInputEmail: UILabel!
    
    @IBOutlet weak var mTfMail: UITextField!
    
    @IBOutlet weak var mSwitch: UISwitch!
    
    @IBOutlet weak var mTextEnableConsent: UILabel!
    
    @IBOutlet weak var mBtnSelectTest: UIButton!
    
    @IBOutlet weak var mBtnQuickStart: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI(){
        //
        mTitleBack.text = mTitleBack.text?.uppercased()
        mTitleBack.font = Font.font(name: Font.Montserrat.semiBold, size: 28)
        mTitleBack.textColor = Color.color(hexString: "013AA5")
        //
        mTextInputEmail.font = Font.font(name: Font.Montserrat.medium, size: 16)
        mTextInputEmail.textColor = Color.color(hexString: "8A9199")
        //
        mTfMail.font = Font.font(name: Font.Montserrat.medium, size: 18)
        mTfMail.backgroundColor = Color.color(hexString: "F7F7F7")
        mTfMail.textColor = UIColor.black
        mTfMail.layer.borderColor = Color.color(hexString: "649BFF").cgColor
        mTfMail.layer.borderWidth = 1
        mTfMail.layer.cornerRadius = 5
        mTfMail.layer.masksToBounds = true
        mTfMail.delegate = self
        if let email = Settings.resultsEmailAddressByAdmin {
            mTfMail.text = email
        }
        //
        mTextEnableConsent.font = Font.font(name: Font.Montserrat.medium, size: 18)
        mTextEnableConsent.textColor = UIColor.black
        //
        mSwitch.onTintColor = Color.color(hexString: "69C394")
        mSwitch.isOn = UserDefaults.standard.bool(forKey: "AdminTransmit")
        adminTransmitOn = mSwitch.isOn
        //
        mBtnSelectTest.layer.cornerRadius = 8
        mBtnSelectTest.layer.masksToBounds = true
        mBtnSelectTest.setBackgroundColor(Color.color(hexString: "EEF3F9"), forState: .normal)
        mBtnSelectTest.titleLabel?.font = Font.font(name: Font.Montserrat.bold, size: 22)
        mBtnSelectTest.setTitleColor(Color.color(hexString: "013AA5"), for: .normal)
        //
        mBtnQuickStart.layer.cornerRadius = 8
        mBtnQuickStart.layer.masksToBounds = true
        mBtnQuickStart.setBackgroundColor(Color.color(hexString: "EEF3F9"), forState: .normal)
        mBtnQuickStart.titleLabel?.font = Font.font(name: Font.Montserrat.bold, size: 22)
        mBtnQuickStart.setTitleColor(Color.color(hexString: "013AA5"), for: .normal)
    }
    
    fileprivate func validate() -> Bool {
        if !mTfMail.text!.isEmpty {
            if !mTfMail.text!.isValidEmail() {
                self.showPopup(ErrorMessage.errorTitle, message: "Email is invalid", okAction: {})
                return false
            } else {
                // UserDefaults.standard.set(emailTextField.text, forKey:"emailAddress")
                Settings.resultsEmailAddressByAdmin = mTfMail.text
                return true
            }
        } else {
            Settings.resultsEmailAddressByAdmin = nil
        }
        
        return true
    }
    
    @IBAction func switchChange(_ sender: Any) {
        if mSwitch.isOn == true{
            showAlertTurnOnConsent()
        } else {
            UserDefaults.standard.set(self.mSwitch.isOn, forKey: "AdminTransmit")
            UserDefaults.standard.synchronize()
            adminTransmitOn = self.mSwitch.isOn
        }
    }
    
    @IBAction func tapSelectTest(_ sender: Any) {
        if validate() {
            if mSwitch.isOn == true {
                // Consent to provide data
                self.goToDemoGraphics()
            }
            else {
                self.goToSelectTest()
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true) {
            // Clear all resultsArray with mode QuickStart
            resultsArray.results.removeAllObjects()
        }
    }
    
    @IBAction func tapQuickStart(_ sender: Any) {
        if validate() {
            if mSwitch.isOn == true {
                // Consent to provide data
                self.goToDemoGraphics()
            }
            else {
                savePID()
                
                let manager = QuickStartManager.init(controller: self)
                manager.start()
            }
        }
    }
    
    
    private func showAlertTurnOnConsent(){
//        CustomAlertView.showAlert(withTitle: "Conset Request", andTextContent: "Please confirm your consent to\nprovide test data", andItems:
//        [.cre(title: "Cancel", itag: 0, istyle: .cancel),                                                                                                                      .cre(title: "Approve", itag: 1, istyle: .normal)], inView: self.view) {[weak self](alert, title, itag) in
//            if itag == 0 || itag == -1{
//                //-1 is this when user tap close button
//                self?.mSwitch.isOn = false
//            }
//            alert.dismiss()
//        }
        let alert = UIAlertController.init(title: "Conset Request", message: "Please confirm your consent to\nprovide test data", preferredStyle: .alert)
        alert.addAction(.init(title: "CANCEL", style: .cancel, handler: { (iaction) in
            self.mSwitch.isOn = false
            adminTransmitOn = self.mSwitch.isOn
        }))
        alert.addAction(.init(title: "APPROVE", style: .default, handler: { (iaction) in
            UserDefaults.standard.set(self.mSwitch.isOn, forKey: "AdminTransmit")
            UserDefaults.standard.synchronize()
            adminTransmitOn = self.mSwitch.isOn
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func goToDemoGraphics() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "Demographics") as? Demographics {
            vc.mode = .admin
            presentViewController(viewController: vc, animated:true, completion:nil)
        }
    }

    fileprivate func goToSelectTest() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "main") as? MainViewController {
            savePID()
            vc.mode = .admin
            presentViewController(viewController: vc, animated: true, completion: nil)
        }
    }
}

extension AdministeredViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
