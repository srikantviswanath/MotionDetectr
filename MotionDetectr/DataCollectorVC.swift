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
            if motionManager.deviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = SAMPLE_TIME
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak self] (data: CMDeviceMotion?, error: NSError?) in
                    let rawAccZ = (data?.userAcceleration.z)!
                    self?.xAccData.append((data?.userAcceleration.x)!)
                    self?.yAccData.append((data?.userAcceleration.y)!)
                    self?.zAccData.append(self!.smoothedAccZ.update(rawAccZ))
                    setChart(self!.computeTimeSeries(self!.zAccData, sampleTime: self!.SAMPLE_TIME), accValues: self!.zAccData, plotChartView: self!.PlotChartView)
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

