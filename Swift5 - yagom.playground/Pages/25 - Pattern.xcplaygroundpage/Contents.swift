// wildcard pattern
typealias Info = (name: String, age: Int, sex: String)
let dongho: Info = ("dongho", 22, "mail")

switch dongho {
case ("dongho", _, _):
    print("name matched!")
    fallthrough
case (_, _, "mail"):
    print("hi")
default:
    ()
}

for _ in 0...2 {
    print("0..2", terminator: " ")
}
print()

// combination with Value Binding Pattern
switch dongho {
case let (name, age, sex):
    print(name, age, sex)
}
switch dongho {
case (let name, _, let sex):
    print(name, sex)
}

enum MainDish {
    case pasta(taste: String)
    case pizza(dough: String, topping: String)
    case chicken(withSauce: Bool)
    case rice
}

let dinner: MainDish = .pizza(dough: "cheesecrust", topping: "fire")
// enum case pattern
// like switch's case pattern which binds enum's associated value,
// it can be used with if, while, guard, for-in statement
if case .pizza(let dough, let topping) = dinner {
    print("dough: \(dough), topping: \(topping)")
}

func dishInfo(_ dish: MainDish) {
    guard case MainDish.pasta(let taste) = dish else {
        print("it's not pasta. Suck!")
        return
    }
    print("pasta. taste: \(taste)")
}
dishInfo(.rice)
dishInfo(.pasta(taste: "cream"))

// type casting pattern
let someValue: Any = 100
switch someValue {
case is Int: print("It's Int. Its instace is a kind of standard to figure out true or false when using 'is' operator")
default: ()
}
switch someValue {
// value binding pattern
case let value as Int: print(value + 1)
default: ()
}

// Expression Pattern
var point: (Int, Int) = (0, 2)
switch point {
case (0, 0): print("origin") 
case (-2...2, -2...2): print("dongho") 
default: ()
}

func ~=(pattern: String, value: Int) -> Bool {
    return pattern == String(value)
}

switch point {
case ("0", "0"): print("origin")
case ("0", "2"): print("not origin.") 
default: ()
}
let zero = 0
if 0...2 ~= zero {
    print("yes")
}
if case 0...2 = zero {
    print("yesyes")
}

struct Person { 
    var name: String
    var age: Int
}

let dongho1: Person = Person(name: "dongho", age: 22)
func ~=(pattern: String, value: Person) -> Bool {
    return pattern == value.name
}
func ~=(pattern: Person, value: Person) -> Bool {
    return pattern.name == value.name && pattern.age == value.age
}

switch dongho1 {
case Person(name: "dongho", age: 23):
    print("dongho") 
case "dongho": print("just same name")
default: ()
}

/// using Generic with Protocol
protocol Personalize {
    var name: String { get }
    var age: Int { get }
}
struct Person1: Personalize {
    var name: String
    var age: Int
}
let star = Person1(name: "star", age: 99)

func ~=<T: Personalize>(pattern: String, value: T) -> Bool {
    return pattern == value.name
}
func ~=<T: Personalize>(pattern: T, value: T) -> Bool {
    return pattern.name == value.name && pattern.age == value.age
}

switch star {
case "star": print("star. hi.")
default: ()
}

func ~= <T: Personalize> (pattern: (T) -> Bool, value: T) -> Bool {
    return pattern(value)
}

func isYoung<T: Personalize>(value: T) -> Bool {
    return value.age < 99
}

switch star {
case isYoung: print("young!")
default: print("you are old...")
}

// optional pattern
let opt: String? = "tomorrow"
if let optt = opt {
    print("optt", optt)
}
if case let optt? = opt {
    print("optt", optt)
}
let opts = [1, 2, nil, 3, 4, nil]
for case let optt? in opts {
    print(optt)
}
