/*

- <https://fuckingswiftui.com/>
    - <https://goshdarnswiftui.com/>

*/

// SwiftUI:
// A declarative framework for defining UI elements and their interaction.
// View is considered the most basic construct in SwiftUI. View by themselves
// are just protocols that other value types need to conform to. The UI structs
// that conform to the View are also colloquially called view. Views can be
// atomic or encapsulate other views (views can be nested inside one another
// in specific ways). Every component like Text, Image, Button, List, VStack,
// etc. are views.

// Modifiers are methods that can be used to change the default behavior of
// the view. Modifiers can be chained together to form a final modified view.
// The modifiers work on layers i.e. modifierA being applied before modifierB
// matters. This is because modifiers actually apply themselves onto the view
// and then return a new modified view in place.

// consider this
Text("Hello")
    .font(.title)
    .foregroundColor(.blue)
    .padding()
// here Text with "hello" is constructed then font modifier applies .title
// size and returns a new Text that has size .title, then similarly
// foregroundColor, and padding are applied.

// A Layout controls how child views are arranged spatially. Common layouts
// are VStack, HStack, ZStack, Grid, Spacer.
// example:
VStack {
    Text("Top")
    Text("Bottom")
}
// the Text views are wrapped by VStack (Vertical Stack) which means they are
// laid out in vertical manner.

// We can combine all three of these concepts and make something:
VStack(spacing: 20) {
    Text("Profile")
        .font(.largeTitle)
    Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 100, height: 100)
}
.padding()
// here we make a VStack and apply padding to it. The VStack consists of
// Text with large title font, and a image that is resizeable and inside a
// frame of 100 to 100 width & height.

// However, the layouts were limited to 10 views per container as
// a function body normally cannot "return multiple values".
// <https://medium.com/@aspteslia/why-swiftui-views-can-not-handle-more-then-ten-children-762584e67a28>
// But ViewBuilders in swift were introduced to resolve this.

// body is implicitly annotated with it:

@ViewBuilder
var body: some View

// ViewBuilder is a result builder.
// It transforms multiple child expressions into a single composite view type
// at compile time. i.e. something like this
VStack {
    Text("One")
    Text("Two")
    Text("Three")
}
// is not considered three siblings. rather, the builder converts it to be
// something along the lines of `TupleView<(Text, Text, Text)>`

// so this was the workaround before
VStack {
    Group {
        Text("1")
        Text("2")
        Text("3")
        Text("4")
        Text("5")
        Text("6")
    }

    Group {
        Text("7")
        Text("8")
        Text("9")
        Text("10")
        Text("11")
    }
}
// group itself is layout-neutral.
// it exists largely for structural composition and type grouping.

// later versions of Swift and SwiftUI effectively removed this practical
// limitation through improved compiler support and variadic generics
// infrastructure.

    // NOTE(to self): i remember chris latner talking with primeagen about how ViewBuilders
    // (i think) complicated the language and the compile time? need to check.

// ViewBuilders also allow conditional composition. i.e.
if isLoggedIn {
    Text("Welcome")
} else {
    LoginView()
}

// Shapes, Colors, Gradients
// We can draw basic shapes in SwiftUI with the following functions

Circle()
Rectangle()
RoundedRectangle(cornerRadius: 16)
Capsule()
Ellipse()

Path { path in
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 100, y: 100))
}

// Typical modifiers that are available include:
Circle().fill(.blue)

RoundedRectangle(cornerRadius: 20).stroke(.red, lineWidth: 4)

Capsule().frame(width: 200, height: 60)

// Frame is special in that it can be used with other views too.

    // SwiftUI layout works as a negotiation where parent first proposes a size.
    // the child then chooses a size and parent takes that and places the child.
    // .frame is just a modifier that inserts another layout container into
    // this process. consider
    // 
    // Text("Hello").frame(width: 200, height: 100)
    //
    // The Text itself still has its intrinsic size. The frame creates a
    // 200x100 container around it. by default the content stays centered
    // inside that frame.
    //
    // the ordering matters here too. also you can align children as such
    Text("Hello").frame(
       width: 200,
       height: 100,
       alignment: .topLeading
    )
    .border(.blue)

    // you can do fixable expansion (i.e. take as much horizontal space as
    // possible) with .frame(maxWidth: .infinity)
    //
    // you can also do idealWidth but many layouts will ignore it.
    .frame(
        minWidth: 100,
        idealWidth: 200,
        maxWidth: 300
    )

    // so, when you apply .frame to a shape the it is not resizing rather,
    // the Circle expands to fit the proposed frame.
    //  
    // Circle().frame(width: 300, height: 300)
    //
    // When frame is applied to Text, Text("Hello").frame(width: 300)
    // the text itself is not resized.same case for image.
    // Image("cat").frame(width: 200)
    //
    // you need to .resizeable() to change image behavior. a common example is
    // 
    // Image("cat")
    //    .resizeable()
    //    .scaledToFit()
    //    .frame(width: 200)

// to work with colors, we can use Color function
Color.red
Color(uiColor: .systemBackground)
Color(
    red: 0.2,
    green: 0.5,
    blue: 0.9
)

// usage would look like this
Text("Hello")
    .foregroundStyle(.white)
    .padding()
    .background(.blue)

