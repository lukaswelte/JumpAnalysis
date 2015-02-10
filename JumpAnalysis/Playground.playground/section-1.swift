// Playground - noun: a place where people can play

import UIKit

let numberString = "2,5"

let double = (numberString as NSString).doubleValue

func convertStringToDouble(inputString: String) -> Double {
    let dotNumberString = inputString.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
    return (dotNumberString as NSString).doubleValue
}

let doubleFunc = convertStringToDouble(numberString)

