// Typealiases allow one type (or composition of types)
// to be referred to by another name
typealias Integer = Int
let myInteger: Integer = 0

// Assignment does not return a value. This means it can't be used in conditional statements,
// and the following statement is also illegal
//     let multipleAssignment = theQuestion = "No questions asked"

// but we can do this:
let multipleAssignment = "No questions asked", secondConstant = "No answers given"

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

// Enums represent the list of possible values
enum Direction {
    North,
    South,
    West,
    East
}

var directionInstance = Direction.North // compiler now has information on which enum is being used
directionInstance = .East // this is now possible due to enum being inferred to be Direction from previous
                          // assignment


// using switch with enums is possible
switch directionInstance {
    case .north:
        print("Going up")
    case .south:
        print("Going down")
    default:
        print("East or West")
}

// to iterate over an enum. add CaseIterable protocol. and case before cases.
enum Beverage: CaseIterable {
    case coffee, tea, juice
}

//                             +---- allCases is now exposed.
//                             v
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")

// for in loop can be used to iterate over allCases
for beverage in Beverage.allCases {
    print(beverage)
}
// coffee
// tea
// juice

// switches and enums provide additional support of being able to init new
// properties for a particular enumeration

enum Barcode {
    case upc(
        numberSystem: Int,
        manufacturer: Int,
        product: Int,
        check: Int
    )
    case qrCode(productCode: String)
}

let productBarcode = Barcode.upc(
    numberSystem: 8,
    manufacturer: 85909,
    product: 51226,
    check: 3
)

switch productBarcode {
    case .upc(
        let numberSystem,
        let manufacturer,
        let product,
        let check
    ): print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")

    case .qrCode(
        let productCode
    ): print("QR code: \(productCode).")
}

// if all are let or var. then we can use let or var outside to capture all.
switch productBarcode {
    case let .upc(
        numberSystem,
        manufacturer,
        product,
        check
    ): print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")

    case var .qrCode(
        productCode
    ): print("QR code: \(productCode).")
}

// if case can be used to work with single case
if case .qrCode(let productCode) = productBarcode {
    print("QR code: \(productCode).")
}

// raw values / default values
// - all must be of same type
// - all must have different values
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
// here we are defining the raw value type to be Character, and assigning raw
// values to each case. if we didnt assign raw values, then the compiler would
// assign them automatically starting from 0 for Int or "" for String and so on.
// we can also use implicit raw values for String enums, where the raw value is
// the same as the case name.

// we can implicitly assign values.
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

enum CompassPoint: String {
    case north, south, east, west
}

// in the example above, CompassPoint.south has an implicit raw value of "south",
// and so on. we access the raw value of an enumeration case with its rawValue property:
let earthsOrder = Planet.earth.rawValue
// earthsOrder is 3

let sunsetDirection = CompassPoint.west.rawValue
// sunsetDirection is "west"

// initializing from raw value
let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
    switch somePlanet {
        case .earth: print("Mostly harmless")
        default: print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
// Prints "There isn't a planet at position 11".

// enumeration & structure
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    func simpleDescription() -> String {
        switch self /* switching over self means over enum cases */ {
            case .ace:
                return "ace"
            case .jack:
                return "jack"
            case .queen:
                return "queen"
            case .king:
                return "king"
            default:
                return String(self.rawValue)
        }
    }
}

let ace = Rank.ace
let aceRawValue = ace.rawValue

enum Suit {
    // we did not define types so no raw values are assigned.
    // we can still use the enum to define properties and methods.
    case spades, hearts, diamonds, clubs

    func simpleDescription() -> String {
        switch self {
            case .spades: return "spades"
            case .hearts: return "hearts"
            case .diamonds: return "diamonds"
            case .clubs: return "clubs"
        }
    }
}

let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