// instead of single colors, we can use gradients too
LinearGradient(
    colors: [.blue, .purple],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

RadialGradient(
    colors: [.yellow, .orange],
    center: .center,
    startRadius: 10,
    endRadius: 100
)

AngularGradient(
    colors: [.red, .blue, .green],
    center: .center
)

// to use a gradient in a shape
Circle().fill(
    LinearGradient(
        colors: [.blue, .purple],
        startPoint: .top,
        endPoint: .bottom
    )
)
.frame(width: 120, height: 120)

// the newer api is .foregroundStyle(...) rather than .foregroundColor(...)
Image(systemName: "star.fill").foregroundStyle(
    LinearGradient(
        colors: [.yellow, .orange],
        startPoint: .top,
        endPoint: .bottom
    )
)

// shapes can be layered to construct complex shapes.
ZStack {
    Circle().fill(.blue)

    Circle()
        .stroke(.white, lineWidth: 6)
        .padding(8)

    Image(systemName: "bolt.fill")
        .foregroundStyle(.white)
}
.frame(width: 120, height: 120)

// if we are building custom shapes then they must conform to the shape
// protocol
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// with that, we can just use it as such
Triangle()
    .fill(.green)
    .frame(width: 120, height: 120)

// some of the most common modifiers include:
.shadow(radius: 10)
.overlay(...)
.mask(...)
.clipShape(...)
.opacity(...)
.blur(radius: ...)

// clip shape is common with non-shapes too
Image("photo")
    .resizable()
    .scaledToFill()
    .clipShape(Circle())

//----------------------------------------------------------------------------

// To store state in SwiftUI, we can use @State as it stores local mutable
// state owned by a view.
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")

            Button("Increment") {
                count += 1
            }
        }
    }
}
// here the CounterView has count as state and its private but modifyable.
// the views are able to mutate and get the value without any special syntax.
// as with all declarative UI frameworks, When count changes Swift UI
// re-renders the view body. so that translates to the view struct itself being
// recreated constantly. the state storage lives outside the struct lifecycle.

// to pass state downward, we need to use @Binding. i.e.
struct ParentView: View {
    @State private var isOn = false

    var body: some View {
        //              +----- this sends the state as mutable instance
        //              v
        ChildView(isOn: $isOn)
        // for immutable state. i.e. child will only read the value. we
        // can do the following
        // ChildView(isOn: isOn)
        // however, the child should not bind to it. rather do this
        // 
        // let isOn: Bool
        //
        // swift ui will add the reactivity when parent's state updates the
        // child will update too as when value in parent changes, its destroyed
        // and recreated which means child too will be recreated.
    }
}
struct ChildView: View {
    @Binding var isOn: Bool
    // the binding here means, ChildView is binding to the parent's state.
    // any update here should reflect up there too.
    //
    // it should be clear that child does not own the state too. it simply
    // is a action listener who can see parent state and send changes upstream

    var body: some View {
        Toggle("Enabled", isOn: $isOn)
    }
}

// @ObservedObject & ObservableObject (ViewModel pattern)

    // ViewModel pattern is just a architectural pattern where instead of view
    // handling modifications, a new intermediate is introduced between Model &
    // View. i.e. ViewModel whoose responsibility is to hold state transitions,
    // such that views can remain static (i.e. View itself will not modify anything
    // just provide ways for client to call ViewModels)

// ObservableObject is a reference type that publishes change notifications.
// this is usally for class. example:
// 
//                      +----- translation: this object can notify Swift UI
//                      |      when something changes.
//                      v
class CounterViewModel: ObservableObject {
    @Published var count = 0
//  ^
//  |
//  +----- when this property changes, emit an update.
}
// the view then subscribes to this as such

struct CounterView: View {
    @ObservedObject var vm: CounterViewModel

    var body: some View {
        VStack {
            Text("Count: \(vm.count)")
            Button("Increment") {
                vm.count += 1
            }
        }
    }
}

// so when count changes `@Published` emits change and swift ui invalidates
// dependent views. that means, the body recomputes and reconstructs.

    // ObservableObject is reference-based unlike @State which is
    // value-oriented.

    // also, @ObservedObject does NOT own the object. it observes an externally
    // owned object. parent owns, the child observes.
    struct ParentView: View {
        @StateObject private var vm = CounterViewModel()
        var body: some View {
            ChildView(vm: vm)
        }
    }
    struct ChildView: View {
        @ObservedObject var vm: CounterViewModel
        var body: some View {
            Text("\(vm.count)")
        }
    }
    // as view structs are re:created constantly, so initializing the viewmodel
    // constantly (CounterViewModel()) would mean state resets and other issues.
    //
    // a typical viewmodel example:
    class LoginViewModel: ObservableObject {
        @Published var username = ""
        @Published var password = ""
        @Published var isLoading = false

        func login() {
            isLoading = true
            // async work
        }
    }
    struct LoginView: View {
        @StateObject private var vm = LoginViewModel()
        var body: some View {
            VStack {
                TextField("Username", text: $vm.username)
                SecureField("Password", text: $vm.password)
                Button("Login") {
                    vm.login()
                }
            }
        }
    }

// however, since iOS 17+, @Observable has been introduced.
// under the new model, this
class CounterViewModel: ObservableObject {
    @Published var count = 0
}
// turns to
import Observation

@Observable
class CounterViewModel {
    var count = 0
}
// the macro automatically tracks property access and mutations.
// so then usage becomes simpler.
struct CounterView: View {
    @State private var vm = CounterViewModel()
//  ^
//  +--- yes instead of @StateObject we can use @State
    var body: some View {
        VStack {
            Text("\(vm.count)")
            Button("Increment") {
                vm.count += 1
            }
        }
    }
}
//////////////////////////////
@Observable
class AppState {
    var username = "John"
    var age = 25
}
//////////////////////////////
struct ContentView: View {
    @State private var state = AppState()

    var body: some View {
        Text(state.username)
    }
}

// sharing observable properties is also much easier
struct ParentView: View {
    @State private var vm = CounterViewModel()

    var body: some View {
        ChildView(vm: vm)
    }
}

struct ChildView: View {
    var vm: CounterViewModel

    var body: some View {
        Button("Increment") {
            vm.count += 1
        }
    }
}

//----------------------------------------------------------------------------

