class Mammal {
    let name: String
    init(_ name: String) {
        self.name = name
    }
}

class Human: Mammal {
    let age: Int
    init(_ name: String, _ age: Int) {
        self.age = age
        super.init(name)
    }
    
//    init (){
//        self.name = "df"
//        self.age = 5
//    }
}

// initializer delegation
enum Student {
    case elementary, middle, high
    
    init?(age: Int) {
        switch age {
        case 8...13:
            self = .elementary
        case 14...16:
            self = .middle
        case 17...19:
            self = .high
        default:
            return nil
        }
    }
    
    init?(bornAt: Int, currentYear: Int) {
        self.init(age: currentYear - bornAt + 1)
    }
}

let s1: Student? = Student(age: 19); print(s1)
let s2: Student? = Student(age: 5); print(s2)



// Failable Initializer
class Person2 {
    let name: String
    var age: Int?
    
    init?(name: String) {
        
        // initialization failable calse
        // return nil
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
    
    init?(name: String, age: Int) {
        
        // initialization failable calse
        // return nil
        if name.isEmpty || age < 0{
            return nil
        }
        
        self.name = name
        self.age = age
    }
}

class CLevel {
    var ceo = "ceo"
    
    lazy var cfo : String = {
        return "cfo"
    }()
    
    var clevels: String {
        return self.ceo + self.cfo
    }
}


