//
//  BubblesA.swift
//  Integrated test v1
//
//  Created by School on 7/16/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//

import Foundation
import UIKit
let PracticeTests: (String, [(String, Int, Int)]) = ("Practice",[("1", 810, 230),
                                                                ("a", 710, 195),
                                                                ("2", 420, 200),
                                                                ("b", 300, 80),
                                                                ("3", 375, 330)])
let TrailsTests : [(String, [(String, Int, Int)])] =
    [("Trails B0", [("1", 695, 325),
                    ("a", 820, 280),
                    ("2", 840, 400),
                    ("b", 590, 410),
                    ("3", 520, 285),
                    ("c", 350, 230),
                    ("4", 450, 380),
                    ("d", 250, 405),
                    ("5", 70, 410),
                    ("e", 90, 320),
                    ("6", 230, 270),
                    ("f", 60, 140),
                    ("7", 170, 40),
                    ("g", 450, 65),
                    ("8", 675, 40),
                    ("h", 820, 125),
                    ("9", 700, 220),
                    ("i", 600, 160),
                    ("10", 410, 150),
                    ("j", 240, 170)]),
     ("Trails B1", [("1", 170, 250),
                    ("a", 40, 200),
                    ("2", 150, 30),
                    ("b", 680, 10),
                    ("3", 520, 120),
                    ("c", 830, 50),
                    ("4", 850, 215),
                    ("d", 730, 250),
                    ("5", 395, 165),
                    ("e", 430, 400),
                    ("6", 600, 300),
                    ("f", 820, 400),
                    ("7", 830, 565),
                    ("g", 500, 580),
                    ("8", 600, 465),
                    ("h", 160, 565),
                    ("9", 240, 465),
                    ("i", 40, 430),
                    ("10", 280, 325),
                    ("j", 260, 120)]),
     ("Trails B2", [("1", 450, 420),
                    ("a", 420, 145),
                    ("2", 840, 380),
                    ("b", 760, 215),
                    ("3", 970, 105),
                    ("c", 590, 120),
                    ("4", 850, 40),
                    ("d", 170, 50),
                    ("5", 40, 245),
                    ("e", 30, 380),
                    ("6", 190, 180),
                    ("f", 310, 300),
                    ("7", 150, 400),
                    ("g", 290, 480),
                    ("8", 110, 560),
                    ("h", 580, 525),
                    ("9", 500, 600),
                    ("i", 920, 565),
                    ("10",770, 510),
                    ("j", 640, 370)]),
     ("Trails B3", [("1", 215, 140),
                    ("a", 370, 260),
                    ("2", 70, 450),
                    ("b", 290, 450),
                    ("3", 180, 540),
                    ("c", 780, 500),
                    ("4", 500, 580),
                    ("d", 970, 565),
                    ("5",950, 300),
                    ("e", 710, 380),
                    ("6", 465, 420),
                    ("f", 420, 105),
                    ("7", 575, 295),
                    ("g", 780, 215),
                    ("8", 970, 105),
                    ("h", 600, 110),
                    ("9", 850, 40),
                    ("i", 70, 50),
                    ("10", 40, 245),
                    ("j", 170, 280),]),
     ("Trails B4", [("1", 400, 150),
                    ("a", 350, 320),
                    ("2", 150, 550),
                    ("b", 50, 350),
                    ("3", 120, 190),
                    ("c", 30, 20),
                    ("4", 250, 20),
                    ("d", 850, 20),
                    ("5", 950, 150),
                    ("e", 700, 170),
                    ("6", 550, 100),
                    ("f", 580, 270),
                    ("7", 480, 420),
                    ("g", 310, 480),
                    ("8", 510, 570),
                    ("h", 670, 400),
                    ("9", 840, 300),
                    ("i", 950, 540),
                    ("10", 700, 540),
                    ("j", 810, 440)]),
     ("Trails B5", [("1", 750, 450),
                    ("a", 640, 580),
                    ("2", 950, 540),
                    ("b", 850, 300),
                    ("3", 650, 340),
                    ("c", 450, 470),
                    ("4", 310, 550),
                    ("d", 400, 180),
                    ("5", 500, 300),
                    ("e", 540, 120),
                    ("6", 700, 200),
                    ("f", 920, 150),
                    ("7", 750, 40),
                    ("g", 320, 50),
                    ("8", 30, 20),
                    ("h", 130, 210),
                    ("9", 50, 425),
                    ("i", 150, 550),
                    ("10",250, 390),
                    ("j", 250, 150)]),
     ("Trails B6", [("1", 520, 330),
                    ("a", 680, 350),
                    ("2", 670, 140),
                    ("b", 200, 130),
                    ("3", 410, 230),
                    ("c", 340, 350),
                    ("4", 130, 360),
                    ("d", 320, 520),
                    ("5", 500, 485),
                    ("e", 900, 400),
                    ("6", 820, 280),
                    ("f", 900, 150),
                    ("7", 780, 50),
                    ("g", 520, 80),
                    ("8", 320, 80),
                    ("h", 80, 50),
                    ("9", 200, 270),
                    ("i",  50, 200),
                    ("10", 60, 480),
                    ("j", 190, 490),
                    ("11",920, 500),
                    ("k", 920, 40),
                    ("12",700, 50),
                    ("l", 830, 80)]),
     ("Trails B7", [("1",280, 390),
                    ("a", 250, 210),
                    ("2", 160, 530),
                    ("b", 40, 425),
                    ("3", 30, 90),
                    ("c", 130, 190),
                    ("4", 320, 50),
                    ("d", 750, 40),
                    ("5", 920, 150),
                    ("e", 700, 200),
                    ("6", 540, 140),
                    ("f", 460, 300),
                    ("7", 400, 160),
                    ("g", 310, 550),
                    ("8", 490, 440),
                    ("h", 650, 350),
                    ("9", 640, 540),
                    ("i", 820, 300),
                    ("10", 810, 435),
                    ("j", 950, 500)]),
     ("Trails B8", [("1", 520, 285),
                    ("a", 445, 185),
                    ("2", 320, 80),
                    ("b", 570, 190),
                    ("3", 720, 210),
                    ("c", 675, 80),
                    ("4", 500, 45),
                    ("d", 170, 40),
                    ("5", 60, 140),
                    ("e", 225, 180),
                    ("6", 240, 295),
                    ("f", 70, 275),
                    ("7", 120, 375),
                    ("g", 330, 405),
                    ("8", 330, 260),
                    ("h", 450, 380),
                    ("9", 590, 410),
                    ("i", 840, 400),
                    ("10", 820, 280),
                    ("j", 695, 325)]),
     ("Trails B9", [("1", 750, 360),
                    ("a",950, 260),
                    ("2", 970, 565),
                    ("b", 540, 600),
                    ("3", 730, 505),
                    ("c", 290, 520),
                    ("4", 110, 560),
                    ("d", 150, 410),
                    ("5", 480, 305),
                    ("e", 190, 180),
                    ("6", 290, 300),
                    ("f", 40, 245),
                    ("7", 170, 50),
                    ("g", 700, 35),
                    ("8", 590, 120),
                    ("h", 970, 105),
                    ("9", 760, 215),
                    ("i", 420, 145),
                    ("10", 600, 355),
                    ("j", 430, 410),])]