/*
 
Structures and classes in Swift have many things in common. Both can:
 
- Define properties to store values.
    - instance properties are properties that belong to an instance of a class or struct. they can be stored or computed.

        struct User {
            var name: String = "Name" // this is a stored property with a default value.
                                      // it can also be var or let.
            var age: Int = 0
        }

    - stored properties means the value is stored in memory. can be var or let.

        struct User {
            var name: String
            var age: Int
        }

    - computed properties on the other hand do not store a value,
      but provide a getter and an optional setter to retrieve and set other
      properties and values indirectly.

        struct Rectangle {
            var width: Double
            var height: Double

            var area: Double {
                width * height
            } // here the area is a computed property.
        }
    
    - static properties belong to the type itself, rather than to instances of the type.
      they are shared across all instances.

        struct User {
            static var userCount: Int = 0

            var name: String
            var age: Int

            init(name: String, age: Int) {
                self.name = name
                self.age = age

                User.userCount += 1 // increment user count whenever a new user is created
            }
        }

- Define methods to provide functionality
    - instance methods simply means functions that belong to an instance of a class or struct.
      they can access and modify the properties of the instance.

        struct User {
            var name: String
            var age: Int

            func greet() {
                print("Hi, I'm \(name)!")
            }
        }
    
- Define subscripts to provide access to their values using subscript syntax
    - subscripts are shortcuts for accessing the member elements of a collection,
      list, or sequence. they can be defined for classes, structs, and enums.

        struct NamesTable {
            let names: [String]

            // custom subscript
            subscript(index: Int) -> String {
                return names[index]
            }
        }

- Define initializers to set up their initial state.

    swift enforces that we initialize all properties of a class or struct
    before we can use an instance of it. we can do this by providing default
    values for all properties, or by defining an initializer that sets the
    initial values for the properties.

    or another approach is to define optional types which uses nil by default.

        struct User {
            var name: String
            var age: Int

            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
        }

- Be extended to expand their functionality beyond a default implementation
    - extensions can add new functionality to an existing class, struct, enum, or protocol type.
      this includes the ability to extend types for which we do not have access to the
      original source code (known as retroactive modeling).

      extensions are similar to categories in Objective-C, but they don't have names
      and they can't add stored properties.

        extension Int {
            var squared: Int {
                return self * self
            }
            // here the Int type is extended to have a new computed property
            // called squared.
        }

        extension Int {
            var doubled: Int {
                return self * 2
            }

            func multipliedBy(num: Int) -> Int {
                return num * self
            }

            mutating func multiplyBy(num: Int) {
                self *= num
            }
        }


      we can use constrained protocol extensions to provide default implementations
      of protocol requirements.

        protocol Greetable {
            var name: String { get }
            func greet()
        }

        extension Greetable {
            func greet() {
                print("Hello, I'm \(name)!")
            }
        } // this is generic implementation of the greet() method for any type
          // that conforms to the Greetable protocol. any type that conforms
          // to Greetable will now
        
        extension Greetable where self == Int {
            func greet() {
                print("Hello, I'm the number \(name)!")
            }
        } // this is a constrained protocol extension that provides a default implementation of the
          // greet() method for any type that conforms to the Greetable protocol and
          // is also an Int. any type that conforms to Greetable and is an Int will
          // now have access to this implementation of the greet() method instead of
          // the generic one provided above.
        

- Conform to protocols to provide standard functionality of a certain kind
    - protocols define a blueprint of methods, properties, and other requirements
      that suit a particular task or piece of functionality.
      
      classes, structs, and enums can all conform to protocols.

        protocol Greetable {
            func greet()
        }

        struct User: Greetable {
            var name: String
            var age: Int

            func greet() {
                print("Hi, I'm \(name)!")
            }
        }

Classes have additional capabilities that structures don't have:

- Inheritance enables one class to inherit the characteristics of another.
    - A class can inherit from another class, which is called its superclass.
      The class that inherits is called a subclass. A subclass can override
      the characteristics of its superclass and can add new characteristics
      to those it inherits.

        class Vehicle {
            var currentSpeed = 0.0 // stored property with default value

            var description: String {
                return "traveling at \(currentSpeed) KM per hour"
            }

            func makeNoise() {}
        }

        class Bicycle: Vehicle {
            override var currentSpeed: Double {
                didSet {
                    print("Bicycle speed changed to \(currentSpeed)")
                }
            }

            override func makeNoise() {
                print("ring ring")
            }
        }

- Type casting enables us to check and interpret the type of a class instance at runtime.
- Deinitializers enable an instance of a class to free up any resources it has assigned.

    class Bank {
        static var coinsInBank = 10_000

        static func vendCoins(_ numberOfCoinsRequested: Int) -> Int {
            let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
            coinsInBank -= numberOfCoinsToVend
            return numberOfCoinsToVend
        }

        static func receiveCoins(_ coins: Int) {
            coinsInBank += coins
        }

        deinit {
            Bank.receiveCoins(coinsInBank)
        }
    }

- Reference counting allows more than one reference to a class instance.

-------------------------------------------------------------------------------

Unless we need to use a class for one of these reasons, use a struct.

Structures are value types, while classes are reference types. i.e.

    struct User {
        var name: String
    }

    copying creates a new instance of the struct with the same values,
    while copying a class instance creates a new reference to the same instance.

    var a = User(name: "A")
    var b = a
    b.name = "B"
    print(a.name) // A

    class User {
        var name: String

        init(name: String) {
            self.name = name
        }
    }

    copying creates a new reference to the same instance.
    (closer to `shared_ptr<T>` behavior.)

    let a = User(name: "A")
    let b = a
    b.name = "B"
    print(a.name) // B

If something is expensive to initialize, but may not always be needed,
consider defining it as a lazy property.

A lazy property is a property whose initial value is not calculated until the
first time it is used. We indicate a lazy stored property by writing the
lazy modifier before its declaration.

class DataManager {
    lazy var data: [Int] = {
        return [1, 2, 3]
    }()
}

*/

