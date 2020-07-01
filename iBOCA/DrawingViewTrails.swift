//
//  DrawingViewTrails.swift
//  Integrated test v1
//
//  Created by School on 7/16/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//
import Foundation
import UIKit

class DrawingViewTrails: UIView {
    
    private var currPath = UIBezierPath()
    var errorPath = UIBezierPath()
    var mainPath = UIBezierPath()
    var intersectCheckingPath = UIBezierPath() // Use for detecting drawing line is intersect with existing ones or not
    var cutPathInBubble = UIBezierPath() // 
    
    var isTouching: Bool = false
    var lastTouch: UITouch?
    var isMovingInsideBubble: Bool = false
    
    var startTime = Foundation.Date()
    var resultpath: [String:Any] = [:]
    
    var bubbles: BubblesA!
    
    var isPracticeTests: Bool = true
    
    var nextBubb = 0
    
    var incorrect = 0
    var incorrectlist:[String] = []
    
    func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(NSEC_PER_SEC)) {
            closure()
        }
    }
    
    //ADDITION
    var paths = [UIBezierPath]()
    var countSinceCorrect = 0
    var canDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        debugPrint("Initializing")
    }
    
    init(frame: CGRect, isPracticeTests: Bool) {
        super.init(frame: frame)
        debugPrint("View Trails")
        debugPrint("Left: \(frame.origin.x)")
        debugPrint("Top: \(frame.origin.y)")
        debugPrint("Right: \(frame.origin.x + frame.size.width)")
        debugPrint("Bottom: \(frame.origin.y + frame.size.height)")
        self.bubbles = BubblesA.init(withPracticeTest: isPracticeTests)
        self.bubbles.parentFrame = frame
        self.isPracticeTests = isPracticeTests
        setupView()
        debugPrint("Initializing")
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.white
        currPath.lineWidth = 5
        currPath.lineCapStyle = CGLineCap.round
        
        mainPath.lineWidth = 5
        mainPath.lineCapStyle = CGLineCap.round
        
        errorPath.lineWidth = 3
        errorPath.lineCapStyle = CGLineCap.round
    }
    
    
    func drawResultBackground() {
        for bubble in bubbles.bubblelist {
            drawBubble(bubble: bubble)
        }
        UIColor.black.set()
        isOpaque = false
        backgroundColor = nil
        
        //ADDITION
        debugPrint("should have drawn colored bezierpath")
        debugPrint("paths has \(paths.count) members; timedConnectionsA length is \(timedConnectionsA.count)")
        
        if (timedConnectionsA.count > 0){
            for k in 1 ..< timedConnectionsA.count {
                let z = timedConnectionsA[k] - timedConnectionsA[k-1]
                
                getColor2(i: z, alpha: 0.8).set()
                
                if k < paths.count {
                    let path : UIBezierPath = paths[k]
                    
                    path.lineWidth = 7
                    path.lineCapStyle = CGLineCap.round
                    
                    path.stroke()
                }
            }
            
        }
        
        UIColor.blue.set()
        errorPath.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        debugPrint("in drawRect")
        
        for bubble in bubbles.bubblelist {
            drawBubble(bubble: bubble)
        }
        
        UIColor.black.set()
        isOpaque = false
        backgroundColor = nil
        currPath.stroke()
        mainPath.stroke()
        UIColor.blue.set()
        errorPath.stroke()
        debugPrint("DoneDrawRect")
    }
    
    func reset() {
        debugPrint("In reset")
        mainPath.removeAllPoints()
        currPath.removeAllPoints()
        errorPath.removeAllPoints()
        
        startTime = Foundation.Date()
        setNeedsDisplay()
    }
    
    func drawBubble(bubble:(String, Int, Int)) {
        //println("in drawbubble")
        
        let (name, x, y) = bubble
        //println("Bubble \(bubble)")
        
        let context = UIGraphicsGetCurrentContext();
        
        // Set background color fill
        context!.saveGState()
        context!.setFillColor(Color.color(hexString: "#F5FAFD").cgColor)
        context!.setStrokeColor(bubbleColor!.cgColor)
        context!.addArc(center:CGPoint(x:CGFloat(x), y:CGFloat(y)), radius:CGFloat(30.0), startAngle:CGFloat(0), endAngle:CGFloat(Double.pi * 2.0), clockwise:true)
        context!.fillPath()
        context!.restoreGState()
        
        context!.saveGState()
        // Set the circle outerline-width
        context!.setLineWidth(3.0);

        // Set the circle outerline-colour
        bubbleColor!.setStroke()

        // Create Circle
        context?.addArc(center:CGPoint(x:CGFloat(x), y:CGFloat(y)), radius:CGFloat(30.0), startAngle:CGFloat(0), endAngle:CGFloat(Double.pi * 2.0), clockwise:true)

        // Draw
        context!.strokePath()
        context!.restoreGState()
        
        // Now for the text
        
        

        // Flip the context coordinates, in iOS only.
        //CGContextTranslateCTM(context, 0, self.bounds.size.height);
        //CGContextScaleCTM(context, 1.0, -1.0);

        let aFont = Font.font(name: Font.Montserrat.semiBold, size: 22.0)//UIFont(name: "Menlo-Bold", size: 24)
        // create a dictionary of attributes to be applied to the string
        let attr = [NSAttributedString.Key.font:aFont,NSAttributedString.Key.foregroundColor:UIColor.black]
        // create the attributed string
        let text = CFAttributedStringCreate(nil, name as CFString, attr as CFDictionary)
        // create the line of text
        let line = CTLineCreateWithAttributedString(text!)

       context?.textMatrix = CGAffineTransform(rotationAngle: CGFloat.pi).scaledBy(x: -1, y: 1)

        let num = name.count

        if num == 1 {
            context?.textPosition = CGPoint(x:CGFloat(x-7), y:CGFloat(y+8))
        }
        else {
            context?.textPosition = CGPoint(x:CGFloat(x-10), y:CGFloat(y+8))
        }

        CTLineDraw(line, context!)

        if (name == "1") {
            let aFont = Font.font(name: Font.Montserrat.semiBold, size: 18.0)//UIFont(name: "Menlo", size: 19)
            let attr = [NSAttributedString.Key.font:aFont,NSAttributedString.Key.foregroundColor:UIColor.black]
            let text = CFAttributedStringCreate(nil, "Start" as CFString, attr as CFDictionary)
            let line = CTLineCreateWithAttributedString(text!)

            context?.textPosition = CGPoint(x:CGFloat(x-25), y:CGFloat(y+60))
            CTLineDraw(line, context!)
        }

        // Practice Tests
        if self.isPracticeTests == true && name == "b" {
            let aFont = Font.font(name: Font.Montserrat.semiBold, size: 18.0)//UIFont(name: "Menlo", size: 19)
            let attr = [NSAttributedString.Key.font:aFont,NSAttributedString.Key.foregroundColor:UIColor.black]
            let text = CFAttributedStringCreate(nil, "End" as CFString, attr as CFDictionary)
            let line = CTLineCreateWithAttributedString(text!)

            context?.textPosition = CGPoint(x:CGFloat(x-18), y:CGFloat(y+60))
            CTLineDraw(line, context!)
        }

        if self.isPracticeTests == false && (TrailsTests[selectedTest].1[numBubbles-1].0 == name) {
            let aFont = Font.font(name: Font.Montserrat.semiBold, size: 18.0)//UIFont(name: "Menlo", size: 19)
            let attr = [NSAttributedString.Key.font:aFont,NSAttributedString.Key.foregroundColor:UIColor.black]
            let text = CFAttributedStringCreate(nil, "End" as CFString, attr as CFDictionary)
            let line = CTLineCreateWithAttributedString(text!)

            context?.textPosition = CGPoint(x:CGFloat(x-18), y:CGFloat(y+60))
            CTLineDraw(line, context!)
        }
    }
    
    func handleBubbleWithDragging(touch: UITouch) {
        var action = "Moveto"
                if bubbles.inNewBubble(x: touch.location(in: self).x, y:touch.location(in: self).y) == true {
                    
                    if bubbles.inCorrectBubble() == true {
                        
                        //ADDITION
                        if bubbles.currentBubble == nextBubb {
                            
                            
                            var p = UIBezierPath()
                            p = UIBezierPath(cgPath: currPath.cgPath)
                            paths.append(p)
                            
                            debugPrint("paths added member; length is \(paths.count); currBubb = \(bubbles.currentBubble); nextBubb = \(bubbles.nextBubble)")
                            nextBubb += 1
                            action = "Moveto next bubble \(bubbles.currentBubble)"
                        } else {
        //                    var p = UIBezierPath()
        //                    p = UIBezierPath(cgPath: currPath.cgPath)
        //                    errorPath.append(p)
//                            action = "Moveto not next bubble \(bubbles.currentBubble)"
                        }
                        
                        currPath.removeAllPoints()
                        currPath.move(to: touch.location(in: self))
                        debugPrint("in correct bubble")
                        
                    } else {
        //                self.errorPath.append(UIBezierPath(cgPath: self.currPath.cgPath))
        //                currPath.removeAllPoints()
                        self.canDraw = false
        //                self.incorrect += 1
        //                action = "Moveto incorrect bubble \(bubbles.currentBubble)"
                    }
                }
                let loc = touch.location(in: self)
                resultpath[String(Foundation.Date().timeIntervalSince(startTime))] = ["x":loc.x, "y":loc.y, "status":action]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if nextBubb != bubbles.bubblelist.count {
            canDraw = true
        }
        
        mainPath.append(cutPathInBubble)
        intersectCheckingPath.removeAllPoints()
        cutPathInBubble.removeAllPoints()
        currPath.removeAllPoints()
        
        let touch = touches.first! as UITouch
        currPath.move(to: touch.location(in: self))
        intersectCheckingPath.move(to: touch.location(in: self))
        
        setNeedsDisplay()
        
        isTouching = true
        lastTouch = touch
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // First touch that has movement
        if isTouching, let lastTouch = self.lastTouch {
            isTouching = false
            handleBubbleWithDragging(touch: lastTouch)
            self.lastTouch = nil
        }
        
        // Continue touching with movement
        let touch = touches.first! as UITouch
        if canDraw == true {
            currPath.addLine(to: touch.location(in: self))
            intersectCheckingPath.addLine(to: touch.location(in: self))
            cutPathInBubble.addLine(to: touch.location(in: self))
            setNeedsDisplay()
            
            var action = "Lineto"
            if bubbles.inNewBubble(x: touch.location(in: self).x, y:touch.location(in: self).y) == true {
                debugPrint("in a new bubble")
                
                if bubbles.inCorrectBubble() == true {
                    mainPath.append(UIBezierPath(cgPath: currPath.cgPath))
                    
                    //ADDITION
                    if bubbles.currentBubble == nextBubb {
                        var p = UIBezierPath()
                        p = UIBezierPath(cgPath: currPath.cgPath)
                        paths.append(p)
                
                        debugPrint("paths added member; length is \(paths.count); currBubb = \(bubbles.currentBubble); nextBubb = \(bubbles.nextBubble)")
                        nextBubb += 1
                        action = "Lineto next bubble \(bubbles.currentBubble)"
                    } else {
//                        var p = UIBezierPath()
//                        p = UIBezierPath(cgPath: currPath.cgPath)
                        
//                        errorPath.append(p)
                        currPath.removeAllPoints()
                        
                        action = "Lineto not next bubble \(bubbles.currentBubble)"
                    }
                    
                    currPath.removeAllPoints()
//                    intersectCheckingPath.removeAllPoints()
                    cutPathInBubble.removeAllPoints()
                    
                    currPath.move(to: touch.location(in: self))
                    cutPathInBubble.move(to: touch.location(in: self))
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
//                        self.intersectCheckingPath.move(to: touch.location(in: self))
//                    }
                    debugPrint("in correct bubble")
                } else {
                    debugPrint("In INCORRECT BUBBLE =========")

                    errorPath.append(UIBezierPath(cgPath: currPath.cgPath))
                    currPath.removeAllPoints()
                    cutPathInBubble.removeAllPoints()
                    canDraw = false
//                    debugPrint("should have removed all pts")
                    incorrect += 1
                    incorrectlist.append("\(bubbles.lastBubble)->\(bubbles.currentBubble)")
                    action = "Lineto incorrect bubble \(bubbles.currentBubble)"
                }
            }
            else if bubbles.inCurrentBubble(x: touch.location(in: self).x, y:touch.location(in: self).y) {
                isMovingInsideBubble = true
            }
            else {
                if isMovingInsideBubble {
                    isMovingInsideBubble = false
                    intersectCheckingPath.removeAllPoints()
                    intersectCheckingPath.move(to: touch.location(in: self))
                }
                
                
                if intersectCheckingPath.isEmpty {
                    intersectCheckingPath = currPath
                }
                var objBool: ObjCBool = true
                
                let result = intersectCheckingPath.findIntersections(withClosedPath: mainPath, andBeginsInside: &objBool)
                if let rs = result, rs.count > 0 {
                    errorPath.append(UIBezierPath(cgPath: currPath.cgPath))
                    currPath.removeAllPoints()
                    cutPathInBubble.removeAllPoints()
                    intersectCheckingPath.removeAllPoints()
                    canDraw = false

                    incorrect += 1
                    incorrectlist.append("\(bubbles.lastBubble)->\(bubbles.currentBubble)")
                    action = "Lineto incorrect bubble \(bubbles.currentBubble)"
                    setNeedsDisplay()
                }
            }
            let loc = touch.location(in: self)
            resultpath[String(Foundation.Date().timeIntervalSince(startTime))] = ["x":loc.x, "y":loc.y, "status":action]
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //println("Touch Ended")
        
    }
    
    func getColor2(i: Double, alpha: Double = 1.0) -> UIColor {
        if (i < 5.0) {
            let h = CGFloat(0.3 - i / 15.0)
            return UIColor(hue: h, saturation: 1.0, brightness: 1.0, alpha: CGFloat(alpha))
        } else if (i < 60) {
            let b = CGFloat((60.0 - i)/55.0)
            return UIColor(hue: 0.0, saturation: 1.0, brightness: b, alpha: CGFloat(alpha))
        } else {
            return UIColor(hue: 0.0, saturation: 1.0, brightness: 0.0, alpha: CGFloat(alpha))
        }
    }
    
}
