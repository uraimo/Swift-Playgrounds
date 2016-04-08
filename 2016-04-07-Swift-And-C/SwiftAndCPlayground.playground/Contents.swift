//: Swift And C Playground
//: -----
//:
//: See original post at [https://www.uraimo.com/2016/04/06/swift-and-c-everything-you-need-to-know](https://www.uraimo.com/2016/04/06/swift-and-c-everything-you-need-to-know)
//:
//: To execute this playground you need to build the C framework CExample first, just open the workspace, select  the CExample project and build it with cmd+B and then open the playground. Don't just open the playgoud directly or it will not be able to find the C module it needs



import Foundation
import CExample


//: ### Arrays and Structs
//:

print(name)

let ms = MyStruct(name: (0, 0, 0, 0, 0), value: 1)
print(ms)


//: ### Unions

testUnion.i = 33
testUnion.f  // 4.624285e-44
testUnion.i  // 33
testUnion.f = 1234567
testUnion.f  // 1234567
testUnion.i  // 1234613304
testUnion.asChar // (56, 180, 150, 73)

var fv:Float32 = unsafeBitCast(Int32(33), Float.self)

strideof(TestUnion)  // 4 bytes

//: ### The size of things
//:

print(strideof(CChar))  // 1

struct Struct1{
    let anInt8:Int64
    let anInt:Int16
    let b:Bool
}

print(sizeof(Struct1))    // 11 (8+2+1)
print(strideof(Struct1))  // 16 (8+4+4)

//: ### Macros
//:

IAMADEFINE  //42


//: ### Working with Pointers
//:

var i:Int32 = 42
giveMeUnsafeMutablePointer(&i);


let namestr = withUnsafePointer(&name, { (ptr) -> String? in
    let charPtr = UnsafeMutablePointer<CChar>(ptr)
    charPtr[2] = 35 // # character
    return String.fromCString(charPtr)
})
print(namestr!) //IAmAString


let array: [Int8] = [ 65, 66, 67, 0 ]
puts(array)  // ABC
array.withUnsafeBufferPointer { (ptr: UnsafeBufferPointer<Int8>) in
    puts(ptr.baseAddress + 1) //BC
}

//: ### Allocating memory
//:

var ptr = UnsafeMutablePointer<CChar>.alloc(10)
//Or alternatively: var ptr = UnsafeMutablePointer<CChar>(malloc(10*strideof(CChar)))

ptr.initializeFrom([CChar](count: 10, repeatedValue: 0))

//Do something with the object
ptr[3] = 42

ptr.destroy() //Clean up

ptr.dealloc(10) //Let's free the memory we allocated
//Or alternatively: free(ptr)


var sptr = UnsafeMutablePointer<String>.alloc(1)
sptr.initialize("Test String")
print(sptr.memory)

sptr.destroy()
sptr.dealloc(1)

//: Is initialization really necessary?

struct MyStruct1{
    var int1:Int
    var int2:Int
}

var s1ptr = UnsafeMutablePointer<MyStruct1>.alloc(5)

s1ptr[0] = MyStruct1(int1: 1, int2: 2)
s1ptr[1] = MyStruct1(int1: 1, int2: 2) //Doesn't seems so, this always works!

s1ptr.destroy()
s1ptr.dealloc(5)

//: Let's try introducing a reference type property to MyStruct

class TestClass{
    var aField:Int = 0
}

struct MyStruct2{
    var int1:Int
    var int2:Int
    var tc:TestClass
}

var s2ptr = UnsafeMutablePointer<MyStruct2>.alloc(5)
s2ptr.initializeFrom([MyStruct2(int1: 1, int2: 2, tc: TestClass()),   // Remove the initialization
                      MyStruct2(int1: 1, int2: 2, tc: TestClass())])  // and you'll have a crash below

s2ptr[0] = MyStruct2(int1: 1, int2: 2, tc: TestClass())
s2ptr[1] = MyStruct2(int1: 1, int2: 2, tc: TestClass())

s2ptr.destroy()
s2ptr.dealloc(5)


//: Other examples from the malloc family:

var val = [CChar](count: 10, repeatedValue: 1)
var buf = [CChar](count: val.count, repeatedValue: 0)
memcpy(&buf, &val, buf.count*strideof(CChar))
buf

let mptr = UnsafeMutablePointer<Int>(mmap(nil, Int(getpagesize()), PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0))
mptr[0] = 3

munmap(ptr, Int(getpagesize()))

//: ### Pointer arithmetic
//:

var aptr = UnsafeMutablePointer<CChar>.alloc(5)
aptr.initializeFrom([33,34,35,36,37])

print(aptr.successor().memory) // 34
print(aptr.advancedBy(3).memory) // 36
print(aptr.advancedBy(3).predecessor().memory) // 35

print(aptr.distanceTo(aptr.advancedBy(3))) // 3


print((aptr+1).memory) // 34
print((aptr+3).memory) // 36
print(((aptr+3)-1).memory) // 35

aptr.destroy()
aptr.dealloc(5)

//: ### Working with strings
//:

puts("Hey! I was a Swift string!")

var testString = "AAAAA"

testString.withCString { (ptr: UnsafePointer<Int8>) -> Void in
    // Do something with ptr
    functionThatExpectsAConstCharPointer(ptr)
}


let swiftString = String.fromCString(anotherName)

func isPrintable(text:String)->Bool{
    for scalar in text.unicodeScalars {
        let charCode = scalar.value
        guard (charCode>31)&&(charCode<127) else {
            return false // Unprintable character
        }
    }
    return true
}

isPrintable("No, it's not 😅")


//: ### Working with closures
//:

printStuff(); // Imported C function defined in CExample.c

let fun = returnAFunction(); // Imported C function defined in CExample.c
fun()

//: Unmanaged

class AClass : CustomStringConvertible {
    
    var aProperty:Int=0

    var description: String {
        return "A \(self.dynamicType) with property \(self.aProperty)"
    }
}

var value = AClass()

let unmanaged = Unmanaged.passRetained(value)
let uptr = unmanaged.toOpaque()
let vptr = UnsafeMutablePointer<Void>(uptr)

aCFunctionWithContext(vptr){ (p:UnsafeMutablePointer<Void>) -> Void in
    var c = Unmanaged<AClass>.fromOpaque(COpaquePointer(p)).takeUnretainedValue()
    c.aProperty = 2
    print(c) //A AClass with property 2
}