/*
 Swift has five levels of access control:
 - Open: Accessible *and subclassible* in any module that imports it.
 - Public: Accessible in any module that imports it, subclassible in the module it is declared in.
 - Internal: Accessible and subclassible in the module it is declared in.
 - Fileprivate: Accessible and subclassible in the file it is declared in.
 - Private: Accessible and subclassible in the enclosing declaration (think inner classes/structs/enums)

 See more here: <https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol>

*/

struct NamesTable {
    let names: [String]

    // custom subscript
    subscript(index: Int) -> String {
        return names[index]
    }
}

// structures have an auto-generated (implicit) designated "memberwise" initializer
let namesTable = NamesTable(names: ["Me", "Them"])
let name = namesTable[1]
print("Name is \(name)") // Name is Them


// initializer to set up the class when an instance is created.
class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    // every value needs to be assigned. either here or with a initializer

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides"
    }
}

// writing final before class or instance method makes it so that the class
// or a property cannot be overridden by subclasses.

// use deinit to create a deinitializer if we need to perform some cleanup
// before the object is deallocated.

class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
       self.name = name
    }

    func simpleDescription() -> String {
       return "A shape with \(numberOfSides) sides."
    }
}

// Square subclasses NamedShape
class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }

    func area() -> Double {
        return sideLength * sideLength
    }

    // to override the function use override keyword. compiler will
    // |   error if the function doesnt exist but is being overriden or if the
    // |   function does exist but one is not using the keyword override.
    // |
    // v
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}

let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

// the test variable makes sure that // simpleDescription is called.

// Make another subclass of NamedShape called Circle that takes a radius and a name
// as arguments to its initializer. Implement an area() and a simpleDescription()
// method on the Circle class.
class Circle: NamedShape {
    var radius: Double

    init(radius: Double, name: String) {
        self.radius = radius
        super.init(name: name)
    }

