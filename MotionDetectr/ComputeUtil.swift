//
//  ComputeUtil.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 8/24/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Darwin

func computeResultantScalar(xData: [Double], yData: [Double], zData: [Double]) -> [Double]{
    var resultantScalar = [Double]()
    for dataIdx in 0 ..< xData.count {
        let squaredSum = (xData[dataIdx] * xData[dataIdx]) + (yData[dataIdx] * yData[dataIdx]) + (zData[dataIdx] * zData[dataIdx])
        resultantScalar.append(sqrt(squaredSum))
    }
    return resultantScalar
}

func computeCorrelationCoeff(X: [Double], Y: [Double]) -> Double {
    var sigmaX = 0.0
    var sigmaY = 0.0
    var sigmaXY = 0.0
    var sigmaXSquare = 0.0
    var sigmaYSquare = 0.0
    guard let n = X.count as? Int where X.count == Y.count else {
        print("The 2 data sets do not have equal number of samples")
        return 0.0
    }
    
    for i in 0 ..< n {
        sigmaX += X[i]
        sigmaY += Y[i]
        sigmaXY += X[i] * Y[i]
        sigmaXSquare += X[i] * X[i]
        sigmaYSquare += Y[i] * Y[i]
    }
    
    let  numerator = (Double(n) * sigmaXY) - (sigmaX * sigmaY)
    let denX = (Double(n) * sigmaXSquare) - (sigmaX * sigmaX)
    let denY = (Double(n) * sigmaYSquare) - (sigmaY * sigmaY)
    let denominator = sqrt( denX * denY )
    return numerator / denominator
    
}

struct LowPassFilterSignal {
    // Current signal value
    var currentValue: Double
    
    // A scaling factor in the range 0.0..<1.0 that determineshow resistant the value is to change
    let filterFactor: Double
    
    ///Update currentValue, using filterFactor to attenuate changes
    mutating func update(newValue: Double) -> Double{
        currentValue = filterFactor * currentValue + (1.0 - filterFactor) * newValue
        return currentValue
    }
}