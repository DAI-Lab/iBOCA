//
//  MainViewController.swift
//  iBOCA
//
//  Created by saman on 1/21/17.
//  Copyright © 2017 sunspot. All rights reserved.
//

import Foundation

import UIKit
import MessageUI
var screenSize : CGRect?

var testName:String?

enum TestMode {
    case patient
    case admin
}

class GoToTestCellModel : NSObject{
    var title = ""
    var icon = ""
    var segueID = ""
    var isComplete = false
    
    class func cre(ititle:String,pathIcon:String,iSegueID:String,completed : Bool = false)->GoToTestCellModel{
        let model = GoToTestCellModel()
        model.title = ititle
        model.icon = pathIcon
        model.segueID = iSegueID
        model.isComplete = completed
        return model
    }
    
    override var description: String {
        return "title: \(self.title) - isComplete: \(self.isComplete)"
    }
}

class MainViewController: BaseViewController, MFMailComposeViewControllerDelegate{
    var mailSubject : String = "iBOCA Results of "
    
    // NOTE: All buttons have to have the keypath translatesAutoresizingMaskIntoConstraints unset!!!
    // Otherwise setting constraints don't work
    @IBOutlet weak var ButtonOrientation: UIButton!
    @IBOutlet weak var ButtonSimpleMemory: UIButton!
    @IBOutlet weak var ButtonVisualAssociation: UIButton!
    @IBOutlet weak var ButtonTrails: UIButton!
    @IBOutlet weak var ButtonForwardDigitSpan: UIButton!
    @IBOutlet weak var ButtonBackwardDigitSpan: UIButton!
    @IBOutlet weak var ButtonCatsAndDogs: UIButton!
    @IBOutlet weak var Button3DFigureCopy: UIButton!
    @IBOutlet weak var ButtonSerialSevens: UIButton!
    @IBOutlet weak var ButtonForwardSpatialSpan: UIButton!
    @IBOutlet weak var ButtonBackwardSpatialSpan: UIButton!
    @IBOutlet weak var ButtonNamingPictures: UIButton!
    @IBOutlet weak var ButtonMOCA: UIButton!
    
    @IBOutlet weak var ButtonSemanticListGeneration: UIButton!
    @IBOutlet weak var ButtonGDT: UIButton!
    @IBOutlet weak var ButtonGoldStandard: UIButton!
    @IBOutlet weak var PatientID: UILabel!
    
    @IBOutlet weak var ButtonResults: UIButton!
    @IBOutlet weak var ButtonDWP: UIButton!
    
    //MARK: - New UI
    @IBOutlet weak var mViewMain: UIView!
    @IBOutlet weak var mBtnResult: GradientButton!
    @IBOutlet weak var mBtnDWP: GradientButton!
    @IBOutlet weak var lblPatientID: UILabel!
    
    var mCollection : UICollectionView?
    var arrData : [GoToTestCellModel] = [GoToTestCellModel]()
    var mode : TestMode = TestMode.admin
    
    var mCounterTimeView : CounterTimeView?
    
    var VADelayTime: Int = 0
    var SMDelayTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.main.bounds
        
        emailOn = UserDefaults.standard.bool(forKey: "emailOn")
        if(UserDefaults.standard.object(forKey: "emailAddress") != nil) {
            emailAddress = UserDefaults.standard.object(forKey: "emailAddress") as! String
        }
        proctoredTransmitOn = UserDefaults.standard.bool(forKey: "Transmit")
        
