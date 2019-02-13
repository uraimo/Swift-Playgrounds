//: Playground - noun: a place where people can play
//
// See original post at http://www.uraimo.com/2015/10/07/Swift2-map-flatmap-demystified


import UIKit

///////////////////////////////////////
// MAP
// .map optionals

var o1:Int? = nil

var o1m = o1.map({$0 * 2})
o1m /* Int? with content nil */

o1 = 1

o1m = o1.map({$0 * 2})
o1m /* Int? with content 2 */

var os1m = o1.map({ (value) -> String in
    String(value * 2)
})
os1m /* String? with content "2" */

os1m = o1.map({ (value) -> String in
    String(value * 2)
}).map({"number "+$0})
os1m /* String? with content "number 2" */


// .map SequenceType: Array

var a1 = [1,2,3,4,5,6]

var a1m = a1.map({$0 * 2})
a1m /*[Int] with content [2, 4, 6, 8, 10, 12] */

var ao1:[Int?] = [1,2,3,4,5,6]

var ao1m = ao1.map({$0! * 2})
ao1m /*[Int] with content [2, 4, 6, 8, 10, 12] */

var a1ms = a1.map({ (value) -> String in
    String(value * 2)
}).map { (stringValue) -> Int? in
    Int(stringValue)
}
a1ms /*[Int?] with content [{Some 2}, {Some 4}, {Some 6}, {Some 8}, {Some 10}, {Some 12}] */

// .map Additional examples

var s1:String? = "1"
var i1 = s1.map {
    Int($0)
}
i1 /* Int?? with content 1 */

var ar1 = ["1","2","3","a"]
var ar1m = ar1.map {
    Int($0)
}
ar1m /* [Int?] with content [{Some 1}, {Some 2}, {Some 3}, nil] */

ar1m = ar1.map {
    Int($0)
    }
    .filter({$0 != nil})
    .map {$0! * 2}
ar1m /* [Int?] with content [{Some 2}, {Some 4}, {Some 6}] */

///////////////////////////////////////
// FLATMAP


// .flatMap optionals

var fo1:Int? = nil

var fo1m = fo1.flatMap({$0 * 2})
fo1m /* Int? with content nil */

fo1 = 1

fo1m = fo1.flatMap({$0 * 2})
fo1m /* Int? with content 2 */

var fos1m = fo1.flatMap({ (value) -> String? in
    String(value * 2)
})
fos1m /* String? with content "2" */

var fs1:String? = "1"

var fi1 = fs1.flatMap {
    Int($0)
}
fi1 /* Int? with content "1" */

var fi2 = fs1.flatMap {
    Int($0)
    }.map {$0*2}

fi2 /* Int? with content "2" */


// .flatMap SequenceTypes

var fa1 = [1,2,3,4,5,6]

var fa1m = fa1.compactMap({$0 * 2})
fa1m /*[Int] with content [2, 4, 6, 8, 10, 12] */

var fao1:[Int?] = [1,2,3,4,nil,6]

var fao1m = fao1.compactMap({$0})
fao1m /*[Int] with content [1, 2, 3, 4, 6] */

var fa2 = [[1,2],[3],[4,5,6]]

var fa2m = fa2.compactMap({$0})
fa2m /*[Int] with content [1, 2, 3, 4, 6] */


// .map Additional examples Revisited

var far1 = ["1","2","3","a"]
var far1m = far1.compactMap {
    Int($0)
}
far1m /* [Int] with content [1, 2, 3] */

far1m = far1.compactMap {
        Int($0)
    }
    .map {$0 * 2}
far1m /* [Int] with content [2, 4, 6] */





