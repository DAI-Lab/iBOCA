//
//  SemanticListGeneration.swift
//  iBOCA
//
//  Created by Seth Amarasinghe on 9/5/16.
//  Copyright © 2016 sunspot. All rights reserved.
//

import UIKit
var Category : String?

class SemanticListGeneration: BaseViewController, UIPickerViewDelegate {
    var counter = 30
    var myTimer : Timer = Timer()
    
    var resCorrect = 0
    var resIncorrect = 0
    var resRepeat = 0
    
    var resultStatus : [String] = []
    var resultTime : [Date] = []
    
    var startTime = Foundation.Date()
    
    @IBOutlet weak var CorrectButton: UIButton!
    @IBOutlet weak var IncorrectButton: UIButton!
    @IBOutlet weak var RepeatButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var SelectLabel: UILabel!
    @IBOutlet weak var ResultLabel: UILabel!
    
    @IBOutlet weak var CategoryPicker: UIPickerView!
    let CategoryData = ["Animals", "Occupations", "Fruit", "Vegetables", "Clothing", "Furniture"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryPicker.delegate = self
        
        Category = CategoryData[CategoryPicker.selectedRow(inComponent: 0)]

        StartButton.isHidden = false
        //backButton.isHidden = false
        IncorrectButton.isHidden = true
        CorrectButton.isHidden = true
        RepeatButton.isHidden = true
        CategoryPicker.isHidden = false
        TimerLabel.isHidden = true
        SelectLabel.isHidden = false
        
        TimerLabel.text = ""
        ResultLabel.text = ""
    }
    
    
    @IBAction func StartPressed(_ sender: Any) {
        debugPrint(Category ?? "none")
        
        self.StartButton.isHidden = true
        //BackButton.isHidden = true
        IncorrectButton.isHidden = false
        CorrectButton.isHidden = false
        RepeatButton.isHidden = false
        CategoryPicker.isHidden = true
        TimerLabel.isHidden = false
        SelectLabel.isHidden = true
        
        startTime = Foundation.Date()
        resultStatus.removeAll()
        resultTime.removeAll()
        
        counter = 60
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        resCorrect = 0
        resIncorrect = 0
        resRepeat = 0
        ResultLabel.text = "Correct:\(resCorrect), Incorrect:\(resIncorrect), Repeat:\(resRepeat)"

    }
    
       
    
    @IBAction func correctPressed(_ sender: Any) {
        resCorrect += 1
        resultStatus.append("Correct")
        let currTime = Foundation.Date()
        resultTime.append(currTime)
        ResultLabel.text = "Correct:\(resCorrect), Incorrect:\(resIncorrect), Repeat:\(resRepeat)"
    }
    
    @IBAction func incorrectPressed(_ sender: Any) {
        resIncorrect += 1
        resultStatus.append("Incorrect")
        let currTime = Foundation.Date()
        resultTime.append(currTime)
        ResultLabel.text = "Correct:\(resCorrect), Incorrect:\(resIncorrect), Repeat:\(resRepeat)"
    }
    
    @IBAction func repeatPressed(_ sender: Any) {
        resRepeat += 1
        resultStatus.append("Repeat")
        let currTime = Foundation.Date()
        resultTime.append(currTime)
        ResultLabel.text = "Correct:\(resCorrect), Incorrect:\(resIncorrect), Repeat:\(resRepeat)"
    }
  
    
    func numberOfComponentsInPickerView(_ pickerView : UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == CategoryPicker {
            return CategoryData.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == CategoryPicker {
            Category = CategoryData[row]
            return CategoryData[row]
        } else {
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == CategoryPicker {
            Category = CategoryData[row]
        } else  {
        }
    }
    
    
    @objc func updateCounter() {
        //you code, this is an example
        if counter >= 0 {
            debugPrint("\(counter) seconds to the end of the world")
            let precnt = counter < 10 ? "0" : ""
            TimerLabel.text = "00:\(precnt)\(counter)"
            counter -= 1
        } else {
            myTimer.invalidate()
            debugPrint("Done timer")
            
            StartButton.isHidden = false
            //BackButton.isHidden = false
            IncorrectButton.isHidden = true
            CorrectButton.isHidden = true
            RepeatButton.isHidden = true
            CategoryPicker.isHidden = false
            TimerLabel.isHidden = true
            SelectLabel.isHidden = false
            
            let result = Results()
            result.name = "Semantic List Generation"
            result.startTime = startTime
            result.endTime = Foundation.Date()
            result.shortDescription = "Correct:\(resCorrect), Incorrect:\(resIncorrect), Repeat:\(resRepeat)"
            var js : [String:Any] = [:]
            for (index, element) in resultStatus.enumerated() {
                let val = ["status":element, "drawing time (msec)":Int(1000*resultTime[index].timeIntervalSince(startTime))] as [String : Any]
                js[String(index)] = val
            }
            result.json[Category!] = js
            result.numErrors = resIncorrect + resRepeat
            resultsArray.add(result)
            Status[TestSemanticListGeneration] = TestStatus.Done
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
