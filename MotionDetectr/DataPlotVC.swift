//
//  DataPlotVC.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 8/23/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Charts

class DataPlotVC: UIViewController, ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var StreamOfRepsPlotChartView: LineChartView!
    @IBOutlet weak var RepPlotChartView: LineChartView!
    @IBOutlet weak var FeaturePicker: UIPickerView!
    
    var timeValues: [Double]!
    var xAccDataValues: [Double]!
    var yAccDataValues: [Double]!
    var zAccDataValues: [Double]!
    var pitch: [Double]!
    var roll: [Double]!
    var yaw: [Double]!
    var singleRepPlotData = [Double]()
    var setOfRepsPerFeature = [[String: AnyObject]]()
    var currentRepIndex = 0
    
    var pickerViewTitles = ["X Acceleration", "Y Acceleration", "Z Acceleration", "Pitch", "Roll", "Yaw"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FeaturePicker.delegate = self
        FeaturePicker.dataSource = self
        
        setOfRepsPerFeature = extractIndividualReps(zAccDataValues)
        
        setChart(timeValues, accValues: zAccDataValues, plotChartView: StreamOfRepsPlotChartView)
        
        if setOfRepsPerFeature.count > 0 {
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)
        }
    }
    
    @IBAction func backBtnPressed(sender: UIButton) {
        performSegueWithIdentifier("FetchMoreData", sender: nil)
    }
    
    @IBAction func nextBtnPressed(sender: UIButton) {
        if currentRepIndex < setOfRepsPerFeature.count - 1 {
            currentRepIndex += 1
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)
        }
    }
    
    @IBAction func previousBtnPresses(sender: UIButton) {
        if currentRepIndex > 0 {
            currentRepIndex -= 1
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)
        }
    }
    
    
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
        currentRepIndex = 0
        switch row {
        case 0:
            setOfRepsPerFeature = extractIndividualReps(xAccDataValues)
            setChart(timeValues, accValues: xAccDataValues, plotChartView: StreamOfRepsPlotChartView)
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)
        case 1:
            setOfRepsPerFeature = extractIndividualReps(yAccDataValues)
            setChart(timeValues, accValues: yAccDataValues, plotChartView: StreamOfRepsPlotChartView)
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)
        case 2:
            setOfRepsPerFeature = extractIndividualReps(zAccDataValues)
            setChart(timeValues, accValues: zAccDataValues, plotChartView: StreamOfRepsPlotChartView)
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)

        case 3:
            setOfRepsPerFeature = extractIndividualReps(pitch)
            setChart(timeValues, accValues: pitch, plotChartView: StreamOfRepsPlotChartView)
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)

        case 4:
            setOfRepsPerFeature = extractIndividualReps(roll)
            setChart(timeValues, accValues: roll, plotChartView: StreamOfRepsPlotChartView)
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)

        case 5:
            setOfRepsPerFeature = extractIndividualReps(yaw)
            setChart(timeValues, accValues: yaw, plotChartView: StreamOfRepsPlotChartView)
            singleRepPlotData = setOfRepsPerFeature[currentRepIndex]["repData"] as! [Double]
            let startingPoint = setOfRepsPerFeature[currentRepIndex]["startingPoint"] as! Int
            let singleRepTimeValues = computeTimeSeries(singleRepPlotData, sampleTime: 0.1, startIndex: startingPoint)
            setChart(singleRepTimeValues, accValues: singleRepPlotData, plotChartView: RepPlotChartView)

        default:
            print("jajjarabhooto")
        }
    }
}