    func area() -> Double {
        return 2 * 3.1415 * radius
    }

    override func simpleDescription() -> String {
        return "a simple circle with the radius of \(radius)"
    }
}

class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
             return 3.0 * sideLength
        }              // +------- implicit name of the value being received.
                       // |
        set {          // v
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
// Prints "9.3".
triangle.perimeter = 9.9
print(triangle.sideLength)
// Prints "3.3000000000000003".

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

// we can use willset and didset. these are called property observers.
// they run every time the property is set, even if the new value is the
// same as the old value. they are not called when the property is set
// in an initializer before super.init() is called.
class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        // before setter is called
        willSet {
            square.sideLength = newValue.sideLength
        }
        // runs after setter has been called
        // didSet {}
    }
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
// Prints "10.0".
print(triangleAndSquare.triangle.sideLength)
// Prints "10.0".
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)
// Prints "50.0".

// why not just use set and get blocks?
class Foo {
    var myProperty: Int = 0 {
        didSet {
            print("The value of myProperty changed from \(oldValue) to \(myProperty)")
        }
    }
}

class Foo {
    var myPropertyValue: Int = 0
    var myProperty: Int {
        get { return myPropertyValue }
        set {
            print("The value of myProperty changed from \(myPropertyValue) to \(newValue)")
            myPropertyValue = newValue
        }
    }
}

// structs can be used to make custom data types.
struct Person {
    var name: String
    var age: Int
    func greet() {
        print("Hi, I'm \(name)!")
    }
}

let person = Person(name: "Alice", age: 12)
person.greet()

let p = Person(name: "Sudan", age: 22)
p.greet()

// String enums can have direct raw value assignments
// or their raw values will be derived from the Enum field
enum BookName: String {
    case john
    case luke = "Luke"
}
print("Name: \(BookName.john.rawValue)")

// Enum with associated Values
// i.e. enums that store extra data per case.
// associated values are not raw values.
// they are values that are stored along with the enum case when it is created.
// they can be of any type and can be different for each case.
// and they dynamic runtime values.
enum Furniture {
    // Associate with Int
    case desk(height: Int)
    // Associate with String and Int
    case chair(String, Int)

    func description() -> String {
        //either placement of let is acceptable
        switch self {
        case .desk(let height):
            return "Desk with \(height) cm"
        case let .chair(brand, height):
            return "Chair of \(brand) with \(height) cm"
        }
    }
}

var desk: Furniture = .desk(height: 80)
print(desk.description())     // "Desk with 80 cm"
var chair = Furniture.chair("Foo", 40)
print(chair.description())    // "Chair of Foo with 40 cm"

class Shape {
    func getArea() -> Int {
        return 0
    }
}

class Rect: Shape {
    var sideLength: Int = 1

    // Custom getter and setter property
    var perimeter: Int {
        get {
            return 4 * sideLength
        }
        set {
            // `newValue` is an implicit variable available to setters
            sideLength = newValue / 4
        }
    }

    // Computed properties must be declared as `var`, as they can change
    var smallestSideLength: Int {
        return self.sideLength - 1
    }

    // Lazily load a property
    // subShape remains nil (uninitialized) until getter called
    lazy var subShape = Rect(sideLength: 4)

    // If we don't need a custom getter and setter,
    // but still want to run code before and after getting or setting
    // a property, we can use `willSet` and `didSet`
    var identifier: String = "defaultID" {
        // the `someIdentifier` arg will be the variable name for the new value
        willSet(someIdentifier) {
            print(someIdentifier)
        }
    }

    init(sideLength: Int) {
        self.sideLength = sideLength
        // always super.init last when init custom properties
        super.init()
    }

    func shrink() {
        if sideLength > 0 {
            sideLength -= 1
        }
    }

    override func getArea() -> Int {
        return sideLength * sideLength
    }
}

