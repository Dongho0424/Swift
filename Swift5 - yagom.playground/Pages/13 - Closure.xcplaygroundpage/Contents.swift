import Foundation

let names = ["d", "g", "m", "j"]
let reversed = names.sorted { first, second in
    return first < second
} // d g j m
let reversed2 = names.sorted(by: <); print(reversed2)
print(reversed)

// 13.4
// Capture

func makeIncrementer(for amount: Int) -> (() -> Int) {
    var runningTotal = 0
    
    // capture runningTotal and amount
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

// incrementByTwo has reference to makeIncrementer(for: 2)
let incrementByTwo = makeIncrementer(for: 2)
let incrementByTen = makeIncrementer(for: 10)

// Therefore, first, first2, first3 has same reference which references same func.
// It results in var runningTotal increments by 2 three times.
let first = incrementByTwo()
let first2 = incrementByTwo()
let first3 = incrementByTwo(); print(first3)

// So that, incrementByTwoVer2 references func makeIncrementer(for: 2)
// which results in first4 equals 8
let incrementByTwoVer2 = incrementByTwo
let first4 = incrementByTwoVer2(); print(first4)

// 13.6
// Escaping

typealias VoidVoid = () -> Void

let firstClosure = {
    print("firstClosure")
}
let secondClosure = {
    print("secondClosure")
}

func returnClosure(first: @escaping VoidVoid, second: @escaping VoidVoid, shouldReturnFirst: Bool) -> VoidVoid {
    if shouldReturnFirst {
        return first
    } else {
        return second
    }
}

let returnedClosure = returnClosure(first: firstClosure, second: secondClosure, shouldReturnFirst: true)
returnedClosure()

var closures = [VoidVoid]()

func appendClosure(closure: @escaping VoidVoid) {
    closures.append(closure)
}

appendClosure {
    print()
}
print("closures.count: \(closures.count)")

// ----------------------------------------------------------------------

func funcWithNoescapingClosure(closure: VoidVoid){
    print("funcWithNoescapingClosure")
    closure()
    print("funcWithNoescapingClosure")
}

func funcWithEscapingClosure(completion: @escaping VoidVoid) -> VoidVoid {
    print("funcWithEscapingClosure")
    return completion
}

class closureClass {
    var x = 10
    
    func runNoescapingClosure() {
        print("runNoescapingClosure")
        funcWithNoescapingClosure {
            print("hi")
            self.x = 100
            print("x:", self.x)
        }
    }

    // must use `self` keyword when escaping closure
    func runEscapingClosure() -> VoidVoid {
        print("runEscapingClosure")
        return funcWithEscapingClosure {
            self.x = 200
            print("x:", self.x)
        }
    }
}

let instance = closureClass()
instance.runNoescapingClosure()
print(instance.x)

let returnedClosure2 = instance.runEscapingClosure()
returnedClosure2()
print(instance.x)
instance.x = 1
let returnedClosure3: () -> VoidVoid = instance.runEscapingClosure
let dongho: VoidVoid = returnedClosure3()
dongho()
print(instance.x)

print()
// 13.6.1 withoutActuallyEscaping
// 실제로는 escaping closure가 아니지만 함수 내부 로직상 escaping 역할을 해야하는 경우 쓰일 수 있음.

//func hasElements(in array: [Int], match predicate: (Int) -> Bool) -> Bool {
//    return array.lazy.filter{ predicate($0) }.isEmpty
//}

let numbers: [Int] = [2, 4, 6, 8]

let evenNumbersPredicate : (Int) -> Bool = { (number: Int) -> Bool in
    return number % 2 == 0
}

let oddNumbersPredicate : (Int) -> Bool = { (number: Int) -> Bool in
    return number % 2 == 1
}

func hasElements(in array: [Int], match predicate: (Int) -> Bool) -> Bool {
    return withoutActuallyEscaping(predicate) { escapablePredicate in
        return !array.lazy.filter{ escapablePredicate($0) }.isEmpty
    }
}

let hasEvenNumber: Bool = hasElements(in: numbers, match: evenNumbersPredicate); print(hasEvenNumber)
let hasOddNumber: Bool = hasElements(in: numbers, match: oddNumbersPredicate); print(hasOddNumber)
print()

// 13.7 Auto Closure
// T 타입의 값이 param으로 들어와도, () -> T 으로 자동으로 closure로 바꿔주는 기능

// 예시

// assert(<#T##condition: Bool##Bool#>, <#T##message: String##String#>)

var employees: [String] = ["dongho", "gangmin", "gangho", "jaeha"]

var simpleDul = employees

func firstEmp(_ empProvider: @autoclosure () -> String) {
    print("now emp: \(empProvider())")
}

firstEmp(employees.removeFirst())

// basically, @autoclosure imply @noescape.
// if you want to implement escaping closure, set @escaping annotation

func returnProvier(_ empProvider: @autoclosure @escaping () -> String) -> (() -> String) {
    return empProvider
}

let empProvider: () -> String = returnProvier(employees.removeFirst())
print("now emp: \(empProvider())")

