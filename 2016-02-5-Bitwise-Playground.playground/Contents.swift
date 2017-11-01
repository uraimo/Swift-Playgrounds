//: Opinionated Bitwise operations in Swift
//: -----
//:
//: See original post at [https://www.uraimo.com/2016/02/05/Dealing-With-Bit-Sets-In-Swift](https://www.uraimo.com/2016/02/05/Dealing-With-Bit-Sets-In-Swift)



//: Variables with a fixed width integer type can be initialized with a binary, octal or hexadecimal value this way
//:

var int1:UInt8 = 0b10101010
var int2:UInt8 = 0o55
var int3:UInt8 = 0xA7

//: Where are we?? We can check the size of the Int type with strideof(or sizeof in this case) to understand on wich platform we are
//:

MemoryLayout<Int>.stride==MemoryLayout<Int32>.stride //Are we on a 32bits platform? Nope.

//: Swift does not perform implicit conversions
//:

var u8:UInt8 = 1
u8 << 2             //4: The number 2 is considered an UInt8 and u8 is shifted
                    //   to the left by 2 positions

var by2:Int16 = 1
//u8 << by2         //Error: Operands of different types, doesn't compile
u8 << UInt8(by2)    //4: It works, we manually converted the Int type,
                    //   but this is NOT SAFE!

//: Most of the times you'll want to truncate the value when you are converting, but remember, it's a **bit pattern** truncation, not a decimal one

var u82:UInt8=UInt8(truncatingIfNeeded:1000) //Remove the truncatingBitPattern: for a runtime error!
u82 // 232

//: Extending integer types with some utility methods
//:

extension Int {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(truncatingIfNeeded:self)}}
    public var to32: Int32{get{return Int32(truncatingIfNeeded:self)}}
    public var toU64: UInt64{get{
            return UInt64(self) //No difference if the platform is 32 or 64
        }}
    public var to64: Int64{get{
            return Int64(self) //No difference if the platform is 32 or 64
        }}
}

extension Int32 {
    public var toU8: UInt8{ get{return UInt8(truncatingIfNeeded:self)} }
    public var to8: Int8{ get{return Int8(truncatingIfNeeded:self)} }
    public var toU16: UInt16{get{return UInt16(truncatingIfNeeded:self)}}
    public var to16: Int16{get{return Int16(truncatingIfNeeded:self)}}
    public var toU32: UInt32{get{return UInt32(self)}}
    public var to32: Int32{get{return self}}
    public var toU64: UInt64{get{
        return UInt64(self) //No difference if the platform is 32 or 64
        }}
    public var to64: Int64{get{
        return Int64(self) //No difference if the platform is 32 or 64
        }}
}

var h1 = 0xFFFF04
h1
h1.toU8

var h2:Int32 = 0x6F00FF05
h2.toU16


//: Separating component from a RGB color
//:

let swiftOrange = 0xED903B
let red = (swiftOrange & 0xFF0000) >> 16    //0xED
let green = (swiftOrange & 0x00FF00) >> 8   //0x90
let blue = swiftOrange & 0x0000FF           //0x3B

//: With subscript!

extension UInt32 {
    public subscript(index: Int) -> UInt32 {
        get {
            precondition(index<4,"Byte set index out of range")
            return (self & (0xFF << (index.toU32*8))) >> (index.toU32*8)
        }
        set(newValue) {
            precondition(index<4,"Byte set index out of range")
            self = (self & ~(0xFF << (index.toU32*8))) | (newValue << (index.toU32*8))
        }
    }
}

var i32:UInt32=982245678

print(String(i32,radix:16,uppercase:true))      // Printing the hex value

i32[3] = i32[0]
i32[1] = 0xFF
i32[0] = i32[2]

print(String(i32,radix:16,uppercase:true))


//: Performing poor man cryptography with XOR
//:

let secretMessage = 0b10101000111110010010101100001111000 // 0x547C95878
let secretKey =  0b10101010101010000000001111111111010    // 0x555401FFA
let result = secretMessage ^ secretKey                    // 0x12894782

let original = result ^ secretKey                         // 0x547C95878
print(String(secretMessage,radix:16,uppercase:true))      // Printing the hex value
print(String(secretKey,radix:16,uppercase:true))
print(String(original,radix:16,uppercase:true))


//: Integer swapping, without tmp!
//:

var x=1
var y=2
x = x ^ y
y = y ^ x   // y is now 1
x = x ^ y   // x is now 2

//: Double negation bitwise operator ~~
//:

prefix operator ~~
prefix func ~~(value: UInt8)->UInt8{
    return (value>0) ? 1 : 0
}


~~7
~~0


let input = 0b10101101
let mask = 0b00001000
let isSet = ~~(input.toU8 & mask.toU8)  // If the 4th bit is set this is equal to 1.



