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

enum DemographicsCategory: String {
    case Race = "Race"
    case Ethnicity = "Ethnicity"
}

class Demographics: BaseViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var vTaskShadow: UIView!
    @IBOutlet weak var vTask: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var mode: TestMode = .admin
    
    // MARK: - Variable
    let genderData = ["Male", "Female", "Other", "Prefer Not To Say"]
    
    let educationData = ["0 years", "1 years","2 years","3 years","4 years","5 years","6 years","7 years","8 years","9 years","10 years","11 years","12 years(High School)","13 years","14 years","15 years","16 years(College)","17 years","18 years","19 years", "20 years", "20+ years"]
    
    var ethnicData = ["Hispanic or Latino", "Not Hispanic or Latino"]
    
    var raceData = ["White", "Black or African American", "Asian", "Native Hawaiian or Other Pacific Islander", "American Indian or Alaskan Native", "Multi-Racial", "Unknown", "Add more",]
    
    var ageData:[String] = makeAgeData()
    
    var arrDemoGraphicsStyle: [DemoGraphicsCellStyle] = [.PaientIDNumber,
                                                    .Ethnicity,
                                                    .Gender,
                                                    .Race,
                                                    .Age,
                                                    .PatientUID,
                                                    .Education,
                                                    .Protocols]
    
    // Object Load Data
    struct Objects {
        var title: DemoGraphicsCellStyle!
        var value: String!
    }
    
    var objectArray = [Objects]()
    
    var tapOusideGesture = UITapGestureRecognizer()
    var tapGestureHideDropDown = UITapGestureRecognizer()
    
    var dropDown: UITableView = UITableView()
    var dropDownData: [String] = [String]()
    var selectedStyle: DemoGraphicsCellStyle?
    var txtSelected: String?
    
    var protocolData = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    // MARK: - Load Views
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup First Data
        self.setupFirstData()
        
        // TODO: Check mode ModeECT show/ hide protocol
        self.setupView()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Setup View
extension Demographics {
    fileprivate func setupView() {
        // View Back
        self.lblBack.addTextSpacing(-0.56)
        self.lblBack.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.lblBack.textColor = Color.color(hexString: "#013AA5")
        
        // View Task
        self.setupViewTask()
    }
    
    fileprivate func setupViewTask() {
        self.vTaskShadow.layer.cornerRadius = 8.0
        self.vTaskShadow.layer.shadowColor = Color.color(hexString: "#649BFF").withAlphaComponent(0.32).cgColor
        self.vTaskShadow.layer.shadowOpacity = 1.0
        self.vTaskShadow.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vTaskShadow.layer.shadowRadius = 10 / 2.0
        self.vTaskShadow.layer.shadowPath = nil
        self.vTaskShadow.layer.masksToBounds = false
        
        self.vTask.clipsToBounds = true
        self.vTask.backgroundColor = UIColor.white
        self.vTask.layer.cornerRadius = 8.0
        
        self.btnCancel.addTextSpacing(-0.44)
        self.btnCancel.tintColor = Color.color(hexString: "#505259")
        self.btnCancel.layer.cornerRadius = 8.0
        self.btnCancel.titleLabel?.font = Font.font(name: Font.Montserrat.bold, size: 22.0)
        
        self.btnNext.addTextSpacing(-0.44)
        self.btnNext.tintColor = Color.color(hexString: "#013AA5")
        self.btnNext.layer.cornerRadius = 8.0
        self.btnNext.titleLabel?.font = Font.font(name: Font.Montserrat.bold, size: 22.0)
        
        self.collectionView.register(DemographicsCell.nib(), forCellWithReuseIdentifier: DemographicsCell.identifier())
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        
        // Setup First Data
        let _PID = PID.getID()
        self.arrDemoGraphicsStyle.forEach { (style) in
            if style == .PaientIDNumber {
                self.objectArray.append(Demographics.Objects.init(title: style, value: _PID))
            }
            else if style == .Ethnicity {
                self.objectArray.append(Demographics.Objects.init(title: style, value: self.ethnicData[0]))
            }
            else if style == .Gender {
                self.objectArray.append(Demographics.Objects.init(title: style, value: self.genderData[0]))
            }
            else if style == .Race {
                self.objectArray.append(Demographics.Objects.init(title: style, value: self.raceData[0]))
            }
            else if style == .Age {
                self.objectArray.append(Demographics.Objects.init(title: style, value: self.ageData[40]))
            }
            else if style == .PatientUID {
                self.objectArray.append(Demographics.Objects.init(title: style, value: PUID))
            }
            else if style == .Education {
                self.objectArray.append(Demographics.Objects.init(title: style, value: self.educationData[12]))
            }
            else {
                // Protocol
                self.objectArray.append(Demographics.Objects.init(title: style, value: self.protocolData[0]))
            }
        }
        self.collectionView.reloadData()
        
        self.vTask.addSubview(self.dropDown)
        self.dropDown.isHidden = true
        self.dropDown.delegate = self
        self.dropDown.dataSource = self
        self.dropDown.separatorStyle = .none
        self.dropDown.layer.borderWidth = 1.0
        self.dropDown.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
    }
    
