import Foundation

class Room {
    var number: Int
    
    init(number: Int) {
        self.number = number
    }
}

class Building{
    var name: String
    var room: Room?
    
    init(name: String) {
        self.name = name
    }
}

let dBuilding: Building = Building(name: "dongho building")

let dRoom = dBuilding.room?.number

let optionalArray: [Int]? = [1, 2, 3]

var optionalDict: [String: [Int]] = [:]
optionalDict["nums"] = optionalArray
print(optionalDict["nums"]?[0])
