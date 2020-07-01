//
//  AllResults.swift
//  Integrated test v1
//
//  Created by saman on 8/16/15.
//  Copyright (c) 2015 sunspot. All rights reserved.
//

import UIKit
import MessageUI
import Security

class AllResults  {
    
    var results:NSMutableArray = NSMutableArray()
    
    var mode: TestMode = .admin
    
    // Get the results at # index
    func get(_ index: Int) -> Results {
        return results.object(at: index) as! Results
    }
    
    // add new results at end of the list
    func add(_ res:Results) {
        results.add(res)
    }
    
    // How many results are in the list
    func numResults() -> Int {
        return results.count
    }
    
    // Remove all the results
    func doneWithPatient() {
        debugPrint(toJson())
        results.removeAllObjects()
    }
    
    
    // convert theresults to an e-mail
    func emailBody() -> String {
        var e : String = ""
        
        e += "<head>\n"
        e += "<style>\n"
        e += "table { font-family: arial, sans-serif; border-collapse: collapse; }\n"
        e += "td, th { border: 1px solid #dddddd; text-align: left; padding: 8px; }\n"
        e += "tr:nth-child(even) { background-color: #dddddd; }\n"
        e += "</style>\n"
        e += "</head>\n"
        e += "<body>\n"
        e += "<h4>Patient ID : \(PID.getID())</h4>\n"
        e += "<h4>Tester : \(PID.getName())</h4>\n"
        if atBIDMCOn {
            e += "<h4>Done at BIDMC </h4>\n"
            e += "<h4>The Test Class: \(theTestClass) </h4>\n"
        }
        
        e += mode == .admin ? (adminTransmitOn ? "<h4>Results recorded to server</h4>\n" : "") : (proctoredTransmitOn ? "<h4>Results recorded to server</h4>\n" : "")
        
        if PUID != "" {
            e += "<h4>Patient Unique ID : \(PUID)</h4>\n"
        }
        
        if(Gender != nil) {
            e += "<h4>Gender:\(Gender!)</h4>\n"
        }
        
        if(age != nil) {
            e += "<h4>Age:\(age!)</h4>\n"
        }
        
        if(Education != nil) {
            e += "<h4>Education:\(Education!)</h4>\n"
        }
        
        if(Race != nil) {
            e += "<h4>Race:\(Race!)</h4>\n"
        }
        
        if(Ethnicity != nil) {
            e += "<h4>Ethnicity:\(Ethnicity!)</h4>\n<p>\n"
        }
        
        if(Comments != "") {
            e += "<h4>Tester Comments:\(Comments)</h4>\n<p>\n"
        }
        
        
          if(numResults() > 0) {
            e += "<p>\n"
             e += "<h2>Summary of Results</h2>\n<p>\n"
            e += "<table>\n"
            e += "<tr> <th>Test</th> <th>Errors</th> <th>Time(seconds)</th> <th>Description</th></tr>\n"
            

            for i in 0...numResults()-1 {
                let r = get(i)
                e += "<tr>\n <td>\(r.name!)</td>"
                if r.numErrors > 0 {
                    e += "<td> \(r.numErrors) </td>"
                } else {
                    e += "<td> No error </td>"
                }
                let elapsedTime = r.endTime!.timeIntervalSince(r.startTime! as Date)
                let duration = ((Double)((Int(1000*elapsedTime))))/1000.0
                e += "<td align=\"right\">\(duration)</td>"
                if r.shortDescription != nil {
                    e += "<td>\(r.shortDescription!)</td>"
                }

                e += "</tr>\n"

            }
            e += "</table>"
            e += "<p>\n"
        }
        
        
        // Iterate over the results
        if(numResults() > 0) {
            for i in 0...numResults()-1 {
                let r = get(i)
                e += "<h2>\(i+1)) \(r.name!)</h2><p>\n"
        
                if(r.primaryDescription != nil){
                    e += "<h4>\(r.primaryDescription!)</h4><p>\n"
                }
    
                if(r.shortDescription != nil){
                    e += "\(r.shortDescription!)<p>\n"
                }
                
                let elapsedTime = r.endTime!.timeIntervalSince(r.startTime! as Date)
                let duration = Int(elapsedTime)
                e += "\(duration) seconds taken. (Test run on \(r.startTime!))<p>\n"
                
                for objs in r.longDescription {
                    if let desc = objs as? String {
                        e += "\(desc)<p>\n"
                    }
                }
                
                for shot in r.screenshot {
                    let imageString = returnEmailStringBase64EncodedImage(shot)
                    e += "<img src='data:image/png;base64,\(imageString)' width='\(shot.size.width)' height='\(shot.size.height)'><p>\n"
                }
            }
        }
        
        // Put the time scale at the end of the e-mail
        let scaleImage = UIImage(named: "timescale")
        let imageString = returnEmailStringBase64EncodedImage(scaleImage!)
        e += "<p> <h3>scale</h3>\n"
        e += "<img src='data:image/png;base64,\(imageString)' width='\(scaleImage!.size.width)' height='\(scaleImage!.size.height)'><p>\n"
        
        e += "\n<p>\n" + toJson() + "\n<p>\n"
        e += "</body>\n"
        
        return e
    }
    
    
    func toJson() -> String {
        var e : String = ""
        var jst : [String:String] = [:]
        jst["Patient ID #"] = PID.getID()
        jst["Tester Name"] = PID.getName()
        jst["Done at BIDMC"] = String(atBIDMCOn)
        if atBIDMCOn {
            jst["The Test Class"] = String(theTestClass)
        }
        
        if PUID != "" {
            jst["Patient Unique ID"] = PUID
        }
        
        if(emailOn) {
            jst["Emailed to"] = emailAddress
        }
        
        if(Gender != nil) {
            jst["Gender"] = Gender!
        }
        
        if(age != nil) {
            jst["Age"] = age!
        }
        
        if(Education != nil) {
            jst["Education"] = Education!
        }
        
        if(Race != nil) {
            jst["Race"] = Race!
        }
        
        if(Ethnicity != nil) {
            jst["Ethnicity"] = Ethnicity!
        }
        
        if(Comments != "") {
            jst["Comments"] = Comments
        }
        
        
        var tst : [String:String] = [:]
        tst["Device Name"] = UIDevice.current.name
        tst["Device ID"] = UIDevice.current.identifierForVendor?.uuidString
        tst["Platform"] = platformString()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd HH:MM"
        tst["Test Start Time"] = formatter.string(from: testStartTime)
  
        let elapsedTime = (Int)(Foundation.Date().timeIntervalSince(testStartTime))
        tst["Test Duration"] = "\((Int)(elapsedTime/3600)):\((Int)(elapsedTime/60)%60):\(elapsedTime%60)"
        
        tst["iBOCA version"] = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0") + " (Build " +  (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0") + ")"

        e += "{ \"Setup\":" + sortedJson(dict: tst) + ", "
        e += "\"Demographics\":" + sortedJson(dict: jst)
        
        if numResults() > 0 {
            e += ", \"Tests\":["
            for i in 0...numResults()-1 {
                let r = get(i)
                if i > 0 {
                    e += ", "
                }
                e +=  "{\"" + r.name! + "\":" + sortedJson(dict: r.toJson()) + "}\n"
            }
            e += "]"
        }
        e += "}"
        return e;
    }
    
