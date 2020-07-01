//
//  NamingPicturesViewController.swift
//  Integrated test v1
//
//  Created by Seth Amarasinghe on 7/14/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//
import UIKit

class PicturesViewController: BaseViewController {
    
    let namingImages:[String] = ["ring", "chimney", "clover", "ladle", "piano", "eyebrow", "shovel", "lighthouse", "goggles", "horseshoe", "corkscrew", "anvil", "yarn", "llama", "skeleton"]
    
    var imageName = "House"
    var count = 0
    var corr = 0
    var back = 0
    
    var order = [Bool]()
    var startTime2 = NSDate()
    var startTime = Foundation.Date()
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var resetButton: GradientButton!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var lbObjectName: UILabel!
    @IBOutlet weak var tfObjectName: UITextField!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var innerShadowView: UIView!
    @IBOutlet weak var namingImageView: UIImageView!
    @IBOutlet weak var arrowLeftButton: UIButton!
    @IBOutlet weak var arrowRightButton: UIButton!
    @IBOutlet weak var backTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var quitButton: GradientButton!
    
    var counterTimeView: CounterTimeView!
    var totalTimeCounter = Timer()
    var startTimeTask = Foundation.Date()
    
    var imageView = UIImageView()
    
    var totalCount = Int()
    
    var wrongList = [String]()
    
    var resultImage : [String] = []
    var resultStatus : [String] = []
    var resultTime : [Date] = []
    var resultObjectName : [String] = []
    var isStartNew: Bool = false
    var isUndo: Bool = false
    
    // QuickStart Mode
    var quickStartModeOn: Bool = false
    var didBackToResult: (() -> ())?
    var didCompleted: (() -> ())?
    
    @IBOutlet weak var mViewResult: UIView!
    @IBOutlet weak var mTableResult: UITableView!
    @IBOutlet weak var mLbResult: UILabel!
    @IBOutlet weak var mLbTimeComplete: UILabel!
    var arrDataResult : [SMResultModel] = [SMResultModel]()
    
