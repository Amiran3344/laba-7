import Foundation

// Лабораторная работа №7


//  A. Temperature 
struct Temperature {
    var celsius: Double
    var fahrenheit: Double {
        get { celsius * 9 / 5 + 32 }
        set { celsius = (newValue - 32) * 5 / 9 }
    }
}
var temp = Temperature(celsius: 100)
print(temp.fahrenheit)
temp.fahrenheit = 32
print(temp.celsius)

//  B. Vector2D 
struct Vector2D {
    var x: Double
    var y: Double
    var magnitude: Double { (x * x + y * y).squareRoot() }
    mutating func scale(by factor: Double) { x *= factor; y *= factor }
    static func add(_ a: Vector2D, _ b: Vector2D) -> Vector2D {
        return Vector2D(x: a.x + b.x, y: a.y + b.y)
    }
}
var v1 = Vector2D(x: 3, y: 4)
print(v1.magnitude)
v1.scale(by: 2)
print(v1)
let v2 = Vector2D(x: 1, y: 1)
print(Vector2D.add(v1, v2))

// C. Circle 
struct Circle {
    var radius: Double
    var area: Double { Double.pi * radius * radius }
    var diameter: Double {
        get { radius * 2 }
        set { radius = newValue / 2 }
    }
}
var c = Circle(radius: 5)
print(c.area)
print(c.diameter)
c.diameter = 6
print(c.radius)

// D. StepCounter 
struct StepCounter {
    var totalSteps: Int {
        willSet { print("Значение изменится с \(totalSteps) на \(newValue)") }
        didSet { print("Шагов добавлено: \(totalSteps - oldValue). Всего: \(totalSteps).") }
    }
}
var stepper = StepCounter(totalSteps: 0)
stepper.totalSteps = 100
stepper.totalSteps = 360

// E. Value vs Reference
struct PointStruct { var x: Int; var y: Int }
class PointClass { var x: Int; var y: Int
    init(x: Int, y: Int) { self.x = x; self.y = y }
}

var structA = PointStruct(x: 1, y: 2)
var structB = structA
structB.x = 99
print(structA.x, structB.x)

let classA = PointClass(x: 1, y: 2)
let classB = classA
classB.x = 99
print(classA.x, classB.x)
print(classA === classB)

func modifyClass(_ p: PointClass) { p.x += 10 }
func modifyStruct(_ p: inout PointStruct) { p.x += 10 }
let obj = PointClass(x: 5, y: 5)
modifyClass(obj)
print(obj.x)
var val = PointStruct(x: 5, y: 5)
modifyStruct(&val)
print(val.x)

// F. BankCard 
struct BankCard {
    let number: String
    let holder: String
    private(set) var balance: Double

    init(number: String, holder: String, initialBalance: Double = 0) {
        self.number = number
        self.holder = holder
        self.balance = initialBalance
    }

    mutating func deposit(_ amount: Double) {
        guard amount > 0 else { return }
        balance += amount
    }

    mutating func withdraw(_ amount: Double) -> Bool {
        guard amount > 0, balance >= amount else { return false }
        balance -= amount
        return true
    }
}
var card = BankCard(number: "4276-XXXX-XXXX-1234", holder: "Иван Петров", initialBalance: 1000)
card.deposit(500)
print(card.balance)
print(card.withdraw(2000))
print(card.withdraw(300))
print(card.balance)

// G. Counter 
struct Counter {
    static var totalCreated: Int = 0
    var count: Int = 0
    init() { Counter.totalCreated += 1 }
    mutating func increment(by amount: Int = 1) { count += amount }
}
var c1 = Counter(), c2 = Counter()
c1.increment(by: 5)
c2.increment()
print(c1.count, c2.count, Counter.totalCreated)

//  H. Связный список 
class LinkedNode {
    var value: Int
    var next: LinkedNode?
    init(value: Int, next: LinkedNode?) { self.value = value; self.next = next }
}

func printList(_ head: LinkedNode?) {
    var current = head
    var parts: [String] = []
    while let node = current { parts.append("\(node.value)"); current = node.next }
    print(parts.joined(separator: " -> ") + " -> nil")
}

func sum(_ head: LinkedNode?) -> Int {
    var total = 0
    var current = head
    while let node = current { total += node.value; current = node.next }
    return total
}

func count(_ head: LinkedNode?) -> Int {
    var n = 0
    var current = head
    while current != nil { n += 1; current = current?.next }
    return n
}

let node3 = LinkedNode(value: 30, next: nil)
let node2 = LinkedNode(value: 20, next: node3)
let node1 = LinkedNode(value: 10, next: node2)
printList(node1)
print(sum(node1))
print(count(node1))

// I. Прямоугольник 
struct Point { var x: Double; var y: Double }
struct Size { var width: Double; var height: Double }

struct Rectangle {
    var origin: Point
    var size: Size

    var area: Double { size.width * size.height }
    var perimeter: Double { 2 * (size.width + size.height) }
    var center: Point {
        get { Point(x: origin.x + size.width / 2, y: origin.y + size.height / 2) }
        set {
            origin.x = newValue.x - size.width / 2
            origin.y = newValue.y - size.height / 2
        }
    }

    func contains(_ point: Point) -> Bool {
        return point.x >= origin.x && point.x <= origin.x + size.width &&
               point.y >= origin.y && point.y <= origin.y + size.height
    }

    mutating func translate(dx: Double, dy: Double) {
        origin.x += dx; origin.y += dy
    }
}

var rect = Rectangle(origin: Point(x: 0, y: 0), size: Size(width: 10, height: 5))
print(rect.area)
print(rect.center)
rect.center = Point(x: 0, y: 0)
print(rect.origin)
print(rect.contains(Point(x: -3, y: -1)))

let rects = [
    Rectangle(origin: Point(x: 0, y: 0), size: Size(width: 10, height: 5)),
    Rectangle(origin: Point(x: 2, y: 2), size: Size(width: 20, height: 15)),
    Rectangle(origin: Point(x: -5, y: -5), size: Size(width: 4, height: 4))
]
if let largest = rects.max(by: { $0.area < $1.area }) {
    print("Наибольшая площадь: \(largest.area)")
}
let containing = rects.filter { $0.contains(Point(x: 5, y: 5)) }
print("Содержат (5,5): \(containing.count)")