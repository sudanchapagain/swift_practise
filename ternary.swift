import Foundation

let a = 25
let b = 42
let c = 17
let largest = (a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c)
let smallest = (a < b) ? ((a < c) ? a : c) : ((b < c) ? b : c)
print("largest is \(largest)")
print("smallest is \(smallest)")
