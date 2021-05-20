//: [Previous](@previous)

import Foundation

var value: Int? = 2
value.map { (e: Int) -> Int in return e + 3}
print(value)

var nums = [1, 3, 4]

var mappedNums = nums.map {(num: Int) -> Int in return num + 3}
var flatNums = nums.compactMap{(num: Int) -> Int in return num + 3}

let possibleNumbers = ["1", "2", "three", "///4///", "5"]

let mapped: [Int?] = possibleNumbers.map { str in Int(str) }; print(mapped)
// [1, 2, nil, nil, 5]

let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }; print(compactMapped)
// [1, 2, 5]

let optionalInt: Int? = Optional(2)
let op = optionalInt.map{$0 + 3}
let ti = optionalInt.map{(e: Int) -> Int in return e + 3}
let on = optionalInt.flatMap{(e: Int) -> Int? in return Optional(e + 3)};// print(on)

let optionals : [Int?] = [1, 2, nil]
let mapped2 : [Int?] = optionals.map{(e: Int?) -> Int? in return e}; print(mapped2)
let flatmapped2: [Int] = optionals.compactMap{(e: Int?) -> Int? in return e}; print(flatmapped2)
let fm = optionals.compactMap{ $0 }; print("fm: \(fm)")

let multi = [[1, 2, nil], [3, nil], [4, 5, nil]]

let mappedMulti = multi.map{$0.map{$0}}; print(multi)
let flatmappedMulti = multi.map{$0.compactMap{$0}}; print(flatmappedMulti)
let multi2 = multi.compactMap{$0.map{$0}}; print(multi2)
let mutlasd = multi.flatMap{$0.compactMap{$0}}; print(mutlasd)

/// custom Optional, Optionall
/// method: map, flatMap,
/// with a, d, value
enum Optionall<T> {
    case some(T)
    case none
    
    init(_ value: T){
        self = .some(value)
    }
    
    func map<U>(_ functor: (T) -> U) -> Optionall<U> {
        return self.flatMap { (val: T) in
            return Optionall<U>.some(functor(val))
        }
    }
    
    func flatMap<U>(_ functor: (T) -> Optionall<U>) -> Optionall<U> {
        switch self {
        case .some(let val):
            return functor(val)
        case .none:
            return .none
        }
    }
}

func a(value: Int) -> Optionall<Int> {
    if (value > 0) {
        return Optionall<Int>.some(value * 10)
    } else {
        return Optionall.none
    }
}

func d(value: Int) -> Int {
    return value * 10
}

func getIntValue(value: Optionall<Int>) -> Int {
    switch value {
    case .some(let x):
        return x
    case .none:
        return -1
    }
}

func getStringValue(value: Optionall<String>) -> String {
    switch value {
    case .some(let x):
        return x
    case .none:
        return "nil"
    }
}


var flow1 = a(value: 0).map(d).flatMap(a)
print(getIntValue(value: flow1))

//var flow2 = a(value: -1).map{"\($0)"}
//print(getStringValue(value: flow2))
 

//: [Next](@next)
