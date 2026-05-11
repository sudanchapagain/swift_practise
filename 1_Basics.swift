/*

- The Swift Programming Language: <https://docs.swift.org/swift-book>

Swift is a programming language created by Apple for development across all
Apple operating systems. Designed to coexist with Objective-C while being more
resilient against erroneous code, Swift was introduced in 2014 at Apple's
developer conference WWDC.

*/
import Foundation

/*

import works at a module level and modules are collections of Swift code
compiled together. Foundation is one such module.

Swift Packages are the main way to organize multiple files or modules in
Swift projects via the Swift Package Manager (SPM).

Example:

MyPackage/
├─ Package.swift
├─ Sources/
│   ├─ ModuleA/FileA.swift
│   └─ ModuleB/FileB.swift
└─ Tests/ModuleATests/

each folder in `Sources/` is a module. to use code from `ModuleA` in
`ModuleB`, we write `import ModuleA`.

swift files under the same module are under the same scope so no need to
import even if they exist in different files.

So if you have:

Sources/ModuleA/
 ├─ File1.swift
 └─ Subfolder/File2.swift


`File1.swift` and `Subfolder/File2.swift` can freely use each other.
the subfolder is just for organization. it does not create a new module.

also, by default, Swift symbols are `internal` i.e. visible only in their
module. to expose them to other modules:

public struct MyStruct {
    public init() {}
}

So, directories are just for organization.

*/