// A simple class `Square` extends `Rect`
class Square: Rect {
    // Use a convenience initializer to make calling a designated initializer faster and more "convenient".
    // Convenience initializers call other initializers in the same class and pass default values to one or more of their parameters.
    // Convenience initializers can have parameters as well, which are useful to customize the called initializer parameters or choose a proper initializer based on the value passed.
    convenience init() {
        self.init(sideLength: 5)
    }
}

var mySquare = Square()
print(mySquare.getArea()) // 25
mySquare.shrink()
print(mySquare.sideLength) // 4

// cast instance
let aShape = mySquare as Shape

// downcast instance: 
// Because downcasting can fail, the result can be an optional (as?) or an implicitly unwrpped optional (as!).  
let anOptionalSquare = aShape as? Square // This will return nil if aShape is not a Square
let aSquare = aShape as! Square // This will throw a runtime error if aShape is not a Square

// compare instances, not the same as == which compares objects (equal to)
if mySquare === mySquare {
    print("Yep, it's mySquare")
}

// Optional init
class Circle: Shape {
    var radius: Int
    override func getArea() -> Int {
        return 3 * radius * radius
    }

    // Place a question mark postfix after `init` is an optional init
    // which can return nil
    // i.e. failable initializer.
    init?(radius: Int) {
        self.radius = radius
        super.init()

        if radius <= 0 {
            return nil
        }
    }
}

var myCircle = Circle(radius: 1)
print(myCircle?.getArea())    // Optional(3)
print(myCircle!.getArea())    // 3
var myEmptyCircle = Circle(radius: -1)
print(myEmptyCircle?.getArea())    // "nil"
if let circle = myEmptyCircle {
    // will not execute since myEmptyCircle is nil
    print("circle is not nil")
}

// Protocols are roughly interfaces that define a construct that must be conformed to.
// For example:
protocol Animal {
    func speak()
}

protocol Pet: Animal {
    func play()
} 

// Pet inherits requirements from Animal. We can enforce the conformance by a type
// as such
struct Dog: Pet {
    func speak() {
        print("woof")
    }

    func  play() {
        print("playing")
    }
}

// `protocol`s can require that conforming types have specific
// instance properties, instance methods, type methods,
// operators, and subscripts.
protocol ShapeGenerator {
    var enabled: Bool { get set }
    func buildShape() -> Shape
}
// to conform to this protocol, a type must have an instance property
// called enabled that is gettable and settable, and an instance method
// called buildShape() that returns a Shape.

// protocol extensions allows us to provide default implementations of
// methods and properties. this means that we can define a protocol with
// some requirements, and then provide default implementations of those
// requirements in an extension.
protocol Greetable {
    var name: String { get }
}

extension Greetable {
    func greet() {
        print("Hello \(name)")
    }
}
// here the Greetable protocol requires a name property, but it provides a default
// implementation of the greet() method. any type that conforms to Greetable will
// have access to the greet() method without having to implement it themselves, as
// long as they provide a name property.

// to provide our own implementation of the greet() method, we can simply
// implement it in the type that conforms to the protocol. this will override the
// default implementation provided by the protocol extension.
struct Person: Greetable {
    var name: String
    func greet() {
        print("Hi, I'm \(name)!")
    }
}

// Optional protocol requirements:

// via @objc and optional keywords.

    // only for classes that inherit from NSObject and protocols marked with @objc.
    // this is because the optional requirements are implemented using Objective-C
    // runtime features, which are only available for classes that inherit from
    // NSObject and protocols marked with @objc.

    // Source - https://stackoverflow.com/a/24032961
    // Posted by akashivskyy, modified by community. See post 'Timeline' for change history
    // Retrieved 2026-05-11, License - CC BY-SA 4.0

@objc protocol MyProtocol {
    @objc optional func doSomething()
}

class MyClass: NSObject, MyProtocol {
    /* no compile error */
}

// Advantages

// No default implementation is needed. We just declare an optional method or a
// variable and we're ready to go.

