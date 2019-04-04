//
//  Demographics.swift
//  iBOCA
//
//  Created by Ellison Lim on 8/29/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation


var testStartTime = Foundation.Date()

var age : String?
var Gender : String?
var Education : String?
var Race : String?
var Ethnicity : String?
var Results1: [String] = []
var Comments : String = ""
var PUID: String = ""
var ModeECT = false
var Protocol = "A"



func makeAgeData() -> [String] {
    var str:[String] = []
    for i in 10...120 {
        str.append(String(i))
    }
    return str
}

class Demographics: ViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate,UIPickerViewDelegate {
    
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var btnAge: UIButton!
    @IBOutlet weak var btnEducation: UIButton!
    @IBOutlet weak var btnEthinicity: UIButton!
    @IBOutlet weak var btnRace: UIButton!
    @IBOutlet weak var btnProcotol: UIButton!
    
    
    @IBOutlet weak var GenderPicker: UIPickerView!
    let genderData = ["Male", "Female", "Other", "Prefer Not To Say"]
    
    
    @IBOutlet weak var EducationPicker: UIPickerView!
    let educationData = ["0 years", "1 years","2 years","3 years","4 years","5 years","6 years","7 years","8 years","9 years","10 years","11 years","12 years(High School)","13 years","14 years","15 years","16 years(College)","17 years","18 years","19 years", "20 years", "20+ years"]
    
    
    @IBOutlet weak var EthnicityPicker: UIPickerView!
    var ethnicData = ["Hispanic or Latino", "Not Hispanic or Latino"]
    
    @IBOutlet weak var RacePicker: UIPickerView!
    var raceData = ["White", "Black or African American", "Asian", "Native Hawaiian or Other Pacific Islander", "American Indian or Alaskan Native", "Multi-Racial", "Unknown", "Add more",]
    
    @IBOutlet weak var AgePicker: UIPickerView!
    var ageData:[String] = makeAgeData()
    
    @IBOutlet weak var MRLabel: UILabel!
    @IBOutlet weak var MRField: UITextField!
    
    @IBOutlet weak var CommentEntry: UITextView!
    
    @IBAction func updateMR(_ sender: AnyObject) {
        _ = PID.changeID(proposed: MRField.text!)
        MRField.text = PID.getID()
    }

    @IBOutlet weak var PatientUID: UITextField!
    
    @IBAction func updatePUID(_ sender: UITextField) {
        PUID = sender.text!
    }
    
    @IBOutlet weak var protocolLabel: UILabel!
    @IBOutlet weak var ProtocolPicker: UIPickerView!
    var protocolData = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    @IBAction func NextPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func GenderPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.datasource = genderData
        vc.modalPresentationStyle = .overCurrentContext
        vc.didSelect = ({ value, index in
            self.GenderPicker.selectRow(index, inComponent: 0, animated: false)
        })
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func AgePressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.datasource = ageData
        vc.modalPresentationStyle = .overCurrentContext
        vc.didSelect = ({ value, index in
            self.AgePicker.selectRow(index, inComponent: 0, animated: false)
        })
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func EducationPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.datasource = educationData
        vc.modalPresentationStyle = .overCurrentContext
        vc.didSelect = ({ value, index in
            self.EducationPicker.selectRow(index, inComponent: 0, animated: false)
        })
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func EthinicityPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.datasource = ethnicData
        vc.modalPresentationStyle = .overCurrentContext
        vc.didSelect = ({ value, index in
            self.EthnicityPicker.selectRow(index, inComponent: 0, animated: false)
        })
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func RacePressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.datasource = raceData
        vc.modalPresentationStyle = .overCurrentContext
        vc.didSelect = ({ value, index in
            self.RacePicker.selectRow(index, inComponent: 0, animated: false)
        })
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ProtocolPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.datasource = protocolData
        vc.modalPresentationStyle = .overCurrentContext
        vc.didSelect = ({ value, index in
            self.ProtocolPicker.selectRow(index, inComponent: 0, animated: false)
        })
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func CancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    @IBOutlet weak var done: UIButton!
    
