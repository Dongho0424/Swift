import Foundation

func address(of object: AnyObject) {
    print(Unmanaged.passUnretained(object).toOpaque())
}
func address(of object: inout Any){
    withUnsafePointer(to: &object) {
        print($0)
    }
}

class Person {
    let name: String
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    var room: Room?
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

/// 27.3 Weak Reference

class Room {
    let number: Int
    
    init (number: Int) {
        self.number = number
    }
    
    // weak var optional
    // weak: 참조 횟수를 증가시키지 않음.
    weak var host: Person?
    
    deinit {
        print("Room \(number) is being deinitialized.")
    }
}

var reference1: Person? = Person(name: "dongho")
var reference2: Person? = reference1
var reference3: Person?

//reference1 = Person(name: "dongho") // Person(name: dongho)의 참조 횟수 : 1
//reference2 = reference1 // Person(name: dongho)의 참조 횟수 : 2
//reference3 = reference2 // Person(name: dongho)의 참조 횟수 : 3

address(of: reference1!)
address(of: reference2!)
//address(of: reference3!)

//reference3 = nil
reference2 = nil
reference1 = nil
// deinit

// never call deinit
var reference4: Person? = Person(name: "jun bug")
reference4 = nil

func foo() {
    print("func foo() begins")
    let gangmin: Person = Person(name: "gangmin")
    print("gangmin's name is \(gangmin.name)")
    
    // foo()의 코드 블럭이 끝날 때, 코드 블럭안에 정의된 gangmin은 메모리 해제가 됨.
    // 따라서 이 인스턴스의 deinit이 불려짐.
}
foo()

var globalReference: Person?

func boo() {
    print("func boo() begins")
    let subin: Person = Person(name: "subin") // Person(name: "subin")의 참조 횟수 : 1
    print("subin's name is \(subin.name)")
    globalReference = subin // Person(name: "subin")의 참조 횟수 : 2
    
    // boo()의 코드 블럭이 불려도, 글로벌 변수는 아직 Person(~)을 가리킴.
    // 따라서 인스턴스 해제가 일어나지 않음.
}
boo()
//
//var dongho: Person? = Person(name: "dongho")
//var room: Room? = Room(number: 505) // Room(number: 505)의 참조 횟수: 1
//
//room?.host = dongho
//dongho?.room = room // Room(number: 505)의 참조 횟수: 2
//
//address(of: dongho!)
//address(of: room!.host!)
//
//room = nil // Room(number: 505)의 참조 횟수: 1
//print(dongho!.room!.number)

var dongho: Person? = Person(name: "dongho2") // Person()의 참조 횟수: 1
var room: Room? = Room(number: 505) // Room(number: 505)의 참조 횟수: 1

// weak var host
room?.host = dongho // Person()의 참조 횟수: 1
dongho?.room = room // Room(number: 505)의 참조 횟수: 2

dongho = nil // Person()의 참조 횟수: 0 -> dongho의 모든 프로터디들의 참조가 사라짐. -> Room(number: 505)의 참조 횟수: 1

print(room?.host) // nil

room = nil

// 처음부터 weak var 이면?
// 만들어지자마자 deallocate 됨.
// Person(name: "seohyun")의 참조횟수가 0 이니까. // 참조 횟수: 0 <=> 메모리 해제
weak var seohyun = Person(name: "seohyun")

/// 27.4 Unowned Reference
class Employee {
    let name: String
    
    // 카드가 없을 수도 있음
    // 강한 참조의 의미: 사람이 한 번 카드를 가진 후 잃어버리면 안되므로. 즉 자동적으로 카드에 대한 참조가 없어지면 안되므로
    var card: CreditCard?
    
    
    init(name: String){
        self.name = name
    }
    
    deinit{
        print("\(self.name) is being deinitialized.")
    }
}

class CreditCard {
    let number: UInt
    
    // unowned: 카드는 소유자가 분명함. 즉 참조의 대상이 절대로 nil이 안될 것이라는 전제를 깔음
    unowned let owner: Employee
//    let owner: Employee
    
    init(number: UInt, owner: Employee) {
        self.number = number
        self.owner = owner
    }
    
    deinit{
        print("Card #\(self.number) is being deinitialized.")
    }
}

var dayeong: Employee? = Employee(name: "dayeong")

if let person: Employee = dayeong {
    person.card = CreditCard(number: 1000, owner: person)
}

/// 27.5 unowned optional
class Department {
    var name: String
    var subjects: [Subject?] = []
    init(name: String) {
        self.name = name
    }
}

class Subject {
    var name: String
    unowned var department: Department
    unowned var nextSubject: Subject?
    init(name: String, in department: Department){
        self.name = name
        self.department = department
        self.nextSubject = nil
        
        print("initializing.. subject name: \(name)")
    }
    
