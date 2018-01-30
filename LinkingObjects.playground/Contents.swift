import Foundation
import PlaygroundFrameworkWrapper
import RealmSwift

class Person: Object {
    @objc dynamic var name = ""
    override static func primaryKey() -> String? { return "name" }
    let cars = List<Car>()
    override var description: String { return "Person: \(name)"}
}

class Car: Object {
    @objc dynamic var name = ""
    override static func primaryKey() -> String? { return "name" }
    let owners = LinkingObjects(fromType: Person.self, property: "cars")
    override var description: String { return "Car: \(name) \(owners.first?.description ?? "unowned")"}
}

let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))

let tesla  = Car(value: ["name": "Tesla Model S"])
let hector = Person(value: ["name": "Hector"])

try! realm.write {
    hector.cars.append(tesla)
    realm.add(hector)
}

var storedCar1: Car = realm.objects(Car.self).filter("name = 'Tesla Model S'").first!

tesla.isSameObject(as: storedCar1)
tesla.realm == storedCar1.realm
tesla.owners.first // Why is this nil?
storedCar1.owners.first