        PatientID.text = PID.getID()
        
//        updateButton(id: 0, ectid:0, button: ButtonOrientation, status: Status[TestOrientation])
//        updateButton(id: 1, ectid:0, button: ButtonSimpleMemory, status: Status[TestSimpleMemory])
//        updateButton(id: 2, ectid:0, button: ButtonVisualAssociation, status: Status[TestVisualAssociation])
//        updateButton(id: 3, ectid:4, button: ButtonTrails, status: Status[TestTrails])
//        updateButton(id: 4, ectid:2, button: ButtonForwardDigitSpan, status: Status[TestForwardDigitSpan])
//        updateButton(id: 5, ectid:3, button: ButtonBackwardDigitSpan, status: Status[TestBackwardsDigitSpan])
//        updateButton(id: 6, ectid:1, button: ButtonCatsAndDogs, status: Status[TestCatsAndDogs])
//        updateButton(id: 7, ectid:0, button: Button3DFigureCopy, status: Status[Test3DFigureCopy])
//        updateButton(id: 8, ectid:5, button: ButtonSerialSevens, status: Status[TestSerialSevens])
//        updateButton(id: 9, ectid:6, button: ButtonForwardSpatialSpan, status: Status[TestForwardSpatialSpan])
//        updateButton(id:10, ectid:7, button: ButtonBackwardSpatialSpan, status: Status[TestBackwardSpatialSpan])
//        updateButton(id:11, ectid:0, button: ButtonNamingPictures, status: Status[TestNampingPictures])
//        updateButton(id:13, ectid:0, button: ButtonMOCA, status: Status[TestMOCAResults])
//
//        updateButton(id:12, ectid:8, button: ButtonSemanticListGeneration, status: Status[TestSemanticListGeneration])
//        updateButton(id:14, ectid:0, button: ButtonGDT, status: Status[TestGDTResults])
//        updateButton(id:15, ectid:0, button: ButtonGoldStandard, status: Status[TestGoldStandard])
//
//        if ModeECT == false {
//            ButtonMOCA.isHidden = false
//            ButtonGoldStandard.isHidden = false
//        }
//
//        // Do GDT only at BIDMC
//        if atBIDMCOn == false {
//            ButtonGDT.isHidden = true
//            ButtonGoldStandard.isHidden = true
//        }
        