// to propagate dependencies (i.e. avoid prop drilling hell) we can use
// Environment. The system also provides few environment properties by default
@Environment(\.colorScheme) private var colorScheme
// now the view can read colorScheme and decide if its .light or .dark.
// something like this
struct ContentView: View {
    //           +--- this is a key path.
    //           |         (i.e. reference a property itself, not just its value)
    //           V
    @Environment(\.colorScheme)
    private var colorScheme

    var body: some View {
        Text(colorScheme == .dark ? "Dark" : "Light")
    }
}

    // normally, we would access a property like this:
    // person.name
    // with a KeyPath, we can create a reference:
    // \Person.name

// some of the most common environment that is already available to us are:
// 
// - color scheme
// - locale
// - calendar
// - dynamic type size
// - accessibility settings
// - dismiss actions
// - safe area info
// - etc.

@Environment(\.dismiss) private var dismiss
// used for dismissing sheets/navigation.

// environment flows downward through the view hierarchy.
//
// Parent provides and Children consume. but we can override environment
// values at any subtree.

ContentView().environment(\.colorScheme, .dark)
// everything inside it now sees .dark
// useful for previews, testing, feature scoping, and theme overrides

// to define our own environment key
struct APIClientKey: EnvironmentKey {
    static let defaultValue = APIClient()
}
// then we can extend EnvironmentValues:
extension EnvironmentValues {
    var apiClient: APIClient {
        get {
            self[APIClientKey.self]
        }
        set {
            self[APIClientKey.self] = newValue
        }
    }
}
// then it becomes useable like
@Environment(\.apiClient)
private var apiClient

// before Environment, @EnvironmentObject existed which was specifically for
// shared ObservableObjects. example:
class AppState: ObservableObject {
    @Published var username = "John"
}
// to inject at the top
@main
struct MyApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
// and consume anywhere below
@EnvironmentObject
var appState: AppState
// now every descendant can access it and no constructor passing required.
// we could then use it as
Text(appState.username)
// this was common for authentication state, global app settings, session/user
// state, and navigation coordinators. but if missing, the runtime crashes were
// common, and other issues.

// one of the most common usage of Environment, is to render specific UI
// for iPad, and another for iOS. i.e.
@Environment(\.horizontalSizeClass)
var horizontalSizeClass
// possible values are `.compact` and `.regular`. example:
if horizontalSizeClass == .compact {
    VStack { ... }
} else {
    HStack { ... }
}
// however, modern layouts increasingly prefer `ViewThatFits`, `geometry`,
// `adaptive grids`, `layout protocol` instead of hardcoded size-class
// branching.

// some common environment values are:
@Environment(\.dismiss)
@Environment(\.scenePhase)
// app active/background state
@Environment(\.openURL)
@Environment(\.locale)
@Environment(\.calendar)
@Environment(\.accessibilityReduceMotion)
@Environment(\.dynamicTypeSize)

//-----------------------------------------------------------------------------

// lifecycle
//
// swiftui views are not active for too long. it is just lightweight value
// description. Every time dependent state changes like
// `@State private var count = 0`, `count += 1` then swift ui invalidates the
// view. then swift ui run `var body: some View` again.

// however the view cannot be lightweight if we carry out expensive operations
// like database query operations in the view
var body: some View {
    let data = expensiveDatabaseQuery()
    return Text(data.title)
}
// so we have to keep it lightweight.
// it's important to note however that recomputing body does not necessarily
// mean rebuilding the actual native UI, rerendering pixels, and reallocating
// everything. swift ui diffs the new view tree against the previous one.
// then only different parts are updated.

////////////////////////////////////

// onAppear runs when a view enters the visible hierarchy. Example:
Text("Hello").onAppear {
    print("appeared")
}
// its commonly used to start async work, analytics, begin animations,
// trigger loading, subscribe to resources.
struct ProfileView: View {
    @State private var user: User?

    var body: some View {
        VStack {
            if let user {
                Text(user.name)
            }
        }
        .onAppear {
            loadUser()
        }
    }
}
// it may run multiple times.
// Example causes include: navigation transitions, conditional rendering,
// list recycling, tab switching, hierarchy reconstruction.

// so this is not reccomended
.onAppear {
    expensiveSetup()
}
// a more common pattern is
@State private var didLoad = false
.onAppear {
    guard !didLoad else { return }

    didLoad = true
    expensiveSetup()
}
// however in modern swift ui, .task is more preferred. as .task integrates
// better with Swift concurrency and cancellation.
.task {
    try? await Task.sleep(for: .seconds(2))
}
// if the view disappears, the task is automatically cancelled.

// similarly, onDisappear runs when view leaves hierarchy.
.onDisappear {
    print("disappeared")
}
// typically used for cleanup, stop timers, cancel manual subscriptions,
// persist transient state

// but since views appear/disappear constantly during navigation/layout
// changes. we should avoid assuming: permanent destruction & true screen
// exit as swift ui lifecycle is more fluid than UI Kit lifecycle.

////////////////////////////////////////////////////////////////////////

// - <https://medium.com/@saiprasanthamuluru/swiftui-view-identity-the-hidden-engine-behind-every-state-update-and-animation-bfe62f8cd4eb>

// View Identity
// every view in swift ui has an identity as its how a view tracks view
// updates.
// 
// When the identity changes, SwiftUI treats it as a completely different
// view it destroys the old one, creates a new one, and all @State values
// reset to their defaults.
// 
// SwiftUI has two systems for establishing identity:
// - Implicit (Structural) and
// - Explicit.

// implicit identity is inferred from the view's type and its position in the
// view hierarchy.
var body: some View {
    if isLoggedIn {
        HomeView()
    } else {
        LoginView()
    }
}

// Here, `HomeView` and `LoginView` are at the same position in the hierarchy,
// but they're different types so SwiftUI assigns them different identities.
// Switching `isLoggedIn` destroys one and creates the other. Transitions fire.
// State resets. This is correct and expected.

// Now here's the subtle part:

