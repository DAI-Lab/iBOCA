//
//  DigitSerialSeven.swift
//  iBOCA
//
//  Created by saman on 6/16/17.
//  Copyright © 2017 sunspot. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class DigitSerialSeven:DigitBaseClass {
    var startNum = 0
    var lastNum = 0
    let MAXLEVEL = 7
    var genval:String = ""
    
    var enteredNumber:[Int] = []
    var expectedNumber:[Int] = []
    var sequenceNumber:[Int] = []
    var gotTime:[Date] = []
    var totErrors = 0
    var totCorrects = 0
    var round = 0
    var keys : [[String:String]] = [[:]]
    
    var timer: Timer?
    var countdownTime: Int = 6
    var randomNumber: Int = 50
    
    override func doStart() {
        testStatus = TestSerialSevens
        level = -1
        // Get a random integer from 60 to 100
        let randomStartingNumber = Int.random(in: 60 ... 100)
        debugPrint("Starting Number: \(randomStartingNumber)")
        
        // Reset countdown time every starting
        countdownTime = 6
        randomNumber = randomStartingNumber
        base.showRandomNumberLabel.isHidden = false
        base.isNumKeyboardHidden(isHidden: false)
        base.numKeyboard.isEnabled(true)
        base.randomNumberLabel.text = "\(randomNumber)"
        base.keypadLabel.text = ""
        self.startTheTest(startingNumber: self.randomNumber)
        
        startTime = Foundation.Date()
        
        enteredNumber = []
        expectedNumber = []
        sequenceNumber = []
        gotTime = []
        totErrors = 0
        totCorrects = 0
        keys = []
    }
    
    private func startTheTest(startingNumber: Int) {
        startNum = startingNumber
        lastNum = startNum
        level = 0
        base.isNumKeyboardHidden(isHidden: false)
        
        levelStartTime = Foundation.Date()
        
        base.infoLabel.text = "Ask patient for the starting number minus 7 and then enter it"
    }
    
    @objc fileprivate func StartNumberButtonTapped(button: UIButton){
        startNum = Int(button.title(for: .normal)!)!
        lastNum = startNum
        level = 0
        
        base.isNumKeyboardHidden(isHidden: false)
        self.base.showRandomNumberLabel.isHidden = false
        
        levelStartTime = Foundation.Date()
        
        base.infoLabel.text = "Enter the start number minus 7"
    }
    
    override func doEnterDone() {
        if level == -1 {
            // Should not get here....
        } else {
            // Middle of the test
            guard let num = Int(base.keypadLabel.text!) else {
                base.infoLabel.text = "Error: Enter a number"
                return
            }
            
            level += 1
            base.keypadLabel.text = ""
            base.value = ""
            if num == lastNum - 7 && num == startNum - 7 * level {
                totCorrects += 1
                base.infoLabel.text = "Correct: Ask patient for number minus 7, Enter it"
            } else  if num == lastNum - 7 {
                totCorrects += 1
                base.infoLabel.text = "Correct, but off the sequence: Ask patient for number minus 7, Enter it"
            } else {
                totErrors += 1
                base.infoLabel.text = "Incorrect subtraction: Ask patient for number minus 7 and enter it.\nYour answer: \(num)"
            }
            
            round += 1
            enteredNumber.append(num)
            expectedNumber.append(lastNum - 7)
            sequenceNumber.append(startNum - 7*level)
            keys.append(gotKeys)
            gotTime.append(Foundation.Date())
            
            debugPrint("num \(num)")
            debugPrint("startNum \(startNum)")
            debugPrint("lastNum \(lastNum)")
            debugPrint("expectedNumber \(lastNum - 7)")
            debugPrint("sequenceNumber \(startNum - 7*level)")
            debugPrint("gotKeys \(gotKeys)")
            
            lastNum = num
        }
        
        if (level >= 7) || (lastNum - 7 <= 0)  {
            // Done test
            base.infoLabel.text = "Test Ended"
            base.startTimeTask = Foundation.Date()
            base.totalTimeCounter.invalidate()
            base.numKeyboard.isEnabled(false)
            doEnd()
            return
        }
    }
    
    override func doEnd() {
        timer?.invalidate()
        
        let endTime = Foundation.Date()
        
        let result = Results()
        result.name = TestName.SERIAL_SEVENS
        result.startTime = startTime
        result.endTime = endTime
        
        result.json["Starting Number"] = startNum
        result.numCorrects = totCorrects
        result.numErrors = totErrors
        result.rounds = round >= 7 ? MAXLEVEL : round
        var resultList : [Int:Any] = [:]
        var sttime = levelStartTime
        for (i, l) in enteredNumber.enumerated() {
            var res : [String:Any] = [:]
            
            let elapsedTime = (Int)(1000*gotTime[i].timeIntervalSince(sttime))
            sttime = gotTime[i]
            res["time (msec)"] = elapsedTime
            res["Entered"] = l
            res["Subtract 7"] = expectedNumber[i]
            res["Sequence 7"] = sequenceNumber[i]
            resultList[i] = res
//            result.longDescription.add("\(i): \(enteredNumber[i]) --> Subtract 7: \(expectedNumber[i]) (Sequence 7: \(sequenceNumber[i]))  (\(elapsedTime) msec)")
        }
        var numberSequence = "Starting with \(startNum) --> ("
        for i in 0...expectedNumber.count - 1 {
            if i == expectedNumber.count - 1 {
                numberSequence.append("\(expectedNumber[i]))")
            } else {
                numberSequence.append("\(expectedNumber[i]), ")
            }
        }
        
        result.longDescription.add(numberSequence)
        result.json["Results"] = resultList
        result.json["Errors"] = totErrors
        result.json["Rounds"] = level >= 7 ? MAXLEVEL : level
        
        result.shortDescription = "\(startNum)->\(enteredNumber) sequence, \(level) rounds with \(totErrors) errors"
        
        resultsArray.add(result)
        Status[testStatus] = TestStatus.Done
        
        base.infoLabel.text = "Test ended"
        base.endTest()
    }
}