func main() {
    // to make a constant
    let a = 29
    print(a)
    // variable
    var b = 20
    b = 10

    // MARK: Other variables
    let øπΩ = "value" // unicode variable names
    let 🤯 = "wow" // emoji variable names

    // keywords can be used as variable names
    // these are contextual keywords that wouldn't be used now, so are allowed
    let convenience = "keyword"
    let weak = "another keyword"
    let override = "another keyword"

    // using backticks allows keywords to be used as variable
    // names even if they wouldn't be allowed normally
    let `class` = "keyword"

    // types are inferred
    let implicitInteger = 70
    let implicitDouble = 70.0
    let explicitDouble: Double = 70

    let label = "The width is "
    let width = 94
    // you must always type cast
    let widthLabel = label + String(width)

    /*
     Optionals are a Swift language feature that either contains a value,
     or contains nil (no value) to indicate that a value is missing.
     Nil is roughly equivalent to `null` in other languages.
     A question mark (?) after the type marks the value as optional of that type.

     If a type is not optional, it is guaranteed to have a value.

     Because Swift requires every property to have a type, even nil must be
     explicitly stored as an Optional value.

     Optional<T> is an enum, with the cases .none (nil) and .some(T) (the value)
     */

    var someOptionalString: String? = "optional" // Can be nil
    // T? is shorthand for Optional<T> — ? is a postfix operator (syntax candy)
    let someOptionalString2: Optional<String> = nil
    let someOptionalString3 = String?.some("optional") // same as the first one
    let someOptionalString4 = String?.none //nil

    /*
     To access the value of an optional that has a value, use the postfix
     operator !, which force-unwraps it. Force-unwrapping is like saying, "I
     know that this optional definitely has a value, please give it to me."

     Trying to use ! to access a non-existent optional value triggers a
     runtime error. Always make sure that an optional contains a non-nil
     value before using ! to force-unwrap its value.
     */

    if someOptionalString != nil {
        // I am not nil
        if someOptionalString!.hasPrefix("opt") {
            print("has the prefix")
        }
    }
    // if someValue {}
    // this will throw error as someValue being a value doesnt not mean boolean state.

    // Swift supports "optional chaining," which means that you can call functions
    //   or get properties of optional values and they are optionals of the appropriate type.
    // You can even do this multiple times, hence the name "chaining."

    let empty = someOptionalString?.isEmpty // Bool?
    // if-let structure -
    // if-let is a special structure in Swift that allows you to check
    //   if an Optional rhs holds a value, and if it does unwrap
    //   and assign it to the lhs.
    if let someNonOptionalStringConstant = someOptionalString {
        // has `Some` value, non-nil
        // someOptionalStringConstant is of type String, not type String?
        if !someNonOptionalStringConstant.hasPrefix("ok") {
            // does not have the prefix
        }
    }

    // if-var is allowed too!
    if var someNonOptionalString = someOptionalString {
        someNonOptionalString = "Non optional AND mutable"
        print(someNonOptionalString)
    }

    // You can bind multiple optional values in one if-let statement.
    //   If any of the bound values are nil, the if statement does not execute.
    if let first = someOptionalString, let second = someOptionalString2,
        let third = someOptionalString3, let fourth = someOptionalString4 {
        print("\(first), \(second), \(third), and \(fourth) are all not nil")
    }

    // if-let supports "," (comma) clauses, which can be used to
    //   enforce conditions on newly-bound optional values.
    // Both the assignment and the "," clause must pass.
    let someNumber: Int? = 7
    if let num = someNumber, num > 3 {
        print("num is not nil and is greater than 3")
    }
    // Implicitly unwrapped optional — An optional value that doesn't need to be unwrapped
    let unwrappedString: String! = "Value is expected."

    // Here's the difference:
    let forcedString = someOptionalString! // requires an exclamation mark
    let implicitString = unwrappedString // doesn't require an exclamation mark

    /*
     You can think of an implicitly unwrapped optional as giving permission
     for the optional to be unwrapped automatically whenever it's used.
     Rather than placing an exclamation mark after the optional's name each time you use it,
     you place an exclamation mark after the optional's type when you declare it.
    */

    // Otherwise, you can treat an implicitly unwrapped optional the same way the you treat a normal optional
    //   (i.e., if-let, != nil, etc.)

    // Pre-Swift 5, T! was shorthand for ImplicitlyUnwrappedOptional<T>
    // Swift 5 and later, using ImplicitlyUnwrappedOptional throws a compile-time error.
    //var unwrappedString2: ImplicitlyUnwrappedOptional<String> = "Value is expected." //error

    // The nil-coalescing operator ?? unwraps an optional if it contains a non-nil value, or returns a default value.
    someOptionalString = nil
    let someString = someOptionalString ?? "abc"
    print(someString) // abc
    // a ?? b is shorthand for a != nil ? a! : b

    // types are: Int, Double, Float, Bool, String, Character

    // operators in swift include:
    // - arithmetic: +, -, *, /, %
    // - comparison: ==, !=, <, >, <=, >=
    // - assignment: =
    //
    //      NOTE: assignment operator can perform tuple destructuring
    //           let (x, y) = (1, 2)
    //           also unlike the assignment operator in C and Objective-C,
    //           the assignment operator in Swift doesn't itself return a
    //           value. The following statement isn't valid:
    //           if x = y { // This isn't valid, because x = y doesn't return
    //                      // a value.
    //           }
    //
    // - compound assignment: +=, -=, *=, /=, %=
    // - logical: !, &&, ||
    // - ternary: ? :
    // - bitwise: &, ^, ~, <<, >>
    // - identity/reference: !==, ===

    // condition checking
    if a == 29 && b == 10 {
        print("correct")
    } else {
        print("incorrect")
    }

    let teamScore = 20
    let scoreDecoration = if teamScore > 10 {
        "🎉"
    } else {
        ""
    }
    print("score:", teamScore, scoreDecoration)

    let label = "The width is " + String(teamScore)
    let width = 94
    // To avoid escaping double quotes and backslashes, change the string delimiter
    let explanationString = #"The string I used was "The value of aDouble is \(aDouble)" and the result was \#(descriptionString)"#
    // You can put as many number signs as you want before the opening quote,
    //   just match them at the ending quote. They also change the escape character
    //   to a backslash followed by the same number of number signs.

    // let widthLabel = label + \(width) // does not work
    // print(widthLabel)

    let apples = 1
    let oranges = 2
    let quotation = """
            Even though there's whitespace to the left,
            the actual lines aren't indented.
                Except for this line.
            Double quotes (") can appear without being escaped.

            I still have \(apples + oranges) pieces of fruit.
         """ // this denotes the indent size

    print(quotation)

    // to check for value or nil, if let can be used
    var optionalString: String? = "Hello"
    print(optionalString == nil)
    // Prints "false".

    var optionalName: String? = "John Appleseed"
    var greeting = "Hello!"

    if let name = optionalName {
        greeting = "Hello, \(name)"
    }
    print(greeting)

    let input: String? = "42"
    //     +-----------+---------- shadowing the `optional string` to be `non-optional string`
    //     v           v
    if let input = input,
    // however the shadow type is only for this scope. i.e. inside the if block.
       let number = Int(input) {
       print(number * 2)
    }

    let username: String? = "user123"
    let password: String? = "pass456"

    if let username = username,
       let password = password,
       password.count > 5 {
        print("Valid login for \(username)")
    }

    // you can use a default value instead of nil with the ?? syntax.
    let nickname: String? = nil
    let fullName: String = "John Appleseed"
    let informalGreeting = "Hi \(nickname ?? fullName)"

    // shorter and concise syntax sugar
    if let nickname {
        print("Hey, \(nickname)")
    }

    // guard: early-exit validation construct
    // i.e. a standardized pattern for this
    /*
    if (!condition) {
        return / break / continue / throw;
    }
    */
    // +---marks expression that must be true to continue execution of the code after the guard statement
    // |
    // |                    +----- scope of the guard statement
    // |                    |
    // V                    V
    guard let name = name else {
        // here we check if name is nil, and if it is, we exit the function early
        print("No name provided.")
        return
    }
    // else we continue.
    print("Hello, \(name)!")
    // so guards basically allow us to avoid pyramid of doom &
    // nested ifs by handling the error case early and exiting,
    // so that the main logic can be at the same level of indentation.

    // while its just a syntax sugar. the guard keyword specifically
    // indicates to the compiler that this else block is being written
    // to handle the error case and exit early, so it forces it to be
    // a valid exit statement (break, continue, return, throw) and not just
    // some random code that doesn't exit, which is a common mistake when
    // writing if statements for error handling.


    // switch statements in swift are more powerful than in other languages.
    // they can switch on any type, not just integers, and they can have multiple
    // cases for the same code block, and they can have where clauses to add
    // additional conditions to cases. for example:
    let someValue: Any = 42
    switch someValue {
        case let intValue as Int where intValue > 40:
            print("It's an integer greater than 40: \(intValue)")
        case let stringValue as String:
            print("It's a string: \(stringValue)")
        default:
            print("It's something else")
    }

    let vegetable = "red pepper"
    // the break statement is also not required.
    switch vegetable {
        case "celery":
            print("Add some raisins and make ants on a log.")
        case "cucumber", "watercress":
            print("That would make a good tea sandwich.")
        case let x where x.hasSuffix("pepper"):
            // the condition is applied before being used as a case for the switch
            print("Is it a spicy \(x)?")
        default:
            print("Everything tastes good in soup.")
    }

    let individualScores = [75, 43, 103, 87, 12]
    var teamScore = 0
    // index into array with for in
    for score in individualScores {
        if score > 50 {
            teamScore += 3
        } else {
            teamScore += 1
        }
    }
    print(teamScore)


    // for in loops for composite and list types
    let interestingNumbers = [
        "Prime":
          [2, 3, 5, 7, 11, 13],
        "Fibonacci":
          [1, 1, 2, 3, 5, 8],
        "Square":
          [1, 4, 9, 16, 25],
    ]

    var largest = 0
    for (typeOfNumber, numbers) in interestingNumbers {
        print("\(typeOfNumber)'s highest number is ", terminator: "")
        for number in numbers {
            if number > largest {
                largest = number
            }
        }
        print(largest)
    }
    print("highest of all \(largest)")
    // Prints "25".

    var total = 0
    for i in 0..<4 { // ..< omits upper value
        total += i
    }
    print(total)
    for i in 0...4 { // includes both
        total += i
    }
    // Prints "6".

    var n = 2
    while n < 100 {
        n *= 2
    }
    print(n)
    // Prints "128".

    var m = 2
    repeat {
        m *= 2
    } while m < 100
    print(m)


}