    static var identifier = "PicturesViewController"
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupCounterTimeView()
        self.startNew()
    }
    
    fileprivate func runTimer() {
        self.totalTimeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.totalTimeCounter.fire()
    }
    
    @objc func updateTime(timer: Timer) {
        self.counterTimeView.setTimeWith(startTime: self.startTimeTask, currentTime: Foundation.Date())
    }
    
    fileprivate func resumeTest() {
        guard let strObjName = self.tfObjectName.text?.trimmingCharacters(in: .whitespaces), !strObjName.isEmpty else {
            let warningAlert = UIAlertController(title: "Warning", message: "Please enter Object Name fields.", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                warningAlert.dismiss(animated: true, completion: nil)
            }))
            self.present(warningAlert, animated: true, completion: nil)
            return
        }
        
        backButton.isEnabled = true
        //        resetButton.isEnabled = true
        arrowLeftButton.isHidden = false
        
        if isUndo == true, self.resultObjectName.count != count {
            self.resultObjectName[count] = strObjName
        }
        else {
            self.resultObjectName.append(strObjName)
        }
        count += 1
        if isUndo == true, self.resultObjectName.count != count {
            self.tfObjectName.text = self.resultObjectName[count]
        }
        else {
            self.tfObjectName.text = ""
        }
        
        let currTime = Foundation.Date()
        resultTime.append(currTime)
        
        if(count==totalCount){
            done()
        }
        else {
            imageName = getImageName()
            let image1 = UIImage(named: imageName)
            namingImageView.image = image1
            
            if count != namingImages.count {
                placeLabel.text = "\(count+1)/\(namingImages.count)"
            }
        }
    }
    
    func done() {
        
        arrowLeftButton.isHidden = true
        arrowRightButton.isHidden = true
        backButton.isEnabled = true
        
        self.namingImageView.isHidden = true
        self.lbObjectName.isHidden = true
        self.tfObjectName.isHidden = true
        self.isStartNew = true
        
        placeLabel.text = ""
        self.wrongList.removeAll()
        corr = 0
        let _resultObjectName = self.resultObjectName.map{ $0.lowercased() }
        
        _resultObjectName.forEach { (obj) in
            if self.namingImages.contains(obj) {
                corr += 1
            }
        }
        
        self.namingImages.forEach { (nameImg) in
            if !_resultObjectName.contains(nameImg) {
                wrongList.append(nameImg)
            }
        }
        
        count = self.resultObjectName.count
        
        Status[TestNampingPictures] = TestStatus.Done
        
        // Save Results
        totalTimeCounter.invalidate()
        //
        let result = Results()
        result.name = TestName.NAMING_PICTURE
        result.startTime = startTime2 as Date
        result.endTime = NSDate() as Date
        
        var imageResult = "["
        for i in 0...namingImages.count - 1 {
            if i == namingImages.count - 1 {
                imageResult.append("\(namingImages[i])]")
            } else {
                imageResult.append("\(namingImages[i]), ")
            }
        }
        
        result.rounds = namingImages.count
        result.longDescription.add("The correct pictures were: \(imageResult)")
        result.numErrors = (count - corr)
        result.numCorrects = corr
        result.json["Answered"] = count
        result.json["Correct"] = corr
        result.shortDescription = "\(corr) correct with \(count) answered"
        resultsArray.add(result)
        
        // Show resultsLabel
        var str:String = "\(corr) correct out of \(count)"
        if wrongList.count > 0 {
            str += "\nThe incorrect picture\(wrongList.count > 1 ? "s were" : " was")  the \(wrongList)"
        }
        self.resultsLabel.text = str
        //summary time
        let completeTime = result.totalElapsedSeconds()
        self.mLbTimeComplete.text = "Test complete in \(completeTime) seconds"
        //generate result
        generateArrayDataResult()
        //load data
        mTableResult.reloadData()
        mViewResult.isHidden = false
        
        // Reset Data
        self.tfObjectName.text = ""
        self.resultObjectName.removeAll()
        order = [Bool]()
        wrongList = [String]()
        count = 0
        corr = 0
        back = 0
        imageName = getImageName()
        resultStatus.removeAll()
        resultTime.removeAll()
        resultImage.removeAll()
        let image4 = UIImage(named: imageName)
        
        namingImageView.image = image4
        
        placeLabel.text = "\(count+1)/\(namingImages.count)"
    }
    
    func getImageName()->String{
            
        return namingImages[count]
        
    }
    
    func fixDimensions(image:UIImage){
        
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
        let bottomContraintButtonNext = self.bottomConstraintButtonNext()
        imageView.frame = CGRect(x: (512.0-(x/2)), y: bottomContraintButtonNext, width: x, height: y)
        
    }
    
    // Get bottom constraint of button results
    private func bottomConstraintButtonNext() -> CGFloat {
        var bottomConstraint = self.arrowRightButton.frame.origin.y + self.arrowRightButton.frame.size.height + 20
        if #available(iOS 11.0, *) { }
        else {
            bottomConstraint = self.arrowRightButton.frame.origin.y + self.arrowRightButton.frame.size.height + 40
        }
        return bottomConstraint
    }
    
    fileprivate func startNew() {
        mViewResult.isHidden = true
        placeLabel.isHidden = true
        placeLabel.text = "\(count+1)/\(namingImages.count)"
        debugPrint(selectedTest, terminator: "")
        self.title = "Naming Pictures"
        startTime2 = NSDate()
        totalCount = namingImages.count
        
        self.resultsLabel.text = ""
        self.tfObjectName.text = ""
        
        Status[TestNampingPictures] = TestStatus.NotStarted
        
        count = 0
        corr = 0
        back = 0
        imageName = getImageName()
        
        let image = UIImage(named: imageName)
        
        namingImageView.image = image
        
        arrowLeftButton.isHidden = true
        arrowRightButton.isHidden = false
        backButton.isEnabled = true
        self.namingImageView.isHidden = false
        
        self.isStartNew = false
        self.resultObjectName.removeAll()
        self.lbObjectName.isHidden = false
        self.tfObjectName.isHidden = false
    }
    
    func generateArrayDataResult(){
        arrDataResult.removeAll()
        for i in 0..<count{
            let input = resultObjectName[i]
            let exactly = namingImages[i]
            let result = input == exactly ? true : false
            let model = SMResultModel.init(objectName: "Object \(i)", input: input, exactResult: exactly, result: result)
            arrDataResult.append(model)
        }
    }
}

extension PicturesViewController {
    // MARK: - IBAction
    @IBAction func btnNextTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if isStartNew == true {
            self.startNew()
        }
        else {
            self.resumeTest()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        self.view.endEditing(true)
        self.startTimeTask = Foundation.Date()
        self.totalTimeCounter.invalidate()
        self.runTimer()
        self.startNew()
    }
    
