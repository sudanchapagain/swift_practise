// Conditional Compilation
#if false
    print("This code will not be compiled")
#else
    print("This code will be compiled")
#endif

/*
 Options are:
 os()                   macOS, iOS, watchOS, tvOS, Linux
 arch()                 i386, x86_64, arm, arm64
 swift()                >= or < followed by a version number
 compiler()             >= or < followed by a version number
 canImport()            A module name
 targetEnvironment()    simulator
 */
#if swift(<3)
println()
#endif

// Compile-Time Diagnostics
// You can use #warning(message) and #error(message) to have the
// compiler emit warnings and/or errors
#warning("This will be a compile-time warning")
//  #error("This would be a compile-time error")

//Availability Conditions
if #available(iOSMac 10.15, *) {
    // macOS 10.15 is available, you can use it here
} else {
    // macOS 10.15 is not available, use alternate APIs
}

//-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._-._.-._

// Concurrency
    // - <https://antongubarenko.substack.com/p/q-and-a-swift-concurrency-formatted?r=21t43r>
// Grand Central Dispatch (GCD) basics

// to indicate that a function or method is asynchronous, you write the async keyword
// in its declaration after its parameters, similar to how you use throws to mark a
// throwing function.

// if the function or method returns a value, you write async before the return arrow (->))
func listPhotos(inGallery name: String) async -> [String] {
    let result = // some async networking code

    return result
}
// For a function or method that's both asynchronous and throwing, you write async before throws.

// When calling an asynchronous method, execution suspends until that method returns. You write
// await in front of the call to mark the possible suspension point. This is like writing try
// when calling a throwing function, to mark the possible change to the program's flow if there's
// an error. Inside an asynchronous method, the flow of execution can be suspended only when you
// call another asynchronous method — suspension is never implicit or preemptive — which means
// every possible suspension point is marked with await. Marking all of the possible suspension
// points in your code helps make concurrent code easier to read and understand.

// for example, the code below fetches the names of all the pictures in a gallery and then
// shows the first picture:

let photoNames = await listPhotos(inGallery: "Summer Vacation")
let sortedNames = photoNames.sorted()
let name = sortedNames[0]
let photo = await downloadPhoto(named: name)
show(photo)

// Because the listPhotos(inGallery:) and downloadPhoto(named:) functions both need to make
// network requests, they could take a relatively long time to complete. Making them both
// asynchronous by writing async before the return arrow lets the rest of the app's code
// keep running while this code waits for the picture to be ready.

//----------------------------------------------------------------------------------------------

// A task is a unit of work that can be run asynchronously as part of your program. All
// asynchronous code runs as part of some task. A task itself does only one thing at a
// time, but when you create multiple tasks, Swift can schedule them to run simultaneously.

// The async-let syntax described in the previous section implicitly creates a child task
// — this syntax works well when you already know what tasks your program needs to run.
// You can also create a task group (an instance of TaskGroup) and explicitly add child
// tasks to that group, which gives you more control over priority and cancellation, and
// lets you create a dynamic number of tasks.

// Tasks are arranged in a hierarchy. Each task in a given task group has the same parent
// task, and each task can have child tasks. Because of the explicit relationship between
// tasks and task groups, this approach is called structured concurrency. The explicit
// parent-child relationship between tasks has several advantages:

    // - In a parent task, you can't forget to wait for its child tasks to complete.
    // - When setting a higher priority on a child task, the parent task's priority is automatically escalated.
    // - When a parent task is canceled, each of its child tasks is also automatically canceled.
    // - Task-local values propagate to child tasks efficiently and automatically.

// another version of the code to download photos that handles any number of photos:

await withTaskGroup(of: Data.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        group.addTask {
            return await downloadPhoto(named: name)
        }
    }

    for await photo in group {
        show(photo)
    }
}

// The code above creates a new task group, and then creates child tasks to download each
// photo in the gallery. Swift runs as many of these tasks concurrently as conditions allow.
// As soon as a child task finishes downloading a photo, that photo is displayed. There's no
// guarantee about the order that child tasks complete, so the photos from this gallery can
// be shown in any order.

// in the code listing above, each photo is downloaded and then displayed, so the task
// group doesn't return any results. For a task group that returns a result, you add code
// that accumulates its result inside the closure you pass to `withTaskGroup(of:returning:body:)`.

let photos = await withTaskGroup(of: Data.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        group.addTask {
            return await downloadPhoto(named: name)
        }
    }


    var results: [Data] = []
    for await photo in group {
        results.append(photo)
    }


    return results
}
