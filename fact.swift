import Foundation

func factorial(_ n: Int) -> Int {
    if n == 0 || n == 1 {
        return 1
    } else {
        return n * factorial(n - 1)
    }
}

let number = 5
let result = factorial(number)
print("factorial of \(number) is \(result)")