        //NEW UI
        self.setupLabelPatientID()
        setupButton()
        setupCollectionView()
        setupData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showVADelayTime(_:)), name: NSNotification.Name(rawValue: "VADelayTime"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSMDelayTime(_:)), name: NSNotification.Name(rawValue: "SMDelayTime"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showVADelayTime(_ notification: NSNotification) {
        debugPrint(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["VADelayTime"] as? Int {
                // do something with VADelayTime
                self.VADelayTime = id
                self.mCollection?.reloadData()
            }
        }
    }
    
    @objc func showSMDelayTime(_ notification: NSNotification) {
        debugPrint(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["SMDelayTime"] as? Int {
                // do something with VADelayTime
                self.SMDelayTime = id
                self.mCollection?.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsLayout()
    }
    
//    public override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//       //Setting view's frame
//       let width = UIScreen.main.bounds.size.width - 10
//       let height = (43 * UIScreen.main.bounds.height) / 100 //%43 of the screen
//       self.view.frame = CGRect(x: 5, y: 80, width: width, height: height)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.title = nil
        testName = segue.identifier
    }
    
    var doSecondEmail = false
    
    @IBAction func sendEmail(_ sender: Any) {
        var body:String?
        
        // Clear All Singleton SM & VA
        MyGlobalVA.shared.clearAll()
        MyGlobalVA.shared.stopTotalTimer()
        MyGlobalVA.shared.total = 0
        MyGlobalVA.shared.delay = 0
        
        MyGlobalSM.shared.clearAll()
        MyGlobalSM.shared.stopTotalTimer()
        MyGlobalSM.shared.total = 0
        MyGlobalSM.shared.delay = 0
        
        if(MFMailComposeViewController.canSendMail()  && resultsArray.numResults() > 0) {
            // Check mode Admin or Proctored
            switch mode {
            case .admin:
                if let email = Settings.resultsEmailAddressByAdmin {
                    body = resultsArray.emailBody()
                    sendEmail(body: body!, address: [email])
                    if (adminTransmitOn) {
                        // queue the 2nd e-mail to server
                        doSecondEmail = true
                    }
                } else if (adminTransmitOn) {
                    // email to server
                    sendEmail(body: "", address: [serverEmailAddress])
                } else {
                    resultsArray.doneWithPatient()
                    backToLandingPage()
                }
            case .patient:
                if let email = Settings.resultsEmailAddressByProctored {
                    body = resultsArray.emailBody()
                    sendEmail(body: body!, address: [email])
                    if (proctoredTransmitOn) {
                        // queue the 2nd e-mail to server
                        doSecondEmail = true
                    }
                } else if (proctoredTransmitOn) {
                    // email to server
                    sendEmail(body: "", address: [serverEmailAddress])
                } else {
                    backToLandingPage()
                }
            }
        } else {
            // nothing to send
            resultsArray.doneWithPatient()
            backToLandingPage()
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        switch result {
        case MFMailComposeResult.cancelled:
            break
        case MFMailComposeResult.saved:
            break
        case MFMailComposeResult.sent:
            if doSecondEmail {
                doSecondEmail = false
                // TransmitOn is why we are here
                sendEmail(body: "", address: [serverEmailAddress])
            } else {
                // all e-mail sent
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let strongSelf = self else {return}
                    resultsArray.doneWithPatient()
                    PID.incID()
                    strongSelf.backToLandingPage()
                }
            }
        case MFMailComposeResult.failed:
            break
        default:
            break
        }
    }
    
    func sendEmail(body: String, address: [String]) {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject(mailSubject + PID.getID())
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients(address)
        
        let data = encryptString(str: resultsArray.toJson())
        
        picker.addAttachmentData(data, mimeType: "application/aes", fileName: "Encrypted-JSON-\(PID.getID()).aes")
        
        present(picker, animated: true)
    }
    
    func updateButton(id: UInt, ectid: UInt, button: UIButton, status : TestStatus) {
        switch(status) {
        case .NotStarted:
            button.tintColor = UIColor.blue
            break
            
        case .Running:
            button.tintColor = UIColor.red
            break
            
        case .Done:
            button.tintColor = UIColor.darkGray
            break
        }
        
        for constraint in button.constraints {
            button.removeConstraint(constraint)
        }
        if ModeECT {
            button.isHidden = (ectid == 0 ? true:false)
            if(ectid != 0) {
                let order = ProtocolOrder[Protocol]![Int(ectid-1)]
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                let spacing: CGFloat = 60.0
                let centerY: CGFloat = self.bottomConstraintButtonResults() + (CGFloat(order) * spacing)
                button.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: centerY).isActive = true
            }
        } else {
            if id < 8 {
                button.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant:250).isActive = true
            } else {
                button.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant:-250).isActive = true
            }
            
            let newid = ((id < 8) ? id : id - 8)
            let spacing: CGFloat = 60.0
            let centerY: CGFloat = self.bottomConstraintButtonResults() + (CGFloat(newid) * spacing)
            button.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: centerY).isActive = true
        }
    }
    
    // Get bottom constraint of button results
    private func bottomConstraintButtonResults() -> CGFloat {
        var bottomConstraint = self.ButtonResults.frame.origin.y + self.ButtonResults.frame.size.height + 20
        if #available(iOS 11.0, *) { }
        else {
            bottomConstraint = self.ButtonResults.frame.origin.y + self.ButtonResults.frame.size.height + 40
        }
        return bottomConstraint
    }
    
    func getTimeDelay(startTime:TimeInterval) -> String {
        
        let currTime = NSDate.timeIntervalSinceReferenceDate
        var diff: TimeInterval = currTime - startTime
        
        if diff > 15000 {  // Hack to prevent overflow at the begining
            return ""
        }
        
        let minutes = UInt8(diff / 60.0)
        
        diff -= (TimeInterval(minutes)*60.0)
        
        let seconds = UInt8(diff)
        
        diff = TimeInterval(seconds)
        
        let strMinutes = minutes > 9 ? String(minutes):"0"+String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0"+String(seconds)
        
        return "(\(strMinutes) : \(strSeconds))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - New UI
extension MainViewController {
    
    func setupLabelPatientID() {
        if let patientID = Settings.patientID {
            self.lblPatientID.text = patientID
        }
        self.lblPatientID.textColor = Color.color(hexString: "#0039A7")
        self.lblPatientID.font = Font.font(name: Font.Montserrat.semiBold, size: 18.0)
        self.lblPatientID.addTextSpacing(-0.36)
        
        switch mode {
        case .admin:
            self.lblPatientID.isHidden = true
        case .patient:
            self.lblPatientID.isHidden = false
        }
    }
    
    func setupButton(){
        mBtnResult.setTitle(title: "RESULT", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        mBtnResult.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        mBtnResult.setupGradient(arrColor: [Color.color(hexString: "#FFDC6E"),Color.color(hexString: "#FFC556")], direction: .topToBottom)
        mBtnResult.render()
        mBtnResult.addTextSpacing(-0.36)
        //
        switch mode {
        case .admin:
            mBtnDWP.setTitle(title: "DONE WITH TEST", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        case .patient:
            mBtnDWP.setTitle(title: "DONE WITH PATIENT", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        }
        mBtnDWP.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        mBtnDWP.setupGradient(arrColor: [Color.color(hexString: "FFAFA6"),Color.color(hexString: "FE786A")], direction: .topToBottom)
        mBtnDWP.render()
        mBtnDWP.addTextSpacing(-0.36)
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        mCollection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        mCollection?.translatesAutoresizingMaskIntoConstraints = false
        mViewMain.addSubview(mCollection!)
        mCollection?.topAnchor.constraint(equalTo: mBtnResult.bottomAnchor, constant: 30).isActive = true
        mCollection?.leadingAnchor.constraint(equalTo: mViewMain.leadingAnchor, constant: 42).isActive = true
        mCollection?.trailingAnchor.constraint(equalTo: mViewMain.trailingAnchor, constant: -42).isActive = true
        mCollection?.bottomAnchor.constraint(equalTo: mViewMain.bottomAnchor, constant: -42).isActive = true
        mCollection?.backgroundColor = UIColor.clear
        mCollection?.register(UINib.init(nibName: "GoToTestCollectionCell", bundle: nil), forCellWithReuseIdentifier: "GoToTestCollectionCell")
        mCollection?.delegate = self
        mCollection?.dataSource = self
        mCollection?.showsVerticalScrollIndicator = false
    }
    
    func setupData(){
        let arrTitle = ["Orientation","Simple Memory","Visual Association","Trails","Speech To Text","Forward Digit Span","Backward Digit Span","3D Figure Copy","Serial Sevens",/*"Naming Picture",*/"Forward\nSpatial Span","Backward\nSpatial Span","MOCA\n"]
        let arrIcon = ["orientation","simple-memory","visual-association","trails","speech-to-text","foward-digit-span","backward-digit-span","3d-figure","serial-sevens",/*"naming-picture",*/ "forward-spatial-span","backward-spatial-span","moca"]
        let arrSegueID = ["orientation","simple-memory","visual-association","trails","speech-to-text","ForwardDigitSpan","BackwardDigitSpan","3d-figure","SerialSeven",/*"naming-picture", */"ForwardSpatialSpan","BackwardSpatialSpan","moca"]
        let arrTag : [Int] = [TestOrientation,TestSimpleMemory,TestVisualAssociation,TestTrails,TestSpeechToText,TestForwardDigitSpan,TestBackwardsDigitSpan,Test3DFigureCopy,TestSerialSevens,/*TestNampingPictures,*/TestForwardSpatialSpan,TestBackwardSpatialSpan,TestMOCAResults]
        arrData.removeAll()
        for (index,item) in arrTitle.enumerated(){
            let iTestStatus = Status[arrTag[index]]
            let model = GoToTestCellModel.cre(ititle: item, pathIcon: arrIcon[index],iSegueID: arrSegueID[index],completed: checkStatusDone(fromTestStatus: iTestStatus))
            arrData.append(model)
        }
        debugPrint("arrData: \(arrData)")
        mCollection?.reloadData()
    }
    
    func checkStatusDone(fromTestStatus status:TestStatus)->Bool{
        switch status {
        case .Done:
            return true
        case .NotStarted,.Running:
            return false
        }
    }
    
    func backToLandingPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingPage") as! LandingPage
        presentViewController(viewController: vc, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoToTestCollectionCell", for: indexPath) as! GoToTestCollectionCell
        let item = arrData[indexPath.row]
        cell.setupInfo(model: item)
        if (item.title ==  "Visual Association") {
            if self.VADelayTime != 0 {
                cell.lblTimerDelay.isHidden = false
                cell.lblTimerDelay.text = self.timeFormatted(self.VADelayTime)
            }
            else {
                cell.lblTimerDelay.isHidden = true
            }
        }
        else if (item.title ==  "Simple Memory") {
            if self.SMDelayTime != 0 {
                cell.lblTimerDelay.isHidden = false
                cell.lblTimerDelay.text = self.timeFormatted(self.SMDelayTime)
            }
            else {
                cell.lblTimerDelay.isHidden = true
            }
        }
        else {
            cell.lblTimerDelay.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 180, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = arrData[indexPath.row]
        if item.segueID == "speech-to-text"{
            showAlertCommingSoon()
        } else if item.segueID == "moca" {
            performSegue(withIdentifier: item.segueID, sender: nil)
        } else {
            
            if let introVC = UIStoryboard(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
                introVC.mode = mode
                let navigationController = UINavigationController(rootViewController: introVC)
                navigationController.setNavigationBarHidden(true, animated: false)
                presentViewController(viewController: navigationController, animated: true, completion: nil)
                Settings.SegueId = item.segueID == "trails" ? true : false
                Settings.TestId = item.segueID
            }
        }
        
    }
    
    fileprivate func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d : %02d", minutes, seconds)
    }
    
    func showAlertCommingSoon(){
        let alert = UIAlertController.init(title: ErrorMessage.generalTitle, message: "Coming soon!", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { (iaction) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

