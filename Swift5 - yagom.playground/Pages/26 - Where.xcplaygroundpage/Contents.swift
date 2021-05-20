// hi
// tuple value binding
// with using "case pattern"
typealias Point = (x: Int, y: Int)
let origin = Point(0, 0); //print(type(of: origin))
if case (let x, _) = origin {
    print(x, "it's quite cool~")
}
switch origin{
case (-2...2, -1...1) where origin.0 != 0:
    print("no")
default: print("yes")
}
// using where
let points = [Point(1, 2), Point(1, -1), Point(1, 0)]
for point in points {
    switch point {
    case let (x, y) where x == y: print("x == y")
    case let (x, y) where x == -y: print("x == -y") 
    default: print("\(point.x), \(point.y)") 
    }
}
let opts = [1, 2, nil, 3, 4, nil]
// using where with optional pattern
for case let optt? in opts where optt < 3{
    print(optt)
}

// with type casting pattern
let values: [Any] = [0, 0.0, 53, 3.14159, "hello", (0, 0), (3.0, 5.0), {(name: String) -> String in "Hello, \(name)."}]

for value in values {
    switch value {
    case 0 as Int: print("zero as Int")
    case 0 as Double: print("zero as Double")
    case let someInt as Int:
        print("some Int value", someInt)
    case let pi as Double where pi > 0:
        print("pi, which a beautiful constant. with value:", pi)
    case let str as String: print(str)
    case let (x, y) as (Double, Double):
        print(x, y)
    case let (x, y) as (Int, Int) where x == 0 && y == 0:
        print("hi origin")
    case let stringConverter as (String) -> String:
        print("fuck that. It works!")
    default: ()
    }
}
// add protocol constraints with where statement
protocol SelfPrintable {
    func printSelf()
}
struct Temp: SelfPrintable {}
extension Int: SelfPrintable {}
extension String: SelfPrintable {}

extension SelfPrintable where Self: FixedWidthInteger, Self: SignedInteger {
    func printSelf() {
        print("FixedWidthInteger, SignedInteger, SelfPrintable: \(type(of: self))")
    }
}
extension SelfPrintable where Self: CustomStringConvertible {
    func printSelf() {
        print("CustomStringConvertible, SelfPrintable: \(type(of: self))")
    }
}
extension SelfPrintable {
    func printSelf() {
        print("otherwise.")
    }
}
10.printSelf()
"dongho".printSelf()
Temp().printSelf()
