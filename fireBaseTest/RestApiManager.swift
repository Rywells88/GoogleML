//
//  request.swift
//  fireBaseTest
//
//  Created by Ryley Wells (LCL) on 5/27/19.
//  Copyright © 2019 Ryley Wells (LCL). All rights reserved.
//
import Foundation
import Firebase
import FirebaseMLCommon

class RestApiManager
{
     var firstConfidenceLabelNumber : NSNumber = 0 // chinese brocolli
     var secondConfidenceLabelNumber: NSNumber = 0 // broccoli
    var firstNameLabel: String = ""
    var secondNameLabel: String = ""
    
    public func useModel(examp: UIImage)->Bool{
            let image2 = VisionImage(image: examp)
            let labelerOptions = VisionOnDeviceAutoMLImageLabelerOptions(remoteModelName: nil ,localModelName: "myNewModel")
            let labeler = Vision.vision().onDeviceAutoMLImageLabeler(options: labelerOptions)
            labelerOptions.confidenceThreshold = 0
            labeler.process(image2) { labels, error in
                guard error == nil, let labels = labels else { return }
                for label in labels {
                
                    let labelText = label.text
                    let confidence = label.confidence
                    print(labelText)
                    print("\n")
                    print(confidence!)
                    print ("\n")
                    if(labelText == "chinesebroccoli")
                    {
                        self.setFirstConfidenceLabel(conf: confidence!)
                        self.setFirstNameLabel(Nam: labelText)
                    }else
                    {
                        self.setSecondConfidenceLabel(conf: confidence!)
                        self.setSecondNameLabel(Nam: labelText)
                    }
                    
                }
                
        }
        return true
    }
    public func setFirstConfidenceLabel(conf: NSNumber)
    {
        firstConfidenceLabelNumber = conf
        print("firstConfidenceLabelNumber attribute has been set and is" + "\(firstConfidenceLabelNumber)")
    }
    public func setSecondConfidenceLabel(conf: NSNumber)
    {
        secondConfidenceLabelNumber = conf
        print("secondConfidenceLabelNumber attribute has been set and is" + "\(secondConfidenceLabelNumber)")
    }
    public func getSecondConfidenceLabel()->NSNumber
    {
        return secondConfidenceLabelNumber
    }
    public func getFirstConfidenceLabel()->NSNumber
    {
        return firstConfidenceLabelNumber
    }
    public func setFirstNameLabel(Nam: String)
    {
        firstNameLabel = Nam
    }
    public func setSecondNameLabel(Nam: String)
    {
        secondNameLabel = Nam
    }
   

}
