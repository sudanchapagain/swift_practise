// Closures:

// functions are actually a special case of closures i.e. blocks of code that can
// be called later. the code in a closure has access to things like variables
// and functions that were available in the scope where the closure was created,
// even if the closure is in a different scope when it's executed. you can write
// a closure without a name by surrounding code with braces ({}).

// use in to separate the arguments and return type from the body.

let numbers = [1, 2, 3]

numbers.map({ // creating a closure. i.e. anon func
    // type param of function
    // |               |
    // v               v
    (number: Int) -> Int in // opens the scope
        let result = 3 * number
        return result
})

// you have several options for writing closures more concisely. when a
// closure's type is already known, such as the callback for a delegate,
// you can omit the type of its parameters, its return type, or both. single
// statement closures implicitly return the value of their only statement.

let mappedNumbers = numbers.map({ number in 
    3 * number
})
print(mappedNumbers)


// shorthand argument names:
// i.e. $0, $1 can be used to refer to the closure's arguments in order.
// If you use these shorthand argument names, you can omit the argument
// list from the closure's definition.
//
// The in keyword isn't needed because there are no arguments to separate
// from the closure body.
let sortedNumbers = numbers.sorted {
    $0 > $1
}

// Capturing values:
// Closures can capture constants and variables from the surrounding context in
// which they are defined. The closure can then refer to and modify the values
// of those constants and variables from within the closure's body, even if the
// original scope that defined the constants and variables no longer exists.
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

// Trailing closure syntax:
// If you need to pass a closure expression to a function as the function's
// last argument and the closure expression is long, it can be written as a
// trailing closure instead of as a parameter to the function.

// A trailing closure is a closure expression that is written outside &
// immediately after the parentheses of the function call. When using this
// syntax, you do not write the argument label for the closure expression.

// However, if there are multiple trailing closures, you do need to write
// the argument label for each closure.
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}
// to call this function without using a trailing closure:
someFunctionThatTakesAClosure(closure: {
    // closure's body goes here
})

// to call this function with a trailing closure:
someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}

// unlike kotlin, swift allows arbitary number of trailing closures,
// but you must label them
func someFunctionThatTakesMultipleClosures(
    closure: () -> Void,
    anotherClosure: () -> Void
) {
    // function body goes here
}

someFunctionThatTakesMultipleClosures(closure: {
    // closure's body goes here
}, anotherClosure: {
    // another closure's body goes here
})

// with trailing closure syntax, the above call can be rewritten as:
someFunctionThatTakesMultipleClosures() {
    // closure's body goes here
} anotherClosure: {
    // another closure's body goes here
}

// Escaping vs non-escaping closures:
// A closure is said to escape a function when the closure is passed as an
// argument to the function, but is called after the function returns.

// A closure escapes when it may be called after the function returns.
// This usually happens when the closure is stored, returned, or used
// asynchronously.

// You can indicate that a closure is allowed to escape by writing @escaping
// before the closure's parameter in the function's declaration.

// If a closure is @escaping, Swift requires explicit `self` references
// when capturing instance members. This makes capture semantics explicit
// and helps prevent accidental retain cycles.
var completionHandlers: [() -> Void] = []

func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
someFunctionWithEscapingClosure {
    print("This is an escaping closure.")
}

// using closures as callback handlers:

// Closures are commonly used as callbacks. A callback is a function that gets
// executed later in response to an event, async operation, or completed task.
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
someFunctionWithNonescapingClosure {
    print("This is a non-escaping closure.")
}

// something IRL would be async API, networking, timers, animations, etc.
DispatchQueue.main.async {
    print("Runs later")
}

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

// Collections:

// Array is ordered, duplicates allowed, support both mutability and immutability,
// and common operations are append, remove, insert, sort. 

// Dictionary is key-val pair where keys must be unique.

// Set is unordered, and only non-dupe. Fast lookups with set operations
// (union, intersection, subtracting)

// Higher order collection methods: maps, compactMap, filter, reduce, flatMap.

var fruits = ["strawberries", "limes", "tangerines"] // array
fruits[1] = "grapes" // this is a replace rather than insert
// use .insert
fruits.insert("grapes2", at: 2)

var occupations = [ // dict
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
    ]
occupations["Jayne"] = "Public Relations"

// empty allocation
fruits = []
occupations = [:] // denotes the dictionary type

// assignment of empty allocated list types (i.e type not yet erased)
// requires explicit typeinformation
let emptyArray: [String] = []
let emptyDictionary: [String: Float] = [:]

let shoppingList = ["catfish", "water", "tulips",]
// Arrays are structs, so this creates a copy instead of referencing the same object
var mutableShoppingList = shoppingList
mutableShoppingList[2] = "mango"
// == is equality
shoppingList == mutableShoppingList // false

// Dictionaries declared with let are also immutable
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic"
]
occupations["Jayne"] = "Public Relations"
// Dictionaries are also structs, so this also creates a copy
let immutableOccupations = occupations

mutableShoppingList.append("blue paint")
occupations["Tim"] = "CEO"

mutableShoppingList = []
occupations = [:]
let emptyArray = [String]()
let emptyArray2 = Array<String>() // same as above
// [T] is shorthand for Array<T>

let emptyArray3: [String] = [] // Declaring the type explicitly allows you to set it to an empty array
let emptyArray4: Array<String> = [] // same as above

// [Key: Value] is shorthand for Dictionary<Key, Value>
let emptyDictionary = [String: Double]()
let emptyDictionary2 = Dictionary<String, Double>() // same as above
var emptyMutableDictionary: [String: Double] = [:]
var explicitEmptyMutableDictionary: Dictionary<String, Double> = [:] // same as above

struct Pair<T, U> {
    var first: T
    var second: U
}

// no special sugar exists, so we must use:
let p: Pair<Int, String> = Pair(first: 1, second: "a")

// but we can define a typealias
typealias IntStringPair = Pair<Int, String>
let q: IntStringPair = IntStringPair(first: 1, second: "a")
