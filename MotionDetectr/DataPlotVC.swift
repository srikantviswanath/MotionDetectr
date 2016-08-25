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
        xPlotChartView.hidden = false
        yPlotChartView.hidden = false
        zPlotChartView.hidden = false
    }
    
    @IBAction func SegmentedControlToggled(sender: UISegmentedControl) {
        switch PillButton.selectedSegmentIndex {
        case 0:
            xPlotChartView.backgroundColor = UIColor(red: 255, green: 175, blue: 0, alpha: 1)
            setChart(timeValues, accValues: xAccDataValues, plotChartView: xPlotChartView)
            setChart(timeValues, accValues: yAccDataValues, plotChartView: yPlotChartView)
            setChart(timeValues, accValues: zAccDataValues, plotChartView: zPlotChartView)
            yPlotChartView.hidden = false
            zPlotChartView.hidden = false
        case 1:
            resultantScalar = computeResultantScalar(xAccDataValues, yData: yAccDataValues, zData: zAccDataValues)
            setChart(timeValues, accValues: resultantScalar, plotChartView: xPlotChartView)
            xPlotChartView.backgroundColor = UIColor.darkGrayColor()
            yPlotChartView.hidden = true
            zPlotChartView.hidden = true
        default:
            print("Washing powder Nirma")
        }
        
    }
    
    @IBAction func backBtnPressed(sender: UIButton) {
        performSegueWithIdentifier("FetchMoreData", sender: nil)
    }
    
    func setChart(timeValues: [Double], accValues: [Double], plotChartView: LineChartView) {
        var yValDataEntries: [ChartDataEntry] = []
        
        for dataPointIdx in 0 ..< timeValues.count {
            yValDataEntries.append(ChartDataEntry(x: timeValues[dataPointIdx], y: accValues[dataPointIdx]))
        }
        
        let plotDataSet = LineChartDataSet(values: yValDataEntries, label: "")
        plotDataSet.axisDependency = .Left
        plotDataSet.setColor(UIColor.whiteColor())
        plotDataSet.setCircleColor(UIColor.whiteColor())
        plotDataSet.circleRadius = 0.1
        
        var plotDataSets: [ILineChartDataSet] = [LineChartDataSet]()
        plotDataSets.append(plotDataSet)
        
        let plotData: LineChartData = LineChartData(dataSets: plotDataSets)
        plotChartView.data = plotData
        plotChartView.drawGridBackgroundEnabled = false
    }
    
}
