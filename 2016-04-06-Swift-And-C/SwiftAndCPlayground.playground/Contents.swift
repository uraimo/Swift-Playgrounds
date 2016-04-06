//: Swift And C Playground
//: -----
//:
//: See original post at [https://www.uraimo.com/](https://www.uraimo.com/)
//:
//: To execute this playground you need to build the C framework CExample first, just open the workspace, select  the CExample project and build it with cmd+B and then open the playground. Don't just open the playgoud directly or it will not be able to find the C module it needs



import Foundation
import CExample


//: Arrays and Structs
//:

print(name)

let ms = MyStruct(name: (0, 0, 0, 0, 0), value: 1)
print(ms)


//: The size of things
//:

print(strideof(CChar))  // 1

struct Struct1{
    let anInt8:Int64
    let anInt:Int16
    let b:Bool
}

print(sizeof(Struct1))    // 11 (8+2+1)
print(strideof(Struct1))  // 16 (8+4+4)

//: Macros
//:

IAMADEFINE  //42


//: Working with Pointers
//:

var i:Int32 = 42
giveMeUnsafeMutablePointer(&i);


let namestr = withUnsafePointer(&name, { (ptr) -> String? in
    let charPtr = UnsafeMutablePointer<CChar>(ptr)
    return String.fromCString(charPtr)
})
print(namestr!) //IAmAString


let array: [Int8] = [ 65, 66, 67, 0 ]
puts(array)  // ABC
array.withUnsafeBufferPointer { (ptr: UnsafeBufferPointer<Int8>) in
    puts(ptr.baseAddress + 1) //BC
}

//: Allocating memory
//:

var ptr = UnsafeMutablePointer<CChar>.alloc(10)
//Or alternatively: var ptr = UnsafeMutablePointer<CChar>(malloc(10*strideof(CChar)))

ptr.initializeFrom([CChar](count: 10, repeatedValue: 0))

ptr.destroy() //Clean up

ptr.dealloc(10) //Let's free the memory we allocated
//Or alternatively: free(ptr)


var sptr = UnsafeMutablePointer<String>.alloc(1)
sptr.initialize("Test String")
print(sptr.memory)

sptr.destroy()
sptr.dealloc(1)


var val = 42
var buf = [CChar](count: sizeofValue(val), repeatedValue: 0)
memcpy(&buf, &val, Int(buf.count))

let mptr = UnsafeMutablePointer<Int>(mmap(nil, Int(getpagesize()), PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0))
mptr[0] = 3

munmap(ptr, Int(getpagesize()))

//: Pointer arithmetic
//:

var aptr = UnsafeMutablePointer<CChar>.alloc(5)
aptr.initializeFrom([33,34,35,36,37])

print(aptr.successor().memory) // 34
print(aptr.advancedBy(3).memory) // 36
print(aptr.advancedBy(3).predecessor().memory) // 35

print(aptr.distanceTo(aptr.advancedBy(3))) // 3

aptr.destroy()
aptr.dealloc(5)


print((aptr+1).memory) // 34
print((aptr+3).memory) // 36
print(((aptr+3)-1).memory) // This will not work!



//: Working with strings
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


//: Working with closures
//:

printStuff(); // Imported C function defined in CExample.c

let fun = returnAFunction(); // Imported C function defined in CExample.c
fun()





