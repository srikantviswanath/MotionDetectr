//
//  ComputeUtil.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 8/24/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

func computeResultantScalar(xData: [Double], yData: [Double], zData: [Double]) -> [Double]{
    var resultantScalar = [Double]()
    for dataIdx in 0 ..< xData.count {
        let squaredSum = (xData[dataIdx] * xData[dataIdx]) + (yData[dataIdx] * yData[dataIdx]) + (zData[dataIdx] * zData[dataIdx])
        resultantScalar.append(sqrt(squaredSum))
    }
    return resultantScalar
}