class BubblesA {
    var bubblelist : [(String, Int,Int)] = []
    let radius = 20
    
    var currentBubble = -1
    var lastBubble = -1
    
    var nextBubble = 0
    
    var seqCount = 0
    
    var segmenttimes:[(Int, String, Int)] = []
    var jsontimes : [String:Any] = [:]
    
    var startTime = Foundation.Date()
    
    // Frame the bubbles within the bounding box
    // first get the bounding box
    var xmin = 982//1000
    var xmax = 42//9
    var ymin = 721//1000
    var ymax = 133//0
    
    var parentFrame: CGRect? {
        didSet {
            if let frame = parentFrame {
                self.xmin = Int(frame.origin.x + frame.size.width)
                self.xmax = Int(frame.origin.x)
                self.ymin = Int(frame.origin.y + frame.size.height)
                self.ymax = Int(frame.origin.y)
            }
        }
    }
    
    func getrange() {
        for (_, x, y) in bubblelist {
            xmin = min(x, xmin)
            xmax = max(x, xmax)
            ymin = min(y, ymin)
            ymax = max(y, ymax)
        }
    }
    
    //Rotate (180 degrees) or mirror (on x or y) the point
    var xt:Bool = false
    var yt:Bool = false
    
    func transform(coord:(String, Int, Int)) -> (String, Int, Int) {
        var x = coord.1
        var y = coord.2
        
        // frame the bubbles within the bounding box
        let bcount = (29 - bubblelist.count) * 5//(24 - bubblelist.count) * 5 // more bubbles, larger area
        
        // Check Division by zero
        if (xmax - xmin) != 0 {
            x = ((x - xmin)*(950-60-2*bcount)/(xmax - xmin)) + bcount + 40
        }
        
        // Check Division by zero
        if (ymax - ymin) != 0 {
            var paddingItem = 40
            if ScreenSize.SCREEN_MAX_LENGTH == 1194.0 {
                // ipad pro 11 inch
                paddingItem = 0
            }
            y = ((y - ymin)*(580-60-2*bcount)/(ymax - ymin)) + bcount + paddingItem
        }
        
        if xt  {
            x  = xmax - x//1010 - x
        }
        
        if yt {
            y = ymin - y//625 - y
        }
        
        return (coord.0, x, y)
    }
    
    
    init() {
        for i in 0...numBubbles-1 {
            bubblelist.append(TrailsTests[selectedTest].1[i])
        }
        getrange()
        bubblelist = bubblelist.map(transform)
        startTime = Foundation.Date()
        jsontimes.removeAll()
        segmenttimes.removeAll()
        seqCount = 0
    }
    