    deinit {
        print("deinitilizing.. subject name: \(name)")
    }
}

let ece: Department = Department(name: "ece")

var intro : Subject? = Subject(name: "basic", in: ece)
var intermediate : Subject? = Subject(name: "intermediate", in: ece)
var advanced : Subject? = Subject(name: "advanced", in: ece)

intro?.nextSubject = intermediate; intermediate?.nextSubject = advanced
ece.subjects = [intro, intermediate, advanced]

// custom
//ece.subjects.removeLast()
//advanced = nil
//print("  hi tehre")
//print(intermediate?.nextSubject?.name)
// shit
address(of: (ece.subjects.last!)!)
address(of: intermediate!.nextSubject!)
advanced = nil
ece.subjects[2] = nil
//print(intermediate?.nextSubject?.name)


/// 27.6 unowned reference and implicit optional property
class Company {
    var name: String
    var ceo: CEO!
    init(name: String, ceoName: String) {
        self.name = name
        self.ceo = CEO(name: ceoName, company: self)
    }
    
    func introduce() {
        print("\(self.name)의 CEO는 \(self.ceo.name)입니다.")
    }
}

class CEO {
    let name: String
    unowned let company: Company
    
    init(name: String, company: Company) {
        self.name = name
        self.company = company
    }
    
    func introduce() {
        ("\(self.name)는 \(self.company.name)의 CEO입니다.")
    }
}

let company: Company = Company(name: "Wave", ceoName: "MKH")
company.introduce()
company.ceo.introduce()

/// 27.7 Strong Reference of Closure
class Crew_0 {
    let name: String
    let hobby: String?
    
    lazy var introduce: () -> String = {
        var introduction: String = "My name is \(self.name)."
        
        guard let hobby = self.hobby else {
            return introduction
        }
        
        introduction += " And my hobby is \(hobby)"
        
        return introduction
    }
    
    init(name: String, hobby: String? = nil) {
        self.name = name
        self.hobby = hobby
    }
    
    deinit {
        print("Crew \(name) is being deinitialized")
    }
}

var crew_0: Crew_0? = Crew_0(name: "crewcrew", hobby: "piano")
print(crew_0?.introduce())
address(of: crew_0!)
//address(of: crew!.introduce())

crew_0 = nil // crew instance is not initialized.

/// 27.7.1 Capture List

// test 1: capture list of value type
var a = 0
var b = 0
let closure = { [a] in
    print(a, b)
    b = 20
}

a = 10
b = 100
closure()
print(b); print()

// test 2: capture list of reference type
class TestClass {
    var value: Int = 0
}
var x = TestClass(); var y = TestClass();
// 참조 타입을 capture list로 capture해도
// x는 참조 타입의 인스턴스이기 때문에
// x가 계속 인스턴스를 참조함. 당연하게도 클로저 안팎에서 메모리 주소가 같음
let testClosure = { [x] in
    print(x.value, y.value)
    address(of: x)
}
x.value = 10
address(of: x)
y.value = 20
testClosure()
print()

// test 3: capture list of reference type which explicitly
// specifies how to capture, which is strong, weak, unowned
class NotSimpleClass {
    var value: Int = 0
}

var notX: NotSimpleClass? = NotSimpleClass()
var notY = NotSimpleClass()
let notClosure = { [weak notX, unowned notY] in
    print(notX?.value, notY.value)
}

notX?.value = 100
notY.value = 10
notClosure()
print()

// capture list를 통한 클로저의 강한 참조 순환 문제 해결
class Crew {
    let name: String
    let hobby: String?
    
    lazy var introduce: () -> String = { [unowned self] in
        var introduction: String = "My name is \(self.name)."
        
        guard let hobby = self.hobby else {
            return introduction
        }
        
        introduction += " And my hobby is \(hobby)"
        
        return introduction
    }
    
    init(name: String, hobby: String? = nil) {
        self.name = name
        self.hobby = hobby
    }
    
    deinit {
        print("Crew \(name) is being deinitialized")
    }
}

var crew: Crew? = Crew(name: "crewcrew", hobby: "piano")
var cook: Crew? = Crew(name: "cook", hobby: "cooking")

cook?.introduce = crew?.introduce ?? {" "}
print(crew?.introduce())
crew = nil
//print(cook?.introduce())
print()

class WeakCrew {
    let name: String
    let hobby: String?
    
    lazy var introduce: () -> String = { [weak self] in
        guard let `self` = self else {
            return "참조 대상이 메모리에서 해제되었습니다."
        }
        
        var introduction: String = "My name is \(self.name)."
        
        guard let hobby = self.hobby else {
            return introduction
        }
        
        introduction += " And my hobby is \(hobby)"
        
        return introduction
    }
    
    init(name: String, hobby: String? = nil) {
        self.name = name
        self.hobby = hobby
    }
    
    deinit {
        print("Crew \(name) is being deinitialized")
    }
}

var yagom: WeakCrew? = WeakCrew(name: "crewcrew", hobby: "piano")
var hana: WeakCrew? = WeakCrew(name: "cook", hobby: "cooking")

hana?.introduce = yagom?.introduce ?? {" "}
print(yagom!.introduce())
print(hana!.introduce())
yagom = nil
print(hana!.introduce())

