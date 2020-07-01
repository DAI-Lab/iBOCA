//
//  3DFigureCopy.swift
//  iBOCA
//
//  Created by Seth Amarasinghe on 8/29/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import UIKit
import Foundation

class ThreeDFigureCopy: BaseViewController {
    // MARK: - Outlet
    @IBOutlet weak var CorrectButton: UIButton!
    @IBOutlet weak var IncorrectButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var btnReset: GradientButton!
    @IBOutlet weak var btnQuit: GradientButton!
    
    @IBOutlet weak var vCounterTimer: UIView!
    
    @IBOutlet weak var vTaskShadow: UIView!
    @IBOutlet weak var vTask: UIView!
    
    @IBOutlet weak var vErase: UIView!
    @IBOutlet weak var lblErase: UILabel!
    @IBOutlet weak var btnErase: UIButton!
    
    @IBOutlet weak var vDraws: UIView!
    @IBOutlet weak var vDrawImage: UIView!
    @IBOutlet weak var ivDraw: UIImageView!
    
    @IBOutlet weak var vDraw: ThreeDFigureDraw!
    @IBOutlet weak var lblDescDraw: UILabel!
    
    // MARK: - Variable
    var mode : TestMode = TestMode.admin
    
    // QuickStart Mode
    var quickStartModeOn: Bool = false
    var didBackToResult: (() -> ())?
    var didCompleted: (() -> ())?
    
    var result = Results()
    var imagelist = ["Circle2", "rhombus", "SquareTriangle", "rectprism"]
    var curr = 0
    var resultImages : [UIImage] = []
    var resultCondition : [Bool] = []
    var resultTime : [Double] = []
    var startTime  = Foundation.Date()
    var startTime2 = Foundation.Date()
    
    var counterTime: CounterTimeView!
    var timer3DFigureCopy = Timer()
    