var body: some View {
    if isPremium {
        ProfileView().background(Color.gold)
    } else {
        ProfileView().background(Color.gray)
    }
}

// Both branches are the same type (ProfileView) at the same position. To
// SwiftUI, this is the same view with different modifiers not two separate
// views. No recreation happens. If ProfileView owns `@State`, it persists
// across the isPremium toggle.
// 
// This is structural identity at work. The view hierarchy's shape determines
// identity, not the visual output.

// but type erasure breaks this down. consider:
var body: some View {
    AnyView(isLoading ? ProgressView() : Text("Done"))
}
// structural information is lost as the concrete type has been erased.
// this also means we should prefer concrete types or `Group + conditionals`
// over `AnyView` when you can.

// when we need to override the default inferred identity and declare it
// ourselves, then we can use the `.id()` modifier, and `ForEach`'s id param.

TextField("Search", text: $searchText)
    .id(selectedCategory)

// when `selectedCategory` changes, the identity of this TextField changes
// then SwiftUI destroys the old field and creates a fresh one. we're not
// updating the view we're replacing it. It's exactly what we want when
// switching categories should clear the search input.

// But the same mechanism can bite us:
List(items) { item in
    // Accidental identity change
    RowView(item: item)
        .id(item.lastUpdated) // Changes every time item is updated
}

// Every time an item updates its `lastUpdated` timestamp, SwiftUI sees a
// new identity the row gets recreated instead of animated. Any @State inside
// `RowView` resets silently. This is one of the most common sources of
// subtle SwiftUI bugs.

// Rule of thumb: `.id()` doesn't update a view, it replaces it. We should
// reach for it intentionally, not by default.

ForEach and Stable IDs

// risky
// uses value as ID
ForEach(tasks, id: \.self) { task in
    TaskRow(task: task)
}

// safe
// uses a stable and unique identifier
ForEach(tasks, id: \.id) { task in
    TaskRow(task: task)
}

// when we use `id: \.self` and the task is a value type, any mutation to the
// task creates a new identity. Swift UI removes the old row and inserts a new
// one no animation, no state preservation. the fix is simple: always key on a
// stable, unique id property that doesn't change when the task's content
// changes.

    // SwiftUI maintains an Attribute Graph a dependency graph that tracks
    // every view, its inputs, and the relationships between them. View
    // identity is how SwiftUI locates nodes in this graph across render
    // passes.

//------------------------------

// Lists & Navigation
// list is basically a way to group view structs that provides few functionality
// like scrollable platform-native list. However, in practise static lists
// are rare and lists are mostly data driven. i.e.
struct User: Identifiable {
    let id = UUID()
    let name: String
}

let users = [
    User(name: "Sudan"),
    User(name: "Manjul"),
    User(name: "Abi"),
]

List(users) { user in
    Text(user.name)
}

    // above is shorthand for
    List {
        ForEach(users) { user in
            Text(user.name)
        }
    }

// the ForEach is not a normal imperative loop. rather it declares a
// collection of child views and their associated identities which SwiftUI
// then tracks over time.

// if names/ids are unique then identifiable is not required. the equivalent
// explicit form is 
ForEach(users, id: \.id) { user in
    Text(user.name)
}
// or
ForEach(users, id: \.name) { user in
    Text(user.name)
}
// the main idea is that, we should make a concrete and stable identity of
// views so that ForEach can function properly.

    // something like this can work but during mutations everything breaks
    // apart
    ForEach(0..<users.count) { index in
        Text(users[index].name)
    }

// opting for something like this means we do not need to handle anything
struct ContentView: View {
    @State private var users = [
        User(name: "Sudan"),
        User(name: "Abi"),
        User(name: "Manjul")
    ]

    var body: some View {
        VStack {
            List(users) { user in
                Text(user.name)
            }

            Button("Add") {
                users.append(User(name: "New User"))
            }
        }
    }
}

// row identity
struct RowView: View {
    @State private var isExpanded = false
    let user: User
    var body: some View {
        VStack {
            Text(user.name)

            if isExpanded {
                Text("Details")
            }
        }
    }
}

List(users) { user in
    RowView(user: user)
}

// Since @State persistance depends upon the row identity, if the ids
// change unexpectedly then expansion state resets. As such random ids should
// be avoided to maintain identity of each row.

// doing something like this is not encouraged
struct User: Identifiable {
    var id: UUID {
        UUID()
    }
}
// as it generates a new identity on each re-render.
// a more correct option is to make the property a stored value
let id = UUID()

// to mutate list data
List {
    ForEach(users) { user in
        Text(user.name)
    }
    .onDelete(perform: deleteUsers)
    // to move maybe opt for .move
    // .onMove(perform: moveUsers)
}

// the handler
func deleteUsers(at offsets: IndexSet) {
    users.remove(atOffsets: offsets)
}

// the move handler
// func moveUsers(
//     from source: IndexSet,
//     to destination: Int
// ) {
//     users.move(
//         fromOffsets: source,
//         toOffset: destination
//     )
// }

// it can be paired with a edit button
// .toolbar {
//     EditButton()
// }

// we can also bind selections in list. this is useful for sidebars, split
// views, multi columns navigation, etc.
@State private var selection: User.ID?
// with that we can just do the following
List(users, selection: $selection) { user in
    Text(user.name)
}

//--------------------------------------------------

// List is a
// - platform-native behavior
// - provides cell reuse optimizations
// - has built-in swipe actions/editing
// - has automatic accessibility semantics

// ScrollView provides
// - more flexible
// - more custom layouts
// - requires manual composition

//---------------------------------------------------

// path based navigation
@State private var path = NavigationPath()

NavigationStack(path: $path) {
    Button("Go") {
        path.append(user)
    }
}

// here Swift UI pushes matching destination automatically.
// this is important for deep linking, restoring navigation state, coordinator
// architectures, and complex flows.
//
// also, we can see that navigation state is just a state.

