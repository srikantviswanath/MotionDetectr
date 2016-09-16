//
//  ViewController.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 8/17/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import CoreMotion
import Charts

class DataCollectorVC: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var PlotChartView: LineChartView!
    
    var xAccData = [Double]()
    var yAccData = [Double]()
    var zAccData = [Double]()
    var pitch = [Double]()
    var roll = [Double]()
    var yaw = [Double]()
    var smoothedAccX = LowPassFilterSignal(currentValue: 0.0, filterFactor: 0.75)
    var smoothedAccY = LowPassFilterSignal(currentValue: 0.0, filterFactor: 0.75)
    var smoothedAccZ = LowPassFilterSignal(currentValue: 0.0, filterFactor: 0.75)
    let motionManager = CMMotionManager()
    let SAMPLE_TIME = 0.1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlotChartView.delegate = self
        PlotChartView.backgroundColor = UIColor.blueColor()
    }
    
    @IBAction func StartStopBtnPressed(sender: UIButton) {
        if StartStopButton.currentTitle == "START" {
            zAccData = [Double]()
            pitch = [Double]()
            if motionManager.deviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = SAMPLE_TIME
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak self] (data: CMDeviceMotion?, error: NSError?) in
                    if let attitude = data?.attitude { //Record rotation along the 3 axises
                        self?.pitch.append(attitude.pitch * 180/M_PI)
                        self!.roll.append(attitude.roll * 180/M_PI)
                        self?.yaw.append(attitude.yaw * 180/M_PI)
                    }
                    if let userAcc = data?.userAcceleration {
                        let rawAccX = userAcc.x
                        let rawAccY = userAcc.y
                        let rawAccZ = userAcc.z
                        self?.xAccData.append(self!.smoothedAccX.update(rawAccX))
                        self?.yAccData.append(self!.smoothedAccY.update(rawAccY))
                        self?.zAccData.append(self!.smoothedAccZ.update(rawAccZ))
                        
                    }
                    setChart(self!.computeTimeSeries(self!.pitch, sampleTime: self!.SAMPLE_TIME), accValues: self!.pitch, plotChartView: self!.PlotChartView)
                    self!.PlotChartView.notifyDataSetChanged()
                }
            }
            StartStopButton.setTitle("STOP", forState: .Normal)
            StartStopButton.backgroundColor = UIColor.redColor()
        } else {
            motionManager.stopDeviceMotionUpdates()
            StartStopButton.setTitle("START", forState: .Normal)
            StartStopButton.backgroundColor = UIColor(red: 0, green: 191, blue: 165, alpha: 1)
        }
    }
    
    @IBAction func PlotOrthogonalComponents(sender: UIButton) {
        if xAccData.count > 1 {
            performSegueWithIdentifier("PlotCollectedData", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? DataPlotVC {
            destVC.timeValues = computeTimeSeries(xAccData, sampleTime: SAMPLE_TIME)
            destVC.xAccDataValues = xAccData
            destVC.yAccDataValues = yAccData
            destVC.zAccDataValues = zAccData
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