    init(withPracticeTest isPracticeTest: Bool) {
        if isPracticeTest == true {
            for i in 0...3 {
                bubblelist.append(PracticeTests.1[i])
            }
        }
        else {
            for i in 0...numBubbles-1 {
                bubblelist.append(TrailsTests[selectedTest].1[i])
            }
        }
        getrange()
        bubblelist = bubblelist.map(transform)
        startTime = Foundation.Date()
        jsontimes.removeAll()
        segmenttimes.removeAll()
        seqCount = 0
    }
    
    
    func inBubble(x:CGFloat, y:CGFloat)->Int{
        
        for (index,bubble) in bubblelist.enumerated(){
            let (_, a, b) = bubble
            
//            let z = (x-CGFloat(a))*(x-CGFloat(a)) + (y-CGFloat(b))*(y-CGFloat(b))

//            if z <= 700.0 {
//                //println("inside bubble " + name)
//                return index
//            }
            if abs(x-CGFloat(a)) <= 29 && abs(y-CGFloat(b)) <= 29 {
                return index
            }
            
        }
        
        return -1
    }
    
    func inNewBubble(x:CGFloat, y:CGFloat) -> Bool {
        let curr = inBubble(x: x, y:y)
        if curr == currentBubble {
            return false
        }
        if curr == -1 {
            return false
        }
        debugPrint("Found new bubble \(curr)")
        
        lastBubble = currentBubble
        currentBubble = curr
        
        seqCount += 1
        return true
        
    }
    
    func inCurrentBubble(x:CGFloat, y:CGFloat) -> Bool {
        let curr = inBubble(x: x, y:y)
        return curr == currentBubble
    }
    
    func inCorrectBubble()->Bool{
        let currTime = Foundation.Date()
        // the path has to start with the previous end of selection and go to the one higher than that
        if (currentBubble == nextBubble) && (lastBubble == nextBubble - 1){
            
            nextBubble += 1
            
            if nextBubble == bubblelist.count {
                debugPrint("Done")
                nextBubble = 0
                stopTrailsA = true
                displayImgTrailsA = true
            }
            
            segmenttimes.append((Int(timePassedTrailsA), "\(lastBubble)->\(currentBubble):OK ", Int(1000*currTime.timeIntervalSince(startTime))))
            jsontimes[String(seqCount-1)] = ["Start":lastBubble, "End":currentBubble, "Correct":true, "Time (ms)":Int(1000*currTime.timeIntervalSince(startTime))]
            
            timedConnectionsA.append(timePassedTrailsA)
            return true
            
        }
        
        if currentBubble == nextBubble-1 {
            segmenttimes.append((Int(timePassedTrailsA), "\(lastBubble)->\(currentBubble):OK ", Int(1000*currTime.timeIntervalSince(startTime))))
            jsontimes[String(seqCount-1)] = ["Start":lastBubble, "End":currentBubble, "Correct":true, "Time (ms)":Int(1000*currTime.timeIntervalSince(startTime))]

            return true
            
        }
        
        segmenttimes.append((Int(timePassedTrailsA), "\(lastBubble)->\(currentBubble):OK ", Int(1000*currTime.timeIntervalSince(startTime))))
        jsontimes[String(seqCount-1)] = ["Start":lastBubble, "End":currentBubble, "Correct":false, "Time (ms)":Int(1000*currTime.timeIntervalSince(startTime))]
        
        currentBubble = lastBubble
        return false
    }
    
    
    
}
