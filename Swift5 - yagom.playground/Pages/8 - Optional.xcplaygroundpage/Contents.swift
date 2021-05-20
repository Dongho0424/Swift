/**
 # Hi. This is my first functiong of first playground.
 ## Naming
 Yes. It's Mmm... Yeahj
 ## lunch menu
 Yeah. sushi ~~
 ## precondition
 precondition?
 ## humm
 hi!
 ```
 let dongho = say("dongho")
 ```
 - Precondition: oh.... good!
 - Parameters:
    - something: it's just string
 - Returns: string!
 - Warning: this function is @discardableResult
 */
func say(_ something: String) -> String {
    print(something)
    return something
}

import Foundation
import PlaygroundSupport

//let dongho = say("dongho")
//say("gangmin")
//
//enum Menu {
//    case chicken, pizza, hamburger
//}
//
//let lunchMenu: Menu = .chicken
//
//switch lunchMenu {
//case .chicken:
//    print("chicken")
//case .pizza:
//    print("pizza")
//@unknown case _:
//    print("default")
//}

let dongho: Optional<String> = "dongho"

/**
 @frozen public enum Optional<Wrapped> : ExpressibleByNilLiteral {

     /// The absence of a value.
     ///
     /// In code, the absence of a value is typically written using the `nil`
     /// literal rather than the explicit `.none` enumeration case.
     case none

     /// The presence of a value, stored as `Wrapped`.
     case some(Wrapped)

     /// Creates an instance that stores the given value.
     public init(_ some: Wrapped)
 */

var myName: String! = "dongho"


if let name = myName {
    print(name)
} else {
    print("nil")
}