    fileprivate func setupFirstData() {
        age = ageData[40]
        Gender = genderData[0]
        Ethnicity = ethnicData[0]
        Education = educationData[12]
        Race = raceData[0]
        
        guard let _ = Settings.patientID else { return }
        testStartTime = Foundation.Date()
        
        PUID = ""
        Settings.PUID = nil
        if atBIDMCOn == true && theTestClass == 2 {
            ModeECT = true
        }
        else {
            ModeECT = false
        }
        
        Protocol = protocolData[0]
    }
}

// MARK: - Action
extension Demographics {
    @IBAction func TestDone(_ sender: AnyObject) {
        Results1.append(PID.getID())
        Results1.append(Gender!)
        Results1.append(Ethnicity!)
        Results1.append(Education!)
        Results1.append(age!)
        Results1.append(Race!)
        debugPrint(Results1)
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func NextPressed(_ sender: UIButton) {
        // Save PID, PUID
        var _PID = String()
        var _PUID = String()
        var _genderUser = String()
        var _ageUser = String()
        var _educationUser = String()
        var _ethnicityUser = String()
        var _raceUser = String()
        var _protocol = String()
        
        for i in 0..<self.objectArray.count {
            let idx = IndexPath.init(row: i, section: 0)
            if let cell = self.collectionView.cellForItem(at: idx) as? DemographicsCell, let style = cell.style {
                if style == .PaientIDNumber {
                    if !PID.changeID(proposed: cell.textField.text!) {
                        _PID = PID.getID()
                    }
                }
                else if style == .Ethnicity {
                    _ethnicityUser = cell.lblSelected.text!
                }
                else if style == .Gender {
                    _genderUser = cell.lblSelected.text!
                }
                else if style == .Race {
                    _raceUser = cell.lblSelected.text!
                }
                else if style == .Age {
                    _ageUser = cell.lblSelected.text!
                }
                else if style == .PatientUID {
                    _PUID = cell.textField.text!
                }
                else if style == .Education {
                    _educationUser = cell.lblSelected.text!
                }
                else {
                    _protocol = cell.lblSelected.text!
                }
            }
        }
        // TODO: change flow PID
        age = _ageUser
        Gender = _genderUser
        Education = _educationUser
        Race = _raceUser
        Ethnicity = _ethnicityUser
        PUID = _PUID
        Protocol = _protocol
        Results1.append(PID.getID())
        Results1.append(Gender!)
        Results1.append(Ethnicity!)
        Results1.append(Education!)
        Results1.append(age!)
        Results1.append(Race!)
        Results1.append(PUID)
        debugPrint(Results1)
        
        Settings.patientID = !_PID.isEmpty ? _PID : PID.getID()
        Settings.genderUser = _genderUser
        Settings.ageUser = _ageUser
        Settings.educationUser = _educationUser
        Settings.ethnicityUser = _ethnicityUser
        Settings.raceUser = _raceUser
        Settings.protocolUser = _protocol
        Settings.PUID = _PUID
        Settings.isGotoTest = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "main") as! MainViewController
        vc.mode = self.mode
        presentViewController(viewController: vc, animated: true, completion: nil)
    }
    
    @IBAction func CancelPressed(_ sender: Any) {
        Settings.isGotoTest = true
        dismiss(animated: true, completion: nil)
    }
    
    func showAddMoreRace(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Add more", message: "Enter add more", preferredStyle: .alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
        })
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if let result = textField.text, !result.isEmpty {
                //do something if it's not empty
                self.raceData.insert(result, at: self.raceData.count-1)
                self.objectArray[indexPath.item].value = self.raceData[self.raceData.count-2]
                Race = self.raceData[self.raceData.count-2]
                self.txtSelected = self.raceData[self.raceData.count-2]
            }
            else {
                alert.dismiss(animated: true, completion: nil)
            }
            self.collectionView.reloadItems(at: [indexPath])
            self.dropDown.isHidden = true
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextField Delegate
extension Demographics {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.collectionView.indexPathsForSelectedItems?.forEach { self.collectionView.deselectItem(at: $0, animated: false) }
        textField.layer.borderColor = Color.color(hexString: "#649BFF").cgColor
        self.dropDown.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = Color.color(hexString: "#EAEAEA").cgColor
        self.dropDown.isHidden = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > textField.text!.count {
            return false
        }
        
        if string.isEmpty {
            return true
        }
        