// Disadvantages

// It severely limits our protocol's capabilities by requiring all conforming types
// to be Objective-C compatible. This means, only classes that inherit from NSObject
// can conform to such protocol. No structs, no enums, no associated types.

// We must always check if an optional method is implemented by either optionally
// calling or checking if the conforming type implements it. This might introduce
// a lot of boilerplate if we're calling optional methods often.

// ------------------------------------------------------------------------------------

// Swift nudges everyone to follow protocol-oriented programming,
// which is a design paradigm that emphasizes the use of protocols and protocol
// extensions to achieve code reuse and flexibility.

// Rather than using inheritance to share code and behavior, we can define protocols
// that describe the behavior we want, and then use protocol extensions to provide
// default implementations of that behavior.

// Existential types are just Any types that confirms to a specific protocol
// .
// It basically express a type-erased value, where the actual type is not known
// statically, and at runtime it can be any type that conforms to the specified protocol.

// Because the possible types can vary in size, the representation of such a value
// is an "existential container" and the actual represented value is stored either
// inline (when it fits) or indirectly as a pointer to a heap allocation. There are
// also multiple concrete representations of the existential container that are
// optimized for different constraints (e.g. for class-bound existentials, the value
// does not make sense to ever store inline, so the size of the container is matched
// to hold exactly one pointer).

    // Any and AnyObject

    // Swift has support for storing a value of any type.
    // For that purpose there are two keywords: `Any` and `AnyObject`
    // `AnyObject` == `id` from Objective-C
    // `Any` works with any values (class, Int, struct, etc.)
    var anyVar: Any = 7
    anyVar = "Changed value to a string, not good practice, but possible."
    let anyObjectVar: AnyObject = Int(1) as NSNumber

// in this case the following example would explain this much better:
let value: any Animal
// this roughly translates to value can hold any concrete type that conforms to Animal.
// i.e.
struct Dog: Animal {
    func speak() {
        print("woof")
    }
}
struct Cat: Animal {
    func speak() {
        print("meow")
    }
}
// Then:
let value: any Animal = Dog()
// later could also become:
let value: any Animal = Cat()
// as exact concrete type is hidden behind the protocol.

// Generics can enforce this at compile time, while still allowing for
// flexibility and code reuse.

// Generics let we write code that works with multiple types while preserving
// concrete type information.

// Here's a standard, nongeneric function called `swapTwoInts(_:_:)`,
// which swaps two Int values:
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// Prints "someInt is now 107, and anotherInt is now 3".

// to make this into a generic function, 
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)

// here's how to write a nongeneric version of a stack, in this case for a stack
// of Int values:
struct IntStack {
    var items: [Int] = []

    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}
// This structure uses an Array property called items to store the values in the stack.
// Stack provides two methods, push and pop, to push and pop values on and off the stack.

// These methods are marked as mutating, because they need to modify (or mutate) the
// structure's items array.

// The IntStack type shown above can only be used with Int values, however.
// It would be much more useful to define a generic Stack structure, that can manage
// a stack of any type of value.

// here's a generic version of the same code:

struct Stack<Element> {
    var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        return items.removeLast()
    }
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
let fromTheTop = stackOfStrings.pop()
// fromTheTop is equal to "cuatro", and the stack now contains 3 strings

// When we extend a generic type, we don't provide a type parameter list as part
// of the extension's definition. Instead, the type parameter list from the original
// type definition is available within the body of the extension, and the original
// type parameter names are used to refer to the type parameters from the original
// definition.

// The following example extends the generic Stack type to add a read-only computed
// property called topItem, which returns the top item on the stack without popping
// it from the stack:

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

// The topItem property returns an optional value of type Element. If the stack is
// empty, topItem returns nil; if the stack isn't empty, topItem returns the final
// item in the items array.

// Note that this extension doesn't define a type parameter list. Instead, the Stack
// type's existing type parameter name, Element, is used within the extension to
// indicate the optional type of the topItem computed property.