// a more basic example is
NavigationStack {
    Text("Home")
}
NavigationStack {
    NavigationLink("Open Details") {
        DetailView()
    }
}

// the new api separates navigation trigger and destination mapping as
// its more scalable solution

NavigationStack {
    NavigationLink("Open", value: user)
}.navigationDestination(for: User.self) { user in
    DetailView(user: user)
}
// in value based navigation, suppose the following
struct User: Hashable {
    let id: UUID
    let name: String
}
// then using
NavigationLink(user.name, value: user)
// does not directly specify the destination view. instead it pushes a
// navigation value.

// adding
.navigationDestination(for: User.self) { user in
    UserDetailView(user: user)
}
// tells swift ui that when a user appears in navigation stack, render
// this destination.

// the path version also allows us to persist path state. first
save(path)
// then later
restore(path)

// large apps centralize the path as such
@Observable
class Router {
    var path = NavigationPath()
}
// then used as such
router.path.append(user)
// from anywhere

// path can also hold heterogeneous path
path.append(user)
path.append(post)
path.append(settings)
// then
.navigationDestination(for: User.self) { ... }
.navigationDestination(for: Post.self) { ... }
.navigationDestination(for: SettingsRoute.self) { ... }

// swift ui will then choose correct destination by type
// however, the values must conform to hashable as state tracking depends on
// identity / hashability

// so the immediate view based navigation i.e.
NavigationLink("Go") {
    DetailView()
}
// and the value based navigation are different
NavigationLink("Go", value: user)


// here the navigation stack consists of a text view and on the next navigation
// statck we have a navigation link that opens detailview view.

// - <https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui>

// in older SwiftUI, this was done
struct ContentView: View {
    var body: some View {
        NavigationView {
            ContentView2()
        }
    }
}
// it basically wrapped a view inside navigation context where an "entry"
// into that navigation meant that the wrapped view was showcased.
//
// when tabview was used then navigation view itself would be wrapped in
// tab view.
//
// if we had to add a navigation title then we would have to add to the child
// view not the navigation view as when context changed the navigation title
// would not be modified. it would remain static for entirety of that
// navigation.
NavigationView {
    Text("Hello, World!")
        .navigationTitle("Navigation")
}
// we can however use navigationTitle() on any view inside the navigation
// view. it doesn't need to be the outermost one.

// the title can also be customized with `navigationBarTitleDisplayMode()`
// the possible values are .large, .inline, and .automatic

// For most applications, you should rely on the .automatic option for
// your initial view, which you can get just by ignoring the modifier
// entirely:

.navigationTitle("Navigation")

// For all views that get pushed on to the navigation stack, you will
// normally use the .inline option, like this:

.navigationTitle("Navigation")
.navigationBarTitleDisplayMode(.inline)

// Navigation views present new screens using NavigationLink, which can be
// triggered by the user tapping their contents or by programmatically
// enabling them.

// One of the features of NavigationLink is that you can push to any view – it
// could be a custom view of your choosing, but it also could be one of
// SwiftUI's primitive views.
// For example, this pushes directly to a text view:
NavigationView {
    NavigationLink(destination: Text("Second View")) {
        Text("Hello, World!")
    }
    .navigationTitle("Navigation")
}

// the navigation link add helpful properties like making the text blue to
// tell the users that the text is clickable. however in case of images, we
// do not want that behavior. to remove it we can do this
NavigationLink(destination: Text("Second View")) {
    Image("hws")
        .renderingMode(.original) // this turns it off.
}
.navigationTitle("Navigation")
// however this also does mean the user will not know visually that this is a
// link, as such additional care should be given.

// When you use NavigationLink to push a new view onto your navigation stack,
// you can pass any parameters that new view needs to work.
// For example, if we were flipping a coin and wanted users to choose either
// heads or tails, we might have a results view like this one:
struct ResultView: View {
    var choice: String

    var body: some View {
        Text("You chose \(choice)")
    }
}

// Then in our content view, we could show two different navigation links:
// one that creates ResultView with "Heads" as its choice, and the other with
// "Tails". These values must be passed in as we create the result view,
// like this:
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text(
                    "You're going to flip a coin – do you want to choose heads or tails?"
                )

                NavigationLink(
                    destination: ResultView(choice: "Heads")
                ) {
                    Text("Choose Heads")
                }

                NavigationLink(
                    destination: ResultView(choice: "Tails")
                ) {
                    Text("Choose Tails")
                }
            }
            .navigationTitle("Navigation")
        }
    }
}

// Programmatic navigation
// SwiftUI's NavigationLink has a second initializer that has an isActive
// parameter, allowing us to read or write whether the navigation link is
// currently active. In practical terms, this means we can programmatically
// trigger the activation of a navigation link by setting whatever state it's
// watching to true.
// 
// For example, this creates an empty navigation link and ties it to the
// isShowingDetailView property:
struct ContentView: View {
    @State private var isShowingDetailView = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: Text("Second View"),
                    isActive: $isShowingDetailView,
                    ) {
                        EmptyView()
                    }
                Button("Tap to show detail") {
                    self.isShowingDetailView = true
                }
            }
            .navigationTitle("Navigation")
        }
    }
}

// user input controls

// TextField -> Single-line text input
// SecureField -> Password-style input
// Toggle -> On/off switch
// Picker -> Select from a list of options
// Slider -> Choose a value from a range by dragging
// Stepper -> Increment/decrement numeric values

struct SettingsView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var notificationsEnabled = true
    @State private var selectedColor = "Blue"
    @State private var volume = 50.0
    @State private var quantity = 1

    let colors = ["Blue", "Green", "Red"]

    var body: some View {
        Form {
            Section("Account") {
                TextField("Username", text: $username)

                SecureField("Password", text: $password)
            }

            Section("Preferences") {
                Toggle("Enable Notifications",
                       isOn: $notificationsEnabled)

                Picker("Theme Color",
                       selection: $selectedColor) {
                    ForEach(colors, id: \.self) { color in
                        Text(color)
                    }
                }

                Slider(value: $volume, in: 0...100)

                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
            }
        }
    }
}