    @IBAction func actionQuit(_ sender: Any) {
        self.startTimeTask = Foundation.Date()
        self.totalTimeCounter.invalidate()
        self.view.endEditing(true)
        
        if Status[TestNampingPictures] != TestStatus.Done {
            Status[TestNampingPictures] = TestStatus.NotStarted
        }
        
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            QuickStartManager.showAlertCompletion(viewController: self, cancel: {
                self.didBackToResult?()
            }, ok: {
                self.didCompleted?()
            })
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undoTapped(_ sender: Any) {
        arrowLeftButton.isHidden = false
        isUndo = true
        count -= 1
        back = count
        self.tfObjectName.text = self.resultObjectName[count]
        if count == 0 {
            arrowLeftButton.isHidden = true
            self.navigationItem.setHidesBackButton(false, animated:true)
        }
        imageName = getImageName()
        let image3 = UIImage(named: imageName)
        
        namingImageView.image = image3
        
        placeLabel.text = "\(count+1)/\(namingImages.count)"
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        if Status[TestNampingPictures] != TestStatus.Done {
            Status[TestNampingPictures] = TestStatus.NotStarted
        }
        self.startTimeTask = Foundation.Date()
        self.totalTimeCounter.invalidate()
        
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            didBackToResult?()
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension PicturesViewController {
    fileprivate func setupView() {
        self.backTitleLabel.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.backTitleLabel.textColor = Color.color(hexString: "#013AA5")
        self.backTitleLabel.addTextSpacing(-0.56)
        self.backTitleLabel.text = "BACK"
        
        self.innerShadowView.layer.cornerRadius = 8
        self.innerShadowView.layer.shadowColor = Color.color(hexString: "#649BFF").withAlphaComponent(0.32).cgColor
        self.innerShadowView.layer.shadowOpacity = 1
        self.innerShadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.innerShadowView.layer.shadowRadius = 10 / 2
        self.innerShadowView.layer.shadowPath = nil
        self.innerShadowView.layer.masksToBounds = false
        
        self.lbObjectName.font = Font.font(name: Font.Montserrat.medium, size: 27.0)
        self.lbObjectName.textColor = Color.color(hexString: "#8A9199")
        self.lbObjectName.text = "Object Name"
        self.lbObjectName.addTextSpacing(-0.36)
        
        
        self.tfObjectName.font = Font.font(name: Font.Montserrat.medium, size: 28.0)
        self.tfObjectName.backgroundColor = Color.color(hexString: "#F7F7F7")
        
        self.arrowLeftButton.backgroundColor = Color.color(hexString: "#EEF3F9")
        self.arrowLeftButton.layer.cornerRadius = self.arrowLeftButton.frame.size.height / 2.0
        self.arrowRightButton.backgroundColor = Color.color(hexString: "#EEF3F9")
        self.arrowRightButton.layer.cornerRadius = self.arrowRightButton.frame.size.height / 2.0
        
        self.resetButton.setTitle(title: "RESET", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        self.resetButton.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        self.resetButton.setupGradient(arrColor: [Color.color(hexString: "#FFDC6E"),Color.color(hexString: "#FFC556")], direction: .topToBottom)
        self.resetButton.render()
        self.resetButton.addTextSpacing(-0.36)
        
        self.quitButton.setTitle(title: "QUIT", withFont: Font.font(name: Font.Montserrat.bold, size: 18))
        self.quitButton.setupShadow(withColor: UIColor.clear, sketchBlur: 0, opacity: 0)
        self.quitButton.setupGradient(arrColor: [Color.color(hexString: "FFAFA6"),Color.color(hexString: "FE786A")], direction: .topToBottom)
        self.quitButton.render()
        self.quitButton.addTextSpacing(-0.36)
        
        // Change back button title if quickStartMode is On
        if quickStartModeOn {
            backTitleLabel.text = "RESULTS"
            quitButton.updateTitle(title: "CONTINUE")
        }
        
        // TableView Results
        self.mTableResult.register(SMResultCell.nib(), forCellReuseIdentifier: SMResultCell.identifier())
        self.mTableResult.delegate = self
        self.mTableResult.dataSource = self
        mViewResult.isHidden = true
    }
    
    fileprivate func setupCounterTimeView() {
        counterTimeView = CounterTimeView()
        contentView.addSubview(counterTimeView!)
        counterTimeView?.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        counterTimeView?.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor).isActive = true
        self.totalTimeCounter.invalidate()
        self.runTimer()
    }
}


// MARK: - UITableView Delegate, DataSource
extension PicturesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (count + 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SMResultCell.identifier(), for: indexPath) as? SMResultCell {
            if indexPath.row == 0 {
                cell.isHeader = true
            }
            else {
                cell.isHeader = false
            }
            if indexPath.row != 0{
                let index = indexPath.row - 1
                cell.model = arrDataResult[index]
                if index < count - 1 {
                    cell.arrayConstraintLineBottom.forEach{ $0.constant = 0 }
                }
                else {
                    cell.arrayConstraintLineBottom.forEach{ $0.constant = 1 }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}