// The topItem computed property can now be used with any Stack instance to access and
// query its top item without removing it.

if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}
// Prints "The top item on the stack is tres."

// we can narrow the generic type of an extension by specifying a type constraint
// on the type parameter or parameters in the extension's definition.
struct Stack<Element: Equatable> {
    // this means the Element can be whatever type but it must conform to the
    // Equatable protocol.
    var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        return items.removeLast()
    }
}

    // another approach is to add the constraint in the extension itself,
    // which means the original Stack type is still generic over any type,
    // but the extension is only available for Stack instances where the
    // Element type conforms to Equatable.

// however besides that the actual difference is that where clause allows
// us to add constraints on multiple type parameters and also on the
// associated types of protocols, while the approach above only allows us to
// add constraints on the type parameters of the generic type itself.

extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = self.topItem else {
            return false
        }
        return topItem == item
    }
}

// we are able to do something like this
func compare<T, U>(_ a: T, _ b: U) where T: Equatable, T == U {
    print(a == b)
}
// this is a rust style generic function that takes two parameters of different types,
// but with the constraint that they must be the same type and that type must conform
// to the Equatable protocol. This means that we can only call this function with two
// parameters of the same type that conforms to Equatable, and we can compare them for
// equality.

func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
findIndex(array: [1, 2, 3, 4], valueToFind: 3) // Optional(2)

// You can extend types with generics as well
extension Array where Array.Element == Int {
    var sum: Int {
        var total = 0
        for el in self {
            total += el
        }
        return total
    }
}

// associated types are a powerful feature of Swift's protocol system that allow us
// to define a placeholder type within a protocol, which can then be specified by
// the conforming types. This allows us to write more flexible and reusable code,
// as we can define protocols that work with any type that conforms to the protocol,
// without having to specify the exact types in advance.

protocol Container {
    associatedtype Item
    // Item is a placeholder type inside the protocol.

    mutating func append(_ item: Item)
    var count: Int { get }
}
// a conforming type would be
struct IntContainer: Container {
    var items: [Int] = []
    // items is the actual type that will be used for the associated
    // type Item in the Container protocol.

    mutating func append(_ item: Int) {
        items.append(item)
    }

    var count: Int {
        items.count
    }
}

// now for the protocol approach vs generic approach for previous example.
func feed(_ animal: any Animal)
// this accepts any type that conforms to the Animal protocol, but we lose the
// concrete type information of the animal at compile time. we can only call
// methods defined in the Animal protocol on the animal parameter, and we
// cannot access any properties or methods that are specific to the concrete
// type of the animal.
func feed<T: Animal>(_ animal: T)
// where as this preverse the exact type.

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

// Custom operators can start with the characters:
//      / = - + * % < > ! & | ^ . ~
// or
// Unicode math, symbol, arrow, dingbat, and line/box drawing characters.
prefix operator !!!

// a prefix operator that triples the side length when used
prefix func !!! (shape: inout Square) -> Square {
    shape.sideLength *= 3
    return shape
}

// current value
print(mySquare.sideLength) // 4

// change side length using custom !!! operator, increases size by 3
!!!mySquare
print(mySquare.sideLength) // 12

// Operators can also be generics
infix operator <->
func <-><T: Equatable> (a: inout T, b: inout T) {
    let c = a
    a = b
    b = c
}

var foo: Float = 10
var bar: Float = 20

foo <-> bar
print("foo is \(foo), bar is \(bar)") // "foo is 20.0, bar is 10.0"

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

// Error handling is built around three ideas:
// - marking functions that can fail,
// - calling them safely, and
// - deciding what to do when they fail.

// function that can fail is marked with throws:
enum FileError: Error {
    case notFound
}

func loadFile() throws -> String {
    throw FileError.notFound
}

// when we call a throwing function, we must acknowledge the risk using try:

let content = try loadFile()