    // If a set of keys are Integers, sort them 
    func sortedJson(dict : [String:Any]) -> String {
        var ret = "{"
        var sorted = Array(dict).sorted(by: {$0.0 < $1.0})
        var isint: Bool = false
        if dict.count > 0 {
            isint = dict.keys.first!.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            if isint {
                sorted = Array(dict).sorted(by: {Int($0.0)! < Int($1.0)!})
            }
        }
        
        var start = true
        for (k,v) in sorted {
            if start {
                start = false
            } else {
                ret += ", "
            }
            
            let kk : String = "\"" + String(k) + "\""

            if v is [String:Any] {
                let vstr : String = kk + ":" + sortedJson(dict: v as! [String : Any])
                ret.append(vstr)
            } else  if v is [Int:Any] {
                let vv = v as! [Int:Any]
                var out:[String:Any] = [:]
                for k in vv.keys {
                    out[String(k)] = vv[k]
                }
                let vstr : String = kk + ":" + sortedJson(dict: out)
                ret.append(vstr)
            } else if v is Int {
                ret.append(kk + ":" + String(describing: v))
            } else {
                ret.append(kk + ":\"" + String(describing: v) + "\"")
            }
        }
        
        ret += "}"
        return ret
    }
    
    
    func returnEmailStringBase64EncodedImage(_ image:UIImage) -> String {
        //BUGBUG: Fix this!!
        let imgData:Data = image.pngData()!
        let dataString = imgData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return dataString
    }
    
