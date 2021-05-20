protocol WrappedPrize {
    associatedtype Prize
    
    var wrapColor: String! { get }
    var prize: Prize! { get }
}

protocol Gundam {}
protocol Pokemon {}

struct WrappedGundam: WrappedPrize {
    var wrapColor: String!
    var prize: Gundam!
}

struct WrappedPokemon: WrappedPrize {
    var wrapColor: String!
    var prize: Pokemon!
}

struct Machine {
    func dispense() -> some WrappedPrize {
        return WrappedGundam()
    }
}
let machine = Machine()
let wrappedPrize = machine.dispense()