Form {
    Section("Profile") {
        TextField("Name", text: $name)
    }

    Section("Settings") {
        Toggle("Dark Mode", isOn: $darkMode)
    }
}

// gesture recognizers (tap, drag, long press, etc.)
Text("Tap Me")
    .onTapGesture {
        print("Tapped")
    }

Circle()
    .gesture(
        DragGesture()
            .onChanged { value in
                print(value.translation)
            }
            .onEnded { _ in
                print("Drag ended")
            }
    )

Text("Hold Me")
    .onLongPressGesture {
        print("Long pressed")
    }

// other common gestures
MagnificationGesture() // pinch to zoom
RotationGesture() // rotation
SpatialTapGesture() // precise tap location

// they can be combined
Image(systemName: "star")
    .simultaneousGesture(
        LongPressGesture()
    )
    .simultaneousGesture(
        TapGesture()
    )

// conditional views (if inside body)
struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        VStack {
            if isLoggedIn {
                Text("Welcome")
            } else {
                Text("Please Sign In")
            }
        }
    }
}

if score >= 90 {
    Text("A")
} else if score >= 80 {
    Text("B")
} else {
    Text("C")
}

// optional
if let user = currentUser {
    Text(user.name)
}

// conditional modifiers
Text("Status")
    .foregroundColor(isOnline ? .green : .red)

// ViewModifiers and custom modifiers
// ViewModifier lets us package reusable styling or behavior and apply it to
// any view.
struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.blue)
    }
}
// to apply it
Text("Hello")
    .modifier(TitleStyle())

// a common pattern is to
extension View {
    func titleStyle() -> some View {
        modifier(TitleStyle())
    }
}
// add a extension and then use it as such
Text("Hello")
    .titleStyle()

// they can accept params
struct CardStyle: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .cornerRadius(12)
    }
}

extension View {
    func cardStyle(color: Color) -> some View {
        modifier(CardStyle(color: color))
    }
}

Text("Profile")
    .cardStyle(color: .gray)


// conditionals
struct ValidationStyle: ViewModifier {
    let isValid: Bool

    func body(content: Content) -> some View {
        content
            .border(isValid ? .green : .red)
    }
}

TextField("Email", text: $email)
    .modifier(ValidationStyle(isValid: isValidEmail))

// built in modifiers are all view modifiers
Text("Hello")
    .font(.headline)
    .padding()
    .background(.blue)
    .foregroundColor(.white)

// PreferenceKeys
// preference key is a swiftui mechanism for passing data up the view
// hierarchy from child views to ancestor views.
// most swiftui data flow goes downward (@State, @Binding, @Environment).
// preference key handles the opposite direction.
struct TitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""

    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
// a child sets pref
Text("Profile")
    .preference(
        key: TitlePreferenceKey.self,
        value: "Profile"
    )

// a parent reads it
VStack {
    ChildView()
}
.onPreferenceChange(TitlePreferenceKey.self) { title in
    print(title)
}

// A common real-world use is measuring child view sizes.
// Define a size preference:
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(
        value: inout CGSize,
        nextValue: () -> CGSize
    ) {
        value = nextValue()
    }
}

// Child reports its size using GeometryReader:

Text("Hello")
    .background(
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: SizePreferenceKey.self,
                    value: geometry.size
                )
        }
    )

// parent receives the size:
VStack {
    ChildView()
}
.onPreferenceChange(SizePreferenceKey.self) { size in
    print("Size:", size)
}

// when multiple children provide values, reduce determines how they are
// combined:
struct MaxWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(
        value: inout CGFloat,
        nextValue: () -> CGFloat
    ) {
        value = max(value, nextValue())
    }
}

// common uses include:
// 
// child size measurement
// scroll position tracking
// sticky headers
// custom navigation titles
// passing layout information upward
// coordinating sibling views through a common ancestor

// GeometryReader
// GeometryReader gives a view access to layout information such as size and
// position. Basic usage:
GeometryReader { geometry in
    Text("Width: \(geometry.size.width)")
}

// the geometry parameter is a GeometryProxy that provides:
geometry.size
geometry.safeAreaInsets
geometry.frame(in: .local)
geometry.frame(in: .global)

// example:
GeometryReader { geometry in
    VStack {
        Text("Width: \(geometry.size.width)")
        Text("Height: \(geometry.size.height)")
    }
}

// a common pattern is making a view size itself relative to available space:
GeometryReader { geometry in
    Rectangle()
        .frame(width: geometry.size.width * 0.8)
}

// one thing to remember: GeometryReader expands to fill all available space
// unless constrained.
GeometryReader { geometry in
    Text("Hello")
}
.frame(height: 100)

// CoordinateSpace
// coordinate spaces determine how positions and frames are measured.
// swiftui provides three coordinate spaces:
.local
.global
.named(...)

// Local coordinate space:
geometry.frame(in: .local)
// measures relative to the view's own container.

// Global coordinate space:
geometry.frame(in: .global)
// Measures relative to the screen/window. Example:
GeometryReader { geometry in
    let frame = geometry.frame(in: .global)

    Text("Y: \(frame.minY)")
}

// Named coordinate spaces allow custom reference systems.
ScrollView {
    ContentView()
}
.coordinateSpace(name: "scroll")

// to read from it:
GeometryReader { geometry in
    let frame = geometry.frame(in: .named("scroll"))

    Text("\(frame.minY)")
}
// useful inside scroll views. Example: tracking scroll offset.
struct OffsetReader: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scroll")).minY
                )
        }
    }
}
ScrollView {
    OffsetReader()

    VStack {
        // content
    }
}
.coordinateSpace(name: "scroll")

