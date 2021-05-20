//: [Previous](@previous)

import Foundation

class Person{
    var name: String = ""
    var age: Int = 0 {
        didSet{
            print("Person, age, didset")
        }
    }
    
    var koreanAge: Int {
        return self.age + 1
    }
    
    var fullName: String {
        get {
            return self.name
        }
        set {
            self.name = newValue
        }
    }
    
}

class Student: Person {
    var grade: String = "F"
    
    override var age: Int {
        didSet {
            print("Student, age, didset")
        }
    }
    
    override var koreanAge: Int {
        get {
            return super.koreanAge
        }
        set {
            self.age = newValue - 1
        }
    }
    
    override var fullName: String {
        didSet{
            print("Student, fullName, didSet")
        }
    }
    
    override init() {
        super.init()
        self.age = 10
    }
}

let d: Student = Student()
d.name = "dongho"
d.age = 21
d.koreanAge = 22
d.fullName = "choi dongho"

//: [Next](@next)
