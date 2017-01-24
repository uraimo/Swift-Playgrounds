//: Unowned or Weak? Lifetime and Performance
//: -----
//:
//: See original post at [https://www.uraimo.com/2016/10/27/unowned-or-weak-lifetime-and-performance/](https://www.uraimo.com/2016/10/27/unowned-or-weak-lifetime-and-performance/)
//:


var i1 = 1, i2 = 1

//: Capturing values without capture list: The original variables will be modified inside fStrong

var fStrong = {
    i1 += 1
    i2 += 2
}

//: Capturing with a capture list but without a modifier: A local constant will be created with the original value, from that point onward all modifications to the variable will be local
var fCopy = { [i1] in
    print(i1,i2)
}

fStrong()
i1 // 2
i2 // 3

fCopy()  //Prints 1 and 3

//: Capturing reference values using unowned or weak

class aClass{
    var value = 1
}

var c1 = aClass()
var c2 = aClass()

var fSpec = { [unowned c1, weak c2] in
    c1.value += 1
    if let c2 = c2 {
        c2.value += 1
    }
}

fSpec()
c1.value // 2
c2.value // 2