    // MARK: - Load Views
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
        self.startTask()
    }
    
    deinit {
        self.timer3DFigureCopy.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: - Setup Views
extension ThreeDFigureCopy {
    fileprivate func setupView() {
        self.setupViewCounterTimer()
        self.setupViewTask()
        self.setupButtonGradient()
    }
    
    fileprivate func setupViewCounterTimer() {
        // View Couter Timer
        self.counterTime = CounterTimeView()
        self.vCounterTimer.backgroundColor = .clear
        self.vCounterTimer.addSubview(self.counterTime)
        self.counterTime.centerXAnchor.constraint(equalTo: self.vCounterTimer.centerXAnchor).isActive = true
        self.counterTime.centerYAnchor.constraint(equalTo: self.vCounterTimer.centerYAnchor).isActive = true
        self.timer3DFigureCopy.invalidate()
        self.runTimer()
    }
    
    fileprivate func runTimer() {
        self.timer3DFigureCopy = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.timer3DFigureCopy.fire()
    }
    
    @objc func updateTime(timer: Timer) {
        self.counterTime.setTimeWith(startTime: self.startTime2, currentTime: Foundation.Date())
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
        
        // View Back
        self.lblBack.addTextSpacing(-0.56)
        self.lblBack.font = Font.font(name: Font.Montserrat.semiBold, size: 28.0)
        self.lblBack.textColor = Color.color(hexString: "#013AA5")
        
        // View Erase
        self.setupViewErase()
        
        // Button Correct
        self.CorrectButton.addTextSpacing(-0.36)
        self.CorrectButton.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.CorrectButton.setTitle("Correct", for: .normal)
        self.CorrectButton.layer.cornerRadius = 8.0
        self.CorrectButton.layer.borderWidth = 2.0
        self.CorrectButton.layer.borderColor = Color.color(hexString: "#BBC7D7").cgColor
        
        // Button InCorrect
        self.IncorrectButton.addTextSpacing(-0.36)
        self.IncorrectButton.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.IncorrectButton.setTitle("Incorrect", for: .normal)
        self.IncorrectButton.layer.cornerRadius = 8.0
        self.IncorrectButton.layer.borderWidth = 2.0
        self.IncorrectButton.layer.borderColor = Color.color(hexString: "#BBC7D7").cgColor
        
        // Button Next
        self.NextButton.addTextSpacing(-0.36)
        self.NextButton.titleLabel?.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.NextButton.setTitle("Next", for: .normal)
        self.NextButton.layer.cornerRadius = 8.0
        self.NextButton.layer.borderWidth = 2.0
        self.NextButton.layer.borderColor = Color.color(hexString: "#BBC7D7").cgColor
        
        if self.mode == .admin {
            self.CorrectButton.isHidden = true
            self.IncorrectButton.isHidden = true
        }
        else {
            self.NextButton.isHidden = true
        }
        
        self.vDrawImage.layer.borderWidth = 2.0
        self.vDrawImage.layer.borderColor = Color.color(hexString: "#A6B6CB").cgColor
        
        self.vDraw.layer.borderWidth = 2.0
        self.vDraw.layer.borderColor = Color.color(hexString: "#A6B6CB").cgColor
        self.lblDescDraw.text = "draw the figure in this box"
        self.lblDescDraw.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.lblDescDraw.textColor = Color.color(hexString: "#8A9199")
        self.lblDescDraw.addTextSpacing(-0.36)
        
        self.vDraw.delegate = self
    }
    
    fileprivate func setupViewErase() {
        // View Erase
        self.vErase.clipsToBounds = true
        self.vErase.backgroundColor = UIColor.white
        self.vErase.layer.cornerRadius = 8.0
        self.vErase.layer.borderWidth = 2.0
        self.vErase.layer.borderColor = Color.color(hexString: "#BBC7D7").cgColor
        self.lblErase.addTextSpacing(-0.36)
        self.lblErase.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.btnErase.addTarget(self, action: #selector(self.actionErase), for: .touchUpInside)
    }
    
    fileprivate func setupButtonGradient() {
        self.btnQuit.setTitle(title: "QUIT", withFont: Font.font(name: Font.Montserrat.bold, size: 18.0))
        self.btnQuit.setupShadow(withColor: .clear, sketchBlur: 0, opacity: 0)
        self.btnQuit.setupGradient(arrColor: [Color.color(hexString: "#FFAFA6"), Color.color(hexString: "#FE786A")], direction: .topToBottom)
        self.btnQuit.render()
        self.btnQuit.addTextSpacing(-0.36)
        self.btnQuit.addTarget(self, action: #selector(self.actionQuit), for: .touchUpInside)
        
        self.btnReset.setTitle(title: "RESET", withFont: Font.font(name: Font.Montserrat.bold, size: 18.0))
        self.btnReset.setupShadow(withColor: .clear, sketchBlur: 0, opacity: 0)
        self.btnReset.setupGradient(arrColor: [Color.color(hexString: "#FCD24B"), Color.color(hexString: "#FFC556")], direction: .topToBottom)
        self.btnReset.render()
        self.btnReset.addTextSpacing(-0.36)
        self.btnReset.addTarget(self, action: #selector(self.actionReset), for: .touchUpInside)
        
        // Change back button title if quickStartMode is On
        if quickStartModeOn {
            lblBack.text = "RESULTS"
            btnQuit.updateTitle(title: "CONTINUE")
        }
    }
}

// MARK: - Action
extension ThreeDFigureCopy {
    @IBAction func actionBack(_ sender: Any) {
        if Status[Test3DFigureCopy] != TestStatus.Done {
            Status[Test3DFigureCopy] = TestStatus.NotStarted
        }
        self.startTime2 = Foundation.Date()
        self.timer3DFigureCopy.invalidate()
        
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            didBackToResult?()
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CorrectAction(_ sender: UIButton) {
        self.resultCondition.append(true)
        self.resultTime.append(Foundation.Date().timeIntervalSince(startTime))
        self.startTime = Foundation.Date()
        self.curr = self.curr + 1
        self.drawImage()
    }
    
    @IBAction func IncorrectAction(_ sender: UIButton) {
        self.resultCondition.append(false)
        self.resultTime.append(Foundation.Date().timeIntervalSince(startTime))
        self.startTime = Foundation.Date()
        self.curr = self.curr + 1
        self.drawImage()
    }
    
    @IBAction func NextAction(_ sender: Any) {
        self.resultTime.append(Foundation.Date().timeIntervalSince(startTime))
        self.startTime = Foundation.Date()
        self.curr = self.curr + 1
        self.drawImage()
    }
    
    fileprivate func startTask() {
        self.result = Results()
        self.result.name = TestName.THREE_DIMENSION_FIGURE_COPY
        
        Status[Test3DFigureCopy] = TestStatus.NotStarted
        
        self.curr = 0
        if self.mode == .admin {
            self.NextButton.isEnabled = true
        }
        else {
            self.CorrectButton.isEnabled = true
            self.IncorrectButton.isEnabled = true
        }
        
        if self.ivDraw != nil {
            self.ivDraw.image = nil
        }
        
        self.startTime = Foundation.Date()
        
        let image = UIImage(named: self.imagelist[self.curr])
        self.ivDraw.image = image
        self.ivDraw.contentMode = .scaleAspectFit
    }
    
    @objc func actionErase() {
        self.lblDescDraw.isHidden = false
        self.vDraw.drawandclearResults()
    }
    
    @objc func actionReset() {
        self.resultCondition.removeAll()
        self.resultImages.removeAll()
        self.resultTime.removeAll()
        self.lblDescDraw.isHidden = false
        self.vDraw.drawandclearResults()
        
        // Couter Timer
        self.startTime2 = Foundation.Date()
        self.timer3DFigureCopy.invalidate()
        self.runTimer()
        
        self.startTask()
    }
    
    @objc func actionQuit() {
        
        if self.curr != 0 {
            self.saveResult()
        }
        if Status[TestVisualAssociation] != TestStatus.Done {
            Status[TestVisualAssociation] = TestStatus.NotStarted
        }
        self.startTime2 = Foundation.Date()
        self.timer3DFigureCopy.invalidate()
        
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
    
    fileprivate func saveResult() {
        self.result.startTime = self.startTime2
        self.result.endTime = Foundation.Date()
        self.result.longDescription.add("Tests: \(imagelist)")
        self.result.longDescription.add("Test Outcomes: \(resultCondition)")
        self.result.longDescription.add("Test Times: \(resultTime)")
        self.result.rounds = self.curr
        
        debugPrint("resultImages: \(self.resultImages.count)")
        debugPrint("screenshot: \(self.result.screenshot.count)")
        for shot in self.resultImages {
            self.result.screenshot.append(shot)
        }
        
        for item in self.imagelist {
            self.result.originalImages.append(item)
        }
        
        self.result.numErrors = 0
        self.result.numCorrects = 0
        for (index, element) in self.resultCondition.enumerated() {
            self.result.json[imagelist[index]] = ["correct":element, "drawing time (msec)":Int(1000*resultTime[index])]
            if element == false {
                self.result.numErrors += 1
            } else {
                 self.result.numCorrects += 1
            }
        }
        
        resultsArray.add(self.result)
        Status[Test3DFigureCopy] = TestStatus.Done
        self.resultCondition.removeAll()
        self.resultImages.removeAll()
        self.resultTime.removeAll()
    }
    
    fileprivate func completeTask() {
        // Check if is in quickStart mode
        guard !quickStartModeOn else {
            QuickStartManager.showAlertCompletion(viewController: self, cancel: {
                self.didBackToResult?()
            }, ok: {
                self.didCompleted?()
            })
            return
        }
        
        let alert = UIAlertController(title: "Quit", message: "You complete the test '3D Figure Copy'", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func drawImage() {
        //BUGBUG: This should not happen after the last result when the results are generated. However, for some reason, then the last drawn image is missing in the results! this will fix it.
        let img = drawCustomImage(self.vDraw.size)
        self.resultImages.append(img)
        
        if self.ivDraw != nil {
            self.ivDraw.image = nil
        }
        
        if self.curr < self.imagelist.count {
            let image = UIImage(named: self.imagelist[self.curr])
            self.ivDraw.image = image
        }
        else {
            if self.mode == .admin {
                self.NextButton.isEnabled = false
            }
            else {
                self.CorrectButton.isEnabled = false
                self.IncorrectButton.isEnabled = false
            }
            self.timer3DFigureCopy.invalidate()
            
            self.saveResult()
            self.completeTask()
        }
    }
    
    func drawCustomImage(_ size: CGSize) -> UIImage {
        // Setup our context
        //let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        //let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        //        drawing.drawandclearResults()  //background bubbles
        self.vDraw.drawandclearResults()
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// MARK: - 3DFigureDraw View Delgate
extension ThreeDFigureCopy: ThreeDFigureDrawDelgate {
    func isTouchDrawing() {
        self.lblDescDraw.isHidden = true
    }
}
