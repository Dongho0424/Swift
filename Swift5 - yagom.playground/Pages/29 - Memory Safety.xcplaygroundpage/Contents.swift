func address(of object: AnyObject) {
    print(Unmanaged.passUnretained(object).toOpaque())
}
func address(of object: inout Any){
    withUnsafePointer(to: &object) { print($0) }
}

var step: Int = 1
func increment(_ num: inout Int) {
    num += step
}
// increment(&step)

func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}

struct Player {
    var name: String; var health: Int; var energy: Int
    static let maxHealth = 10
    
    mutating func restoreHealth() { self.health = Player.maxHealth }
    
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &self.health)
    }
}

var oscar = Player(name: "oscar", health: 10, energy: 10)
var maria = Player(name: "maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)
print(oscar.health)
print(maria.health)

// 같은 oscar 변수의 프로퍼티에 접근하는 것도 제한됨
// struct의 instance 이므로
// balance(&oscar.health, &oscar.energy)

// 변수 접근의 범위를 제한, 즉 로컬 변수이면 문제 없음
func boo() {
    var oscar = Player(name: "oscar", health: 10, energy: 10)
    balance(&oscar.health, &oscar.energy)
}
boo()