    func platformString() -> String {
        
        var devSpec: String
        
        switch platform() {
            
        case "iPhone1,2": devSpec = "iPhone 3G"
        case "iPhone2,1": devSpec = "iPhone 3GS"
        case "iPhone3,1": devSpec = "iPhone 4"
        case "iPhone3,3": devSpec = "Verizon iPhone 4"
        case "iPhone4,1": devSpec = "iPhone 4S"
        case "iPhone5,1": devSpec = "iPhone 5 (GSM)"
        case "iPhone5,2": devSpec = "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3": devSpec = "iPhone 5c (GSM)"
        case "iPhone5,4": devSpec = "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1": devSpec = "iPhone 5s (GSM)"
        case "iPhone6,2": devSpec = "iPhone 5s (GSM+CDMA)"
        case "iPhone7,1": devSpec = "iPhone 6 Plus"
        case "iPhone7,2": devSpec = "iPhone 6"
        case "iPod1,1": devSpec = "iPod Touch 1G"
        case "iPod2,1": devSpec = "iPod Touch 2G"
        case "iPod3,1": devSpec = "iPod Touch 3G"
        case "iPod4,1": devSpec = "iPod Touch 4G"
        case "iPod5,1": devSpec = "iPod Touch 5G"
        case "iPad1,1": devSpec = "iPad"
        case "iPad2,1": devSpec = "iPad 2 (WiFi)"
        case "iPad2,2": devSpec = "iPad 2 (GSM)"
        case "iPad2,3": devSpec = "iPad 2 (CDMA)"
        case "iPad2,4": devSpec = "iPad 2 (WiFi)"
        case "iPad2,5": devSpec = "iPad Mini (WiFi)"
        case "iPad2,6": devSpec = "iPad Mini (GSM)"
        case "iPad2,7": devSpec = "iPad Mini (GSM+CDMA)"
        case "iPad3,1": devSpec = "iPad 3 (WiFi)"
        case "iPad3,2": devSpec = "iPad 3 (GSM+CDMA)"
        case "iPad3,3": devSpec = "iPad 3 (GSM)"
        case "iPad3,4": devSpec = "iPad 4 (WiFi)"
        case "iPad3,5": devSpec = "iPad 4 (GSM)"
        case "iPad3,6": devSpec = "iPad 4 (GSM+CDMA)"
        case "iPad4,1": devSpec = "iPad Air (WiFi)"
        case "iPad4,2": devSpec = "iPad Air (Cellular)"
        case "iPad4,4": devSpec = "iPad mini 2G (WiFi)"
        case "iPad4,5": devSpec = "iPad mini 2G (Cellular)"
            
        case "iPad4,7": devSpec = "iPad mini 3 (WiFi)"
        case "iPad4,8": devSpec = "iPad mini 3 (Cellular)"
        case "iPad4,9": devSpec = "iPad mini 3 (China Model)"
            
        case "iPad5,3": devSpec = "iPad Air 2 (WiFi)"
        case "iPad5,4": devSpec = "iPad Air 2 (Cellular)"
            
        case "i386": devSpec = "Simulator"
        case "x86_64": devSpec = "Simulator"
            
        default: devSpec = platform()
        }
        
        return devSpec
    }
    
    func platform() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let size = Int(_SYS_NAMELEN) // is 32, but posix AND its init is 256....
        
        let s = withUnsafeMutablePointer(to: &systemInfo.machine) {p in
            
            p.withMemoryRebound(to: CChar.self, capacity: size, {p2 in
                return String(cString: p2)
            })
            
        }
        return s
    }
}
