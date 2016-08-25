//
//  ViewController.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 8/17/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import CoreMotion

class DataCollectorVC: UIViewController {
    
    @IBOutlet weak var StartStopButton: UIButton!
    
    var xAccData = [Double]()
    var yAccData = [Double]()
    var zAccData = [Double]()
    let motionManager = CMMotionManager()
    let SAMPLE_TIME = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func StartStopBtnPressed(sender: UIButton) {
        if StartStopButton.currentTitle == "START" {
            if motionManager.deviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = SAMPLE_TIME
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak self] (data: CMDeviceMotion?, error: NSError?) in
                    self?.xAccData.append((data?.userAcceleration.x)!)
                    self?.yAccData.append((data?.userAcceleration.y)!)
                    self?.zAccData.append((data?.userAcceleration.z)!)
                }
            }
            StartStopButton.setTitle("STOP", forState: .Normal)
            StartStopButton.backgroundColor = UIColor.redColor()
        } else {
            motionManager.stopDeviceMotionUpdates()
            StartStopButton.setTitle("START", forState: .Normal)
            StartStopButton.backgroundColor = UIColor.greenColor()
        }
    }
    
    @IBAction func PlotOrthogonalComponents(sender: UIButton) {
        if xAccData.count > 1 {
            performSegueWithIdentifier("PlotCollectedData", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? DataPlotVC {
            let senderBtn = sender as! UIButton
            destVC.timeValues = computeTimeSeries(xAccData, sampleTime: SAMPLE_TIME)
            switch senderBtn.currentTitle! {
            case "Components >":
                destVC.xAccDataValues = xAccData
                destVC.yAccDataValues = yAccData
                destVC.zAccDataValues = zAccData
            default:
                print("Burrrrrio!")
            }
        }
    }
    
    func computeTimeSeries(dataValuesArray: [AnyObject], sampleTime: Double) -> [Double]{
        var timeSeries = [Double]()
        for dataValueIdx in 0 ..< dataValuesArray.count {
            timeSeries.append(sampleTime * Double(dataValueIdx))
        }
        return timeSeries
    }
}

