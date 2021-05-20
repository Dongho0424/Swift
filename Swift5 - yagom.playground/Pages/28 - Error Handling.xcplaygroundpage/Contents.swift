// error
// ex
import Foundation

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory: [String: Item] = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chocolate": Item(price: 10, count: 4),
        "Beer": Item(price: 20, count: 10)
    ]
    
    var coinsDeposited: Int = 0
    
    func dispense(snack: String) {print("\(snack) 제공")}
    
    func vend(itemNamed name: String) throws {
        guard var item = self.inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= self.coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - self.coinsDeposited)
        }
        
        self.coinsDeposited -= item.price
        print("left coin: \(self.coinsDeposited)")
        
        item.count -= 1
        self.inventory[name] = item
        
        self.dispense(snack: name)
    }
}

struct PurchasedSnack {
    let name: String
    
    // initializer 안에 error을 발생할 여지가 있으면 throws 해줘야 함.
    init(name: String, v: VendingMachine) throws {
        try v.vend(itemNamed: name)
        self.name = name
    }
}

// 함수 안에 error을 발생할 여지가 있으면 throws 해줘야 함.
// try catch로 잘 해결하면 필요없음
func buySnack(person: String, v: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    do {
        try v.vend(itemNamed: snackName)
    } catch VendingMachineError.invalidSelection {
        print("유효하지 않은 선택")
    } catch VendingMachineError.outOfStock {
        print("품절")
    } catch VendingMachineError.insufficientFunds(let coin) {
        print("동전 부족: 동전 \(coin)개 더 필요.")
    }
}

let favoriteSnacks: [String: String] = [
    "dongho": "Candy Bar",
    "gangmin": "Chocolate",
    "subin": "Beer",
    "minhu": "Brr"
]

let machine: VendingMachine = VendingMachine()
machine.coinsDeposited = 52

var purchase = try PurchasedSnack(name: "Beer", v: machine); print(purchase.name)
for (person, snack) in favoriteSnacks {
    print(person, snack)
    try buySnack(person: person, v: machine)
}

/// Error Handling by optional value
func errorFunc(error: Bool) throws -> Int {
    enum SomeError: Error {
        case error
    }
    if error {
        throw SomeError.error
    } else {
        return 100
    }
}

let x: Int? = try? errorFunc(error: true); print(x)
let y: Int? = try? errorFunc(error: false); print(y); print()

/// Rethrow
func throwingFunction() throws {
    enum EEError: Error {
        case error
    }
    throw EEError.error
}
func rethrowingFunction(callback: () throws -> Void) throws {
    enum EEError: Error {
        case errorEEE
    }
    
    do {
        try callback()
    } catch {
        print("first")
        throw EEError.errorEEE
    }
    
    do {
        try throwingFunction()
    } catch {
        print("second")
        throw EEError.errorEEE
    }
    
//    throw EEError.error
}
do {
    try rethrowingFunction(callback: throwingFunction)
} catch {
    print(error)
}

// 상속 및 프로토콜에서 error
protocol SomeP {
    func SomeThrowingF(callback: () throws -> Void) throws
    func SomeRethrowingF(callback: () throws -> Void) rethrows
}

class SomeC: SomeP {
    func SomeThrowingFF(callback: () throws -> Void) throws {}
    func SomeRethrowingFF(callback: () throws -> Void) rethrows {}
    
    // throws -> rethrows 로 implement ㄱㄴ
    func SomeThrowingF(callback: () throws -> Void) rethrows {}
    
    // rethrows -> throws 로 implement ㅂㄱㄴ
//    func SomeRethrowingF(callback: () throws -> Void) throws {}
    func SomeRethrowingF(callback: () throws -> Void) rethrows {}
}

class SomeChildC: SomeC {
    // throws -> rethrows 로 implement ㄱㄴ
    override func SomeThrowingFF(callback: () throws -> Void) rethrows {}
    
    // rethrows -> throws 로 implement ㅂㄱㄴ
//    override func SomeRethrowingFF(callback: () throws -> Void) throws {}
}
print()

/// defer
func deferFunc(error: Bool) throws -> Int {
    defer {
        print("first defer")
    }
    
    if error {
        enum E: Error {
            case error
        }
        throw E.error
    }
    
    defer {
        print("second defer")
    }
    
    defer {
        print("third defer")
    }
    
    return 100
}

try? deferFunc(error: true)
try? deferFunc(error: false)
