//: [Previous](@previous)

import Foundation

// 1. Map
// returns array!

let numbers: [Int] = [0, 1, 2, 3, 4, 5]
let doubleNumbers: [Int] = numbers.map{ (num: Int) -> Int in return num * 2 }; print(doubleNumbers)
let strings: [String] = numbers.map{(num: Int) -> String in return String(num)}; print(strings)

let dict: [String: String] = ["a": "A", "b": "B"]
var keys: [String] = dict.map { (key: String, value: String) -> String in return key }; print(keys)
var keys2: [String] = dict.map{ tuple in return tuple.0 }; print(keys2)
var keys3: [String] = dict.map{ $0.0 }; print(keys3)

let set: Set<Int> = [1, 2, 3, 4, 5]; print(set)
let resultSet: Set<Int> = Set(set.map{ (e: Int) -> Int in return e * 2}); print(resultSet) // bad code

// 2. Filter
// returns array

let evenNumbers: [Int] = numbers.filter{ (e: Int) -> Bool in return e % 2 == 0}; print(evenNumbers)

// 3. Reduce
// returns T

// reduce ver.1; reduce(_:_:)

var sum: Int = numbers.reduce(2){ (result: Int, next: Int) -> Int in return result + next }; print(sum)

let names: [String] = ["dongho", "gangmin", "gangho", "jaeha"]
let reducesNames: String = names.reduce("Team Wave: "){$0 + $1 + ", "}; print(reducesNames)

// reduce ver.2; reduce(into:_:)

sum = numbers.reduce(into: 0) { (result: inout Int, next: Int) in print("\(result) + \(next)"); result += next }; print(sum)

let reducesNames2: String = names.reduce(into: "Team Wave: "){(result: inout String, next: String) in
    if next == names.last {
        result = result + next
    } else {
        result = result + next + ", "
    }
}; print(reducesNames2)

// filter + map + reduce

let nums: [Int] = [1, 2, 3, 4, 5, 6, 7]
var result: Int = nums.filter{$0.isMultiple(of: 2)}.map{$0 * 3}.reduce(0){$0 + $1}; print(result)

//: [Next](@next)
