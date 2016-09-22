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

class DataCollectorVC: UIViewController, ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var PlotChartView: LineChartView!
    @IBOutlet weak var PlotPicker: UIPickerView!
    
    var pickerViewTitles = ["X Acceleration", "Y Acceleration", "Z Acceleration", "Pitch", "Roll", "Yaw"]
    var xAccData = [Double]()
    var yAccData = [Double]()
    var zAccData = [Double]()
    var plottingData = [Double]()
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
        PlotPicker.delegate = self
        PlotPicker.dataSource = self
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
                    setChart(computeTimeSeries(self!.zAccData, sampleTime: self!.SAMPLE_TIME), accValues: self!.zAccData, plotChartView: self!.PlotChartView)
                    self!.PlotChartView.notifyDataSetChanged()
                }
            }
            StartStopButton.setTitle("STOP", forState: .Normal)
        } else {
            motionManager.stopDeviceMotionUpdates()
            StartStopButton.setTitle("START", forState: .Normal)

        }
    }
    
    @IBAction func ExtractReps(sender: UIButton) {
        performSegueWithIdentifier("ExtractRepOut", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? DataPlotVC {
            destVC.timeValues = computeTimeSeries(xAccData, sampleTime: SAMPLE_TIME)
            destVC.xAccDataValues = xAccData
            destVC.yAccDataValues = yAccData
            destVC.zAccDataValues = zAccData
            destVC.pitch = pitch
            destVC.roll = roll
            destVC.yaw = yaw
        }
    }
    
    //MARK: Picker delegate methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewTitles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let timeValues = computeTimeSeries(xAccData, sampleTime: SAMPLE_TIME)
        switch row {
        case 0:
            setChart(timeValues, accValues: xAccData, plotChartView: PlotChartView)
        case 1:
            setChart(timeValues, accValues: yAccData, plotChartView: PlotChartView)
        case 2:
            setChart(timeValues, accValues: zAccData, plotChartView: PlotChartView)
        case 3:
            setChart(timeValues, accValues: pitch, plotChartView: PlotChartView)
        case 4:
            setChart(timeValues, accValues: roll, plotChartView: PlotChartView)
        case 5:
            setChart(timeValues, accValues: yaw, plotChartView: PlotChartView)
        default:
            print("jajjarabhooto")
        }
    }
}

