//
//  DigitSpanBackward.swift
//  iBOCA
//
//  Created by saman on 6/11/17.
//  Copyright © 2017 sunspot. All rights reserved.
//

import Foundation

import UIKit

class DigitSpanBackward:DigitBothDirection {
    
    override func procesString(val: String) -> String {
        return String(val.reversed())
    }
    
    override func testInitialize() {
        testName =  TestName.BACKWARD_DIGIT_SPAN
        testStatus = TestBackwardsDigitSpan
    }
    
    override func levelStart() -> Int {
        return 3
    }
    
    override func levelEnd() -> Int {
        return 6
    }
}