// by default the label for params is same, however it can be configured to be different
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person: "Bob", day: "Tuesday")

// example of creating a new label for the parameter

func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}

greet("John", on: "Wednesday")

// Use a tuple to make a compound value — for example, to return multiple
// values from a function. The elements of a tuple can be referred to either by name or by number.


func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0

    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }
    return (min, max, sum)
}

let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print(statistics.sum)
print(statistics.min)
print(statistics.max)
// Prints "120".
print(statistics.2)
// Prints "120".


// Functions can be nested.
// Nested functions have access to variables that were declared in the outer function.
// You can use nested functions to organize the code in a function that's long or complex.
func returnFifteen() -> Int {
    var y = 5
    func add() {
        y += 5
    }
    add()
    add()
    return y
}
returnFifteen()

// functions are a first-class type.
// this means that a function can return another function as its value.
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

// a function can take another function as one of its arguments.
// func hasAny(list: [Int], condition: (Int, Int) -> (Bool, Int, String)) -> Bool {
for item in list {
    //                          +---- we can use the . operator with indexes. or labels.
    //                          v
    if (condition(item, item-1).0) {
    // if (condition(item, item-1).isTrue)
    // for this, the function param should be this:
    //         func hasAny(list: [Int], condition: (Int, Int) -> (isTrue: Bool, Int, String)) -> Bool {
    }
}

func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}

func lessThanTen(number: Int) -> Bool {
    return number < 10
}

var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)

// Variadic parameters
func sum(_ nums: Int...)

// Caller can pass:
// - one value
// - many values
// - zero values

func greet(_ names: String...) {
    print(names)
}
greet("Sudan", "Nepal", "Paraguay")
// names will behave like an array in greet function.

// only one set per function.
func setup(numbers: Int...) {
    // it's an array
    let _ = numbers[0]
    let _ = numbers.count
}


// In-out parameters
// inout means the function can modify the caller's variable directly
// i.e. passing reference
func double(_ x: inout Int) {
    x *= 2
}
var n = 5
double(&n)
print(n) // 10
// without inout the func params are immutable copies.

func swapTwoInts(a: inout Int, b: inout Int) {
    let tempA = a
    a = b
    b = tempA
}
var someIntA = 7
var someIntB = 3
swapTwoInts(a: &someIntA, b: &someIntB) //must be called with an & before the variable name.
print(someIntB) // 7
