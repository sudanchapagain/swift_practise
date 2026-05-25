import Foundation

let topics = ["Variables", "Functions", "Closures", "Async/Await"]

print("")
for (_, topic) in topics.enumerated() {
  print("\(topic)")
}

let url = URL(string: "https://google.com")

func learn(person: String, language: String = "Swift") -> String {
  return "\n\(person) is learning \(language)\n"
}

print(learn(person: "Sudan", language: "Advanced Swift"))
