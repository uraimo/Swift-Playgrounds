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
testUnion.asChar // (33, 0, 0, 0)

testUnion.f = 1234567
testUnion.f  // 1234567
testUnion.i  // 1234613304
testUnion.asChar // (56, 180, 150, 73)

var fv:Float32 = unsafeBitCast(Int32(33), to: Float.self)

MemoryLayout<TestUnion>.stride  // 4 bytes

//: ### The size of things
//:

print(MemoryLayout<CChar>.stride)  // 1

struct Struct1{
    let anInt8:Int64
    let anInt:Int16
    let b:Bool
}

print(MemoryLayout<Struct1>.size)    // 11 (8+2+1)
print(MemoryLayout<Struct1>.stride)  // 16 (8+4+4)

//: ### Macros
//:

IAMADEFINE  //42


//: ### Working with Pointers
//:

var i:Int32 = 42
giveMeUnsafeMutablePointer(&i);


let namestr = withUnsafePointer(to: &name, { (ptr) -> String? in
    let charPtr = ptr.withMemoryRebound(to: CChar.self, capacity: 11, {
        (cptr) -> String in
            return String(validatingUTF8: cptr)!
    })
    return charPtr
})


print(namestr!) //IAmAString


let array: [Int8] = [ 65, 66, 67, 0 ]
puts(array)  // ABC
array.withUnsafeBufferPointer { (ptr: UnsafeBufferPointer<Int8>) in
    puts(ptr.baseAddress! + 1) //BC
}

//: ### Allocating memory
//:

var ptr = UnsafeMutablePointer<CChar>.allocate(capacity: 10)
//Or alternatively: var ptr = malloc(10*MemoryLayout<CChar>.stride).bindMemory(to: CChar.self, capacity: 10*MemoryLayout<CChar>.stride)

ptr.initialize(from: Array<CChar>(repeating: 0, count: 10))

//Do something with the object
ptr[3] = 42

ptr.deinitialize() //Clean up

ptr.deallocate(capacity: 10) //Let's free the memory we allocated
//Or alternatively: free(ptr)


var sptr = UnsafeMutablePointer<String>.allocate(capacity: 1)
sptr.initialize(to: "Test String")
print(sptr.pointee)

sptr.deinitialize()
sptr.deallocate(capacity: 1)

//: Is initialization really necessary?

struct MyStruct1{
    var int1:Int
    var int2:Int
}

var s1ptr = UnsafeMutablePointer<MyStruct1>.allocate(capacity: 5)

s1ptr[0] = MyStruct1(int1: 1, int2: 2)
s1ptr[1] = MyStruct1(int1: 1, int2: 2) //Doesn't seems so, this always works!

s1ptr.deinitialize()
s1ptr.deallocate(capacity: 5)

//: Let's try introducing a reference type property to MyStruct

class TestClass{
    var aField:Int = 0
}

struct MyStruct2{
    var int1:Int
    var int2:Int
    var tc:TestClass
}

var s2ptr = UnsafeMutablePointer<MyStruct2>.allocate(capacity: 5)
s2ptr.initialize(from: [MyStruct2(int1: 1, int2: 2, tc: TestClass()),   // Remove the initialization
                      MyStruct2(int1: 1, int2: 2, tc: TestClass())])  // and you'll have a crash below

s2ptr[0] = MyStruct2(int1: 1, int2: 2, tc: TestClass())
s2ptr[1] = MyStruct2(int1: 1, int2: 2, tc: TestClass())

s2ptr.deinitialize()
s2ptr.deallocate(capacity: 5)


//: Other examples from the malloc family:

var val = Array<CChar>(repeating: 0, count: 10)
var buf = Array<CChar>(repeating: 0, count: val.count)
memcpy(&buf, &val, buf.count*MemoryLayout<CChar>.stride)
buf

let mptr = mmap(nil, Int(getpagesize()), PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0)!

if (unsafeBitCast(mptr, to: Int.self) == -1) {    //MAP_FAILED not available, but its value is (void*)-1
    perror("dma mmap error")
    abort()
}

// Bind the *uninitialized* memory to the Int type, for initialized memory we should have used .assumingMemoryBound(to:)
let iptr = mptr.bindMemory(to: Int.self, capacity: Int(getpagesize())/MemoryLayout<Int>.stride)
iptr[0] = 3

munmap(ptr, Int(getpagesize()))

//: ### Pointer arithmetic
//:

var aptr = UnsafeMutablePointer<CChar>.allocate(capacity: 5)
aptr.initialize(from: [33,34,35,36,37])

print(aptr.successor().pointee) // 34
print(aptr.advanced(by: 3).pointee) // 36
print(aptr.advanced(by: 3).predecessor().pointee) // 35

print(aptr.distance(to: aptr.advanced(by: 3))) // 3


print((aptr+1).pointee) // 34
print((aptr+3).pointee) // 36
print(((aptr+3)-1).pointee) // 35

aptr.deinitialize()
aptr.deallocate(capacity: 5)

//: ### Working with strings
//:

puts("Hey! I was a Swift string!")

var testString = "AAAAA"

testString.withCString { (ptr: UnsafePointer<Int8>) -> Void in
    // Do something with ptr
    functionThatExpectsAConstCharPointer(ptr)
}


let swiftString = String(validatingUTF8: anotherName)

func isPrintable(text:String)->Bool{
    for scalar in text.unicodeScalars {
        let charCode = scalar.value
        guard (charCode>31)&&(charCode<127) else {
            return false // Unprintable character
        }
    }
    return true
}

isPrintable(text: "No, it's not 😅")


//: ### Working with closures
//:

printStuff(); // Imported C function defined in CExample.c

let fun = returnAFunction(); // Imported C function defined in CExample.c
fun!()

//: Unmanaged

class AClass : CustomStringConvertible {
    
    var aProperty:Int=0

    var description: String {
        return "A \(type(of: self)) with property \(self.aProperty)"
    }
}

var value = AClass()

let unmanaged = Unmanaged.passRetained(value)
let uptr = unmanaged.toOpaque()
let vptr = UnsafeMutableRawPointer(uptr)

aCFunctionWithContext(vptr){ (p:UnsafeMutableRawPointer?) -> Void in
    var c = Unmanaged<AClass>.fromOpaque(p!).takeUnretainedValue()
    c.aProperty = 2
    print(c) //A AClass with property 2
}