    @IBAction func done(_ sender: Any) {
    
        let alert = UIAlertController(title: "Continue", message: "Done with information?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action) -> Void in
        }))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
            let main = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
            self.present(main, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    } */
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AgePicker.delegate = self
        GenderPicker.delegate = self
        EthnicityPicker.delegate = self
        EducationPicker.delegate = self
        RacePicker.delegate = self
        ProtocolPicker.delegate = self
        
        AgePicker.selectRow(40, inComponent: 0, animated: false)
        age = ageData[AgePicker.selectedRow(inComponent: 0)]
        
        Gender = genderData[GenderPicker.selectedRow(inComponent: 0)]
        
        Ethnicity = ethnicData[EthnicityPicker.selectedRow(inComponent: 0)]
        
        EducationPicker.selectRow(12, inComponent: 0, animated: false)
        Education = educationData[EducationPicker.selectedRow(inComponent: 0)]
        
        Race = raceData[RacePicker.selectedRow(inComponent: 0)]
        
        MRField.text = PID.getID()
        
        CommentEntry.text = ""
        CommentEntry.layer.borderWidth = 1
        CommentEntry.layer.borderColor = UIColor.lightGray.cgColor
        Comments = ""
         
        testStartTime = Foundation.Date()
        
        PUID = ""
        if atBIDMCOn == true && theTestClass == 2 {
            ModeECT = true
        } else {
            ModeECT = false
        }
        
        Protocol = protocolData[ProtocolPicker.selectedRow(inComponent: 0)]
        if(ModeECT) {
            protocolLabel.isHidden = false
            ProtocolPicker.isHidden = false
            btnProcotol.isHidden = false
        } else {
            protocolLabel.isHidden = true
            ProtocolPicker.isHidden = true
            btnProcotol.isHidden = true
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    //pickerview setup
    func numberOfComponentsInPickerView(_ pickerView : UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == AgePicker {
            return ageData.count
        } else if pickerView == GenderPicker {
            return genderData.count
        } else if pickerView == EthnicityPicker {
            return ethnicData.count
        } else if pickerView == EducationPicker {
            return educationData.count
        } else if pickerView == RacePicker {
            return raceData.count
        } else if pickerView == ProtocolPicker {
            return protocolData.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == AgePicker {
            age = ageData[row]
            return ageData[row]
        } else if pickerView == GenderPicker {
            Gender = genderData[row]
            return genderData[row]
        } else if pickerView == EthnicityPicker {
            Ethnicity = ethnicData[row]
            return ethnicData[row]
        } else if pickerView == EducationPicker {
            Education = educationData[row]
            return educationData[row]
        } else if pickerView == RacePicker {
            Race = raceData[row]
            return raceData[row]
        } else if pickerView == ProtocolPicker {
            Protocol = protocolData[row]
            return protocolData[row]
        }
       return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == AgePicker {
            age = ageData[row]
        } else if pickerView == GenderPicker {
            Gender = genderData[row]
        } else if pickerView == EthnicityPicker {
            Ethnicity = ethnicData[row]
            if Ethnicity == "Other", let iEthnicity = Ethnicity {
                addOtherCondition(pickerView, strCondition: iEthnicity)
            }
        } else if pickerView == EducationPicker {
           Education = educationData[row]
        } else if pickerView == RacePicker {
            Race = raceData[row]
            if Race == "Add more", let iRace = Race {
                addOtherCondition(pickerView, strCondition: iRace)
            }
        } else if pickerView == ProtocolPicker {
            Protocol = protocolData[row]
        }
    }
    
    func addOtherCondition(_ pickerView:UIPickerView, strCondition: String){
        let alert = UIAlertController(title: strCondition, message: "Enter \(strCondition.lowercased()) ", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
            
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            //self.resultComments[self.count-startCount] = textField.text!
            
            if let result = textField.text, !result.isEmpty {
                //do something if it's not empty
                var cnt : Int = 0
                if pickerView == self.EthnicityPicker {
                    self.ethnicData.append(result)
                    cnt = self.ethnicData.count
                    Ethnicity = result
                } else if pickerView == self.RacePicker {
                    self.raceData.append(result)
                    cnt = self.raceData.count
                    Race = result
                }
                pickerView.reloadAllComponents()
                pickerView.selectRow(cnt-1, inComponent: 0, animated: true)
            }
            else {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        Comments = CommentEntry.text
    }

    @IBAction func TestDone(_ sender: AnyObject) {
    Results1.append(PID.getID())
    Results1.append(Gender!)
    Results1.append(Ethnicity!)
    Results1.append(Education!)
    Results1.append(age!)
    Results1.append(Race!)
    print(Results1)
    }
}


extension Demographics {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > textField.text!.count {
            return false
        }
        
        if string.isEmpty {
            return true
        }
        return Int(string) != nil
    }
}
