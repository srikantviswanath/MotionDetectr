//
//  ChartUtil.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 9/1/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Charts

func setChart(timeValues: [Double], accValues: [Double], plotChartView: LineChartView) {
    var yValDataEntries: [ChartDataEntry] = []
    
    for dataPointIdx in 0 ..< timeValues.count {
        yValDataEntries.append(ChartDataEntry(x: timeValues[dataPointIdx], y: accValues[dataPointIdx]))
    }
    if yValDataEntries.count > 1 {
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

    } else {
        print("Boorio, no data yet")
    }
}


func computeTimeSeries(dataValuesArray: [AnyObject], sampleTime: Double, startIndex: Int = 0) -> [Double]{
    var timeSeries = [Double]()
    for dataValueIdx in 0 ..< dataValuesArray.count {
        timeSeries.append((sampleTime * Double(startIndex)) + (sampleTime * Double(dataValueIdx)))
    }
    return timeSeries
}