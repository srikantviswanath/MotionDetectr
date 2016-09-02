//
//  DataPlotVC.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 8/23/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Charts

class DataPlotVC: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var xPlotChartView: LineChartView!
    @IBOutlet weak var yPlotChartView: LineChartView!
    @IBOutlet weak var zPlotChartView: LineChartView!
    @IBOutlet weak var PillButton: UISegmentedControl!
    
    var timeValues: [Double]!
    var xAccDataValues: [Double]!
    var yAccDataValues: [Double]!
    var zAccDataValues: [Double]!
    var resultantScalar = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xPlotChartView.delegate = self
        xPlotChartView.descriptionText = "X Acceleration"
        
        yPlotChartView.delegate = self
        yPlotChartView.descriptionText = "Y Acceleration"
        
        zPlotChartView.delegate = self
        zPlotChartView.descriptionText = "Z Acceleration"
        
        setChart(timeValues, accValues: xAccDataValues, plotChartView: xPlotChartView)
        setChart(timeValues, accValues: yAccDataValues, plotChartView: yPlotChartView)
        setChart(timeValues, accValues: zAccDataValues, plotChartView: zPlotChartView)
        print("Y,X correlation:\(computeCorrelationCoeff(yAccDataValues, Y: xAccDataValues))")
        print("Z,Y correlation:\(computeCorrelationCoeff(zAccDataValues, Y: yAccDataValues))")
        print("X,Z correlation:\(computeCorrelationCoeff(xAccDataValues, Y: zAccDataValues))")
    }
    
    @IBAction func SegmentedControlToggled(sender: UISegmentedControl) {
        switch PillButton.selectedSegmentIndex {
        case 0:
            xPlotChartView.backgroundColor = UIColor.blueColor()
            yPlotChartView.backgroundColor = UIColor.redColor()
            zPlotChartView.backgroundColor = UIColor.brownColor()
            setChart(timeValues, accValues: xAccDataValues, plotChartView: xPlotChartView)
            setChart(timeValues, accValues: yAccDataValues, plotChartView: yPlotChartView)
            setChart(timeValues, accValues: zAccDataValues, plotChartView: zPlotChartView)
            zPlotChartView.hidden = false
            
            default:
            print("Washing powder Nirma")
        }
        
    }
    
    @IBAction func backBtnPressed(sender: UIButton) {
        performSegueWithIdentifier("FetchMoreData", sender: nil)
    }
    
}