// Typical uses of GeometryReader with CoordinateSpace includes:
// - reading view size
// - responsive layouts
// - scroll offset tracking
// - sticky headers
// - parallax effects
// - detecting when views enter/leave the screen
// - custom animations based on position

// a useful mental model is GeometryReader answers "where am I and how much
// space do I have?" and CoordinateSpace answers "relative to what?"

// Lazy stacks and grids (LazyVStack, LazyHGrid)
// LazyVStack, LazyHStack, LazyVGrid, and LazyHGrid create views on demand as
// they become visible. This is important for large collections because
// SwiftUI does not need to instantiate every child view immediately.

// LazyVStack:
ScrollView {
    LazyVStack {
        ForEach(0..<1000) { index in
            Text("Row \(index)")
        }
    }
}
// Only the visible rows and nearby rows are created.

// LazyHStack:
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(0..<1000) { index in
            Text("Item \(index)")
        }
    }
}

// LazyVGrid uses columns:
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
]
var body: some View {
    ScrollView {
        LazyVGrid(columns: columns) {
            ForEach(0..<20) { item in
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 100)
            }
        }
    }
}

// LazyHGrid uses rows:
let rows = [
    GridItem(.fixed(100)),
    GridItem(.fixed(100))
]
var body: some View {
    ScrollView(.horizontal) {
        LazyHGrid(rows: rows) {
            ForEach(0..<20) { item in
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100)
            }
        }
    }
}

// common GridItem sizing options:
GridItem(.fixed(100))
GridItem(.flexible())
GridItem(.adaptive(minimum: 120))

// adaptive grids are useful for photo galleries:
let columns = [
    GridItem(.adaptive(minimum: 120))
]
// this automatically fits as many columns as possible.

// App Architecture Patterns: MVVM (Model-View-ViewModel)

// | Model     | Data and business entities          |
// | View      | UI rendering                        |
// | ViewModel | State management and business logic |

// model:
struct User: Identifiable {
    let id: UUID
    let name: String
}

// viewmodel:
import SwiftUI

final class UserViewModel: ObservableObject {
    @Published var users: [User] = []

    func loadUsers() {
        users = [
            User(id: UUID(), name: "Alice"),
            User(id: UUID(), name: "Bob")
        ]
    }
}

// view
struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        List(viewModel.users) { user in
            Text(user.name)
        }
        .onAppear {
            viewModel.loadUsers()
        }
    }
}

// dataflow looks like this:
/*

User Action
     v
   View
     v
  ViewModel
     v
Model / Service / API
     v
ViewModel updates @Published state
     v
View automatically refreshes

*/

// a more common example
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false

    func login() async {
        isLoading = true
        defer { isLoading = false }
        // API call
    }
}
struct LoginView: View {
    @StateObject private var vm = LoginViewModel()

    var body: some View {
        Form {
            TextField("Email", text: $vm.email)
            SecureField("Password", text: $vm.password)
            Button("Login") {
                Task {
                    await vm.login()
                }
            }
        }
    }
}

// Common MVVM guidelines in SwiftUI:
// 
// - Views should focus on presentation.
// - Business logic belongs in ViewModels.
// - Models represent data structures.
// - Networking and persistence are usually extracted into service/repository layers.
// - Use @StateObject when a view owns a ViewModel.
// - Use @ObservedObject when a ViewModel is provided by a parent.
// - Use @EnvironmentObject for shared application-wide state when appropriate.
// 
// A typical production structure might look like:

/*
Models/
    User.swift
    Product.swift

ViewModels/
    UserListViewModel.swift
    LoginViewModel.swift

Views/
    UserListView.swift
    LoginView.swift

Services/
    APIClient.swift
    UserService.swift
*/

// repository is data access abstraction. i.e. hides where the data comes from.
// The repository may:
// - Call APIs
// - Read/write databases
// - Access Core Data
// - Access files
// - Manage caching
// - Combine multiple data sources

protocol UserRepository {
    func fetchUsers() async throws -> [User]
}

final class RemoteUserRepository: UserRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchUsers() async throws -> [User] {
        try await apiClient.getUsers()
    }
}
// the implementation can be multiple for multiple sources.
// a service performs actions and business workflows.
protocol AuthService {
    func login(email: String, password: String) async throws
}
final class AuthServiceImpl: AuthService {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func login(
        email: String,
        password: String
    ) async throws {
        let token = try await authRepository.login(
            email: email,
            password: password
        )
        // business rules
        SessionManager.shared.token = token
    }
}
// Services often:
// - Implement business rules
// - Coordinate multiple repositories
// - Validate data
// - Execute workflows
// - Handle domain-specific operations

//-------------------------------------------

// Suppose for an e-commerce app.

// Repository layer:
// - ProductRepository
// - OrderRepository
// - UserRepository

// Responsibilities:
// - Fetch products
// - Save cart
// - Load orders
// - Persist user profile

// Service layer:
// - CheckoutService
// - PricingService
// - RecommendationService

// Responsibilities:
// - Calculate totals
// - Apply discounts
// - Validate inventory
// - Create order
// - Send confirmation

// A checkout flow might look like:

/*
CheckoutService
    ↓
ProductRepository
    ↓
OrderRepository
    ↓
PaymentGateway
*/

// The service orchestrates the process. The repositories provide the data.

// A practical rule:

// If the question is: "Where does this data come from?" that logic usually
// belongs in a repository.

// If the question is: "How should this business operation work?" that logic
// usually belongs in a service.

// Example:

// Repository
func getUser(id: UUID) async throws -> User
// Service
func purchaseProduct(
    productId: UUID
) async throws

// The first retrieves data. The second executes a business use case.
// In SwiftUI MVVM projects, a common dependency chain is:

/*
   View
     v
ViewModel
     v
  Service
     v
Repository
     v
API / Database
*/

