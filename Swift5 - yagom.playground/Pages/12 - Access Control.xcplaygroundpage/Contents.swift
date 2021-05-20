public struct SomeType {
    public private(set) var privateVar = 5

    fileprivate var fileprivateVar = 11
    
    init() {
        self.privateVar = 10
    }
}

var dog = SomeType()
print(dog.privateVar)