        if textField.tag == 1 {
            // PaientIDNumber only number
            return Int(string) != nil
        }
        else {
            // PatientUID
            return true
        }
    }
    
    @objc func updatePaientIDNumber(_ textField: UITextField) {
        guard let _patientID = textField.text, let cell = self.collectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? DemographicsCell else { return }
        cell.textField.text = _patientID
        if !PID.changeID(proposed: _patientID) {
            Settings.patientID = PID.getID()
        }
    }
}

// MARK: - UICollectionView Delegate, DataSource, DelegateFlowLayout
extension Demographics: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objectArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCollectionView: CGFloat = self.collectionView.frame.size.width
        let widthCell = ((widthCollectionView - 27) / 2)
        return CGSize.init(width: widthCell, height: 74.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 27.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 27.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DemographicsCell.identifier(), for: indexPath) as! DemographicsCell
        
        let obj = self.objectArray[indexPath.item]
        cell.bindData(style: obj.title, value: obj.value)
        
        if obj.title == DemoGraphicsCellStyle.PaientIDNumber {
            cell.textField.tag = 1
            cell.textField.addTarget(self, action: #selector(self.updatePaientIDNumber(_:)), for: .editingDidEnd)
        }
        
        cell.textField.delegate = self
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.objectArray[indexPath.item]
        if obj.title == DemoGraphicsCellStyle.PaientIDNumber || obj.title == DemoGraphicsCellStyle.PatientUID {
            self.dropDown.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath)
        if item?.isSelected ?? false {
            collectionView.deselectItem(at: indexPath, animated: false)
            self.dropDown.isHidden = true
        } else {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self.dropDown.isHidden = false
        }
        
        return false
    }
}

// MARK: - DemoGraphicsCell Delegate
extension Demographics: DemoGraphicsCellDelegate {
    func showDropDown(indexPath: IndexPath, style: DemoGraphicsCellStyle) {
        if let theAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) {
            let cellFrameInSuperview = self.collectionView.convert(theAttributes.frame, to: collectionView.superview)
            
            self.selectedStyle = style
            // Update frame Dropdown
            self.dropDown.frame = CGRect.init(x: cellFrameInSuperview.origin.x,
                                              y: cellFrameInSuperview.origin.y + cellFrameInSuperview.size.height + 6.0,
                                              width: cellFrameInSuperview.size.width,
                                              height: 118.0)
            self.dropDown.isHidden = false
            if style == .Gender {
                self.dropDownData = self.genderData
            }
            else if style == .Education  {
                self.dropDownData = self.educationData
            }
            else if style == .Race  {
                self.dropDownData = self.raceData
            }
            else if style == .Ethnicity  {
                self.dropDownData = self.ethnicData
            }
            else if style == .Age  {
                self.dropDownData = self.ageData
            }
            else if style == .Protocols  {
                self.dropDownData = self.protocolData
            }
            else {
                self.dropDown.isHidden = true
            }
            
            if self.dropDown.isHidden == false {
                self.view.endEditing(true)
            }
            
            if let collectionViewCell = self.collectionView.cellForItem(at: indexPath) as? DemographicsCell, let lblSelected = collectionViewCell.lblSelected.text {
                self.txtSelected = lblSelected
            }

            self.dropDown.reloadData()
            
            for i in 0..<self.dropDownData.count {
                if self.dropDownData[i] == self.txtSelected {
                    let idx = IndexPath.init(row: i, section: 0)
                    self.dropDown.scrollToRow(at: idx, at: .middle, animated: false)
                }
            }
            // Disable scroll collectionView
            self.collectionView.isScrollEnabled = false
        }
    }
    
    // MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.collectionView.indexPathsForSelectedItems?.forEach { self.collectionView.deselectItem(at: $0, animated: false) }
        self.dropDown.isHidden = true
    }
}

// MARK: - UITableView Delegate, DataSource
extension Demographics: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dropDownData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118.0/3.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.addTextSpacing(-0.36)
        cell.textLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        cell.textLabel?.textColor = .black
        if self.dropDownData.count > 0 {
            cell.textLabel?.text = self.dropDownData[indexPath.row]
            if self.txtSelected == self.dropDownData[indexPath.row] {
                cell.contentView.backgroundColor = Color.color(hexString: "#EAEAEA")
            }
            else {
                cell.contentView.backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strData = self.dropDownData[indexPath.row]
        if let style = self.selectedStyle, let idx = self.objectArray.firstIndex(where: { $0.title == style }) {
            if style == .Race && strData == "Add more" {
                self.objectArray[idx].value = strData
                self.collectionView.reloadItems(at: [IndexPath.init(item: idx, section: 0)])
                self.showAddMoreRace(indexPath: IndexPath.init(row: idx, section: 0))
            }
            else {
                self.objectArray[idx].value = strData
                self.collectionView.reloadItems(at: [IndexPath.init(item: idx, section: 0)])
                self.dropDown.isHidden = true
            }
            self.dropDown.isHidden = true
            // Enabled scroll collectionView
            self.collectionView.isScrollEnabled = true
        }
    }
}
