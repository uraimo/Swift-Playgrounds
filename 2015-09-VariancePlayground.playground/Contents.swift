//: Playground - noun: a place where people can play

// See original post at http://www.uraimo.com/2015/09/29/Swift2.1-Functions-Covariance-Contravariance/

func testVariance(foo:(Int)->Any){foo(1)}

func innerAnyInt(p1:Any) -> Int{ return 1 }
func innerAnyAny(p1:Any) -> Any{ return 1 }
func innerIntInt(p1:Int) -> Int{ return 1 }
func innerIntAny(p1:Int) -> Any{ return 1 }

testVariance(foo:innerIntAny)
testVariance(foo:innerAnyInt)
testVariance(foo:innerAnyAny)
testVariance(foo:innerIntInt)

 
