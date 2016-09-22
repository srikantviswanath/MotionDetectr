//
//  ComputeUtil.swift
//  MotionDetectr
//
//  Created by Srikant Viswanath on 8/24/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Darwin

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

func computeFirstOrderDerivative(data: [Double]) -> [Double]{
    var derivativeData = [Double]()
    for dataPointIdx in 0 ..< data.count {
        if dataPointIdx == 0 {
            derivativeData.append(data[0])
        } else {
            derivativeData.append(data[dataPointIdx] - data[dataPointIdx - 1])
        }
    }
    return derivativeData
}

///To compute ALL local minima or manixa based on the :extrema: flag passed in
func computeLocalExtrema(derivateData: [Double], extrema: String) -> [Int] {
    var extremaPoistions = [Int]()
    switch extrema {
    case "minima" :
        for idx in 0 ..< derivateData.count - 1{
            if derivateData[idx] < 0 && derivateData[idx+1] > 0 {
                extremaPoistions.append(idx)
            }
        }
    
    case "maxima":
        for idx in 0 ..< derivateData.count - 1{
            if derivateData[idx] > 0 && derivateData[idx+1] < 0 {
                extremaPoistions.append(idx)
            }
        }

    default:
        break
    }
    return extremaPoistions
}

///To identify each individual rep's start and end points. ( End point + 1 ) index corresponds to start point of next index

func extractIndividualReps(rawData: [Double]) -> [Dictionary<String, AnyObject>] {
    var setOfReps = [[String: AnyObject]]()
    let firstDerivativeData = computeFirstOrderDerivative(rawData)
    var localMinimaPositions = computeLocalExtrema(firstDerivativeData, extrema: "minima")
    localMinimaPositions = localMinimaPositions.filter{rawData[$0] < 0}
    for minimaPosIdx in 0 ..< localMinimaPositions.count - 1 {
        let singleRep = rawData[localMinimaPositions[minimaPosIdx] ..< localMinimaPositions[minimaPosIdx + 1] + 1]
        setOfReps.append(["repData": Array(singleRep), "startingPoint":localMinimaPositions[minimaPosIdx]])
    }
    setOfReps = setOfReps.filter {$0["repData"]!.count > 10} //drop the rep whose end points are less than 1.0 sec apart
    return setOfReps
}