// however this is not enough because errors must be handled.
// to handle errors, we use do-catch blocks:
do {
    let content = try loadFile()
    print(content)
} catch {
    print("Failed with error: \(error)")
}

// to propagate errors up the call stack, we can mark our own function with throws and call the throwing function with try:
func process() throws {
    let content = try loadFile()
    print(content)
}
// we can use try? to convert the throwing expression into an optional value,
// which will be nil if an error is thrown:
let content = try? loadFile()
// if it succeeds, we get .some(value).
// if it fails, we get nil.
// the error however is discarded.

// try! forces success. i.e.
let content = try! loadFile()
// if it fails, the program crashes.
// only safe when we are absolutely sure no error can occur.

// The `Error` protocol is used when throwing errors to catch
enum MyError: Error {
    case badValue(msg: String)
    case reallyBadValue(msg: String)
}

func fakeFetch(value: Int) throws -> String {
    guard 7 == value else {
        throw MyError.reallyBadValue(msg: "Some really bad value")
    }

    return "test"
}

func testTryStuff() {
    let _ = try! fakeFetch(value: 7)

    let _ = try? fakeFetch(value: 7)

    do {
        try fakeFetch(value: 1)
    } catch MyError.badValue(let msg) {
        print("Error message: \(msg)")
    } catch {
        // must be exhaustive
    }
}
testTryStuff()

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

// Memory Management

// every class instance has a reference count.
// when it drops to zero, the object is deallocated.
class Person {
    let name: String
    init(name: String) { self.name = name }
    deinit { print("deallocated") }
}
var p: Person? = Person(name: "A")
p = nil
// at this point ARC removes the object.

// strong references are the default. they keep the object alive.
// weak references do not keep the object alive.
// they are optional and automatically set to nil when the object is deallocated.
class Person {
    let name: String
    init(name: String) { self.name = name }
    deinit { print("deallocated") }
}

var p1: Person? = Person(name: "A")
var p2: Person? = p1 // strong reference to the same object

p1 = nil // object is still alive because p2 has a strong reference to it
p2 = nil // object is deallocated because there are no more strong references to it

// or
class A {
    weak var delegate: B?
}
// if B is deallocated, the delegate property will automatically be set to nil,
// preventing a dangling pointer and potential crash when trying to access the
// delegate.

// unowned references are like weak, but they are non-optional. used when we
// are certain the referenced object will outlive the current object.
class A {
    unowned var owner: B
}
// if B is deallocated first, this becomes a crash.
// so it is a strict assumption.

// retain cycles forms when two or more objects hold strong references to each other,
// such that they keep each other alive and prevent deallocation.
class A {
    var b: B?
}
class B {
    var a: A?
}
// to prevent this, make one of the references weak or unowned, depending
// on the relationship between the objects.
class B {
    weak var a: A?
}
// now When A is deallocated, the reference to it in B will automatically
// be set to nil, allowing B to be deallocated as well if there are no
// other strong references to it.


// a more common example of retain cycle is when we have a closure that
// captures self strongly, and self has a strong reference to the closure.
// this can be prevented by using a capture list to capture self weakly or
// unowned in the closure.
class MyClass {
    var closure: (() -> Void)?

    func setupClosure() {
        closure = { [weak self] in
        // or
        // closure = { [unowned self] in 
            // we are capturing self weakly, so we need to unwrap it
            // safely before using it.

            // when MyClass is deallocated, the closure will not keep it alive,
            // and the closure will not execute it as the self it owns is now nil.
            guard let self = self else { return }
            print("Hello from closure, \(self)")
        }
    }
}
// here the closure captures self weakly, so if MyClass is deallocated, the
// closure will not keep it alive, and the closure will not execute if it
// is called after MyClass.


//-------------------------------------------------------------------------------//

protocol MyDelegate: AnyObject {

}

// TODO:

// delegate
// KeyPath and dynamic member lookup