// other patterns include VIPER, Redux
// VIPER stands for View, Interactor, Presenter, Entity, Router
// Redux originated in the JavaScript ecosystem and is based on a single
// source of truth. Core concept is State, Action, Reducer, Store
// state
struct AppState {
    var counter = 0
}
// action
enum AppAction {
    case increment
    case decrement
}
// reducer
func reducer(
    state: inout AppState,
    action: AppAction
) {
    switch action {
    case .increment:
        state.counter += 1

    case .decrement:
        state.counter -= 1
    }
}
// store
final class Store: ObservableObject {
    @Published private(set) var state = AppState()

    func dispatch(_ action: AppAction) {
        reducer(state: &state, action: action)
    }
}

// then the view
struct CounterView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        VStack {
            Text("\(store.state.counter)")

            Button("+") {
                store.dispatch(.increment)
            }
        }
    }
}

// --------------------------------------------

// Dependency injection in SwiftUI
// type receives its dependencies from the outside instead of creating them
// itself
final class UserViewModel: ObservableObject {
    private let repository = UserRepository()
}
// this is bad.

final class UserViewModel: ObservableObject {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }
}
// preferred

// --------------------------------------------

// constructor injection
struct UserView: View {
    @StateObject private var vm: UserViewModel

    init(repository: UserRepository) {
        _vm = StateObject(
            wrappedValue: UserViewModel(
                repository: repository
            )
        )
    }

    var body: some View {
        Text("Users")
    }
}
// composition root
let repository = UserRepositoryImpl()
let view = UserView(repository: repository)

// --------------------------------------------

// environment injection
final class SessionStore: ObservableObject {
    @Published var currentUser: User?
}
// inject
@main
struct MyApp: App {
    @StateObject private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
        }
    }
}
// consume
@EnvironmentObject var session: SessionStore

// --------------------------------------------

// for lightweight dependencies
struct APIClientKey: EnvironmentKey {
    static let defaultValue = APIClient()
}

extension EnvironmentValues {
    var apiClient: APIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}

// usage
@Environment(\.apiClient) var apiClient

// dependency container
final class AppContainer {
    let apiClient = APIClient()
    lazy var userRepository = UserRepositoryImpl(apiClient: apiClient)
    lazy var userService = UserService(repository: userRepository)
}

// at startup
let container = AppContainer()
// then pass dependencies from the container into ViewModels, services, and repositories.

// Animations, Graphics, & Transitions .slide, .opacity, .scale, custom transitions
// SwiftUI animations are typically driven by state changes.

// Implicit animation:

struct ContentView: View {
    @State private var expanded = false

    var body: some View {
        Circle()
            .frame(
                width: expanded ? 200 : 100,
                height: expanded ? 200 : 100
            )
            .animation(.easeInOut, value: expanded)
            .onTapGesture {
                expanded.toggle()
            }
    }
}

// Explicit animation:

withAnimation(.spring()) {
    expanded.toggle()
}

// Common animation types:
/*

.easeIn
.easeOut
.easeInOut
.linear
.spring()
.bouncy()
.smooth()
.snappy()

*/

// Transitions control how views enter and leave the hierarchy.

// Opacity transition:
if isVisible {
    Text("Hello")
        .transition(.opacity)
}
withAnimation {
    isVisible.toggle()
}

// Slide transition:
.transition(.slide)

// Scale transition:
.transition(.scale)

// Move transition:
.transition(
    .move(edge: .bottom)
)

// Combined transition:
.transition(
    .move(edge: .bottom)
        .combined(with: .opacity)
)

// Asymmetric transition:
.transition(
    .asymmetric(
        insertion: .scale,
        removal: .opacity
    )
)

// Custom transition:
extension AnyTransition {
    static var popIn: AnyTransition {
        .scale
            .combined(with: .opacity)
    }
}
// Usage:
.transition(.popIn)

// Drawing with SwiftUI Canvas
// Canvas provides low-level drawing capabilities while staying within SwiftUI.

// Basic drawing:
Canvas { context, size in
    let rect = CGRect(
        x: 0,
        y: 0,
        width: size.width,
        height: size.height
    )

    context.fill(
        Path(ellipseIn: rect),
        with: .color(.blue)
    )
}
.frame(width: 200, height: 200)

// Drawing a line:
Canvas { context, size in
    var path = Path()

    path.move(to: .zero)

    path.addLine(
        to: CGPoint(
            x: size.width,
            y: size.height
        )
    )

    context.stroke(
        path,
        with: .color(.red),
        lineWidth: 4
    )
}

// Drawing text
Canvas { context, size in
    let text = Text("SwiftUI")

    context.draw(
        text,
        at: CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
    )
}
// Typical Canvas use cases:
// - Charts and graphs
// - Particle effects
// - Custom visualizations
// - Drawing tools
// - Performance-sensitive graphics

// SpriteKit and SceneKit
// SpriteKit is Apple's 2D game framework. Features:
// 
// - 2D rendering
// - Physics engine
// - Particle systems
// - Collision detection
// - Tile maps
// - Animations

// Scene:

import SpriteKit

final class GameScene: SKScene {
    override func didMove(
        to view: SKView
    ) {
        let sprite = SKSpriteNode(
            color: .red,
            size: CGSize(
                width: 100,
                height: 100
            )
        )

        addChild(sprite)
    }
}

// Embedding in SwiftUI:
SpriteView(
    scene: GameScene()
)

// SceneKit is Apple's high-level 3D graphics framework. Features:

// - 3D scenes
// - Cameras
// - Lighting
// - Materials
// - Animations
// - Physics

// scene:

import SceneKit

let scene = SCNScene()
let sphere = SCNSphere(radius: 1)
let node = SCNNode(
    geometry: sphere
)
scene.rootNode.addChildNode(node)

// in SwiftUI:
SceneView(
    scene: scene
)
