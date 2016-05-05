//: Recursion and Trampolines Playground
//: -----
//:
//: See original post at [https://www.uraimo.com/2016/05/05/recursive-tail-calls-and-trampolines-in-swift/](https://www.uraimo.com/2016/05/05/recursive-tail-calls-and-trampolines-in-swift/)
//:


//: Two recursive functions that calculate triangula numbers

func tri(n:Int)->Int{
    if n <= 0 {
        return 0
    }
    return n+tri(n-1)
}

//: With tail recursion

func ttri(n:Int, acc:Int=0)->Int {
    if n<1 {
        return acc
    }
    return ttri(n-1,acc:acc+n)
}

ttri(300)
let verify = (300*(300+1))/2

//: With a trampoline
//:

enum Result<A>{
    case Done(A)
    case Call(()->Result<A>)
}

func tritr(n:Int)->Int {
    func ttri(n:Int, acc:Int=1)->Result<Int> {
        if n<1 {
            return .Done(acc)
        }
        return .Call({
            ()->Result<Int> in
            return ttri(n-1,acc: acc+n)
        })
    }
    
    let acc = 0
    var res = ttri(n,acc:acc)
    
    while true {
        switch res {
        case let .Done(accu):
            return accu
        case let .Call(f):
            res = f()
        }
    }
}


tritr(300)

//: withTrampoline utility function, that turns CPS functions into functions with an embedded trampoline

func withTrampoline<V,A>(f:(V,A)->Result<A>) -> ((V,A)->A){
    return { (value:V,accumulator:A)->A in
        var res = f(value,accumulator)
        
        while true {
            switch res {
            case let .Done(accu):
                return accu
            case let .Call(f):
                res = f()
            }
        }
    }
}

var fin: (n:Int, a:Int) -> Result<Int> = {_,_ in .Done(0)}
fin = { (n:Int, a:Int) -> Result<Int> in
    if n<1 {
        return .Done(a)
    }
    return .Call({
        ()->Result<Int> in
        return fin(n: n-1,a: a+n)
    })
}
let f = withTrampoline(fin)

f(30,0)


//: Without keeping track of the function in the enum
//:

enum Result2<V,A>{
    case Done(A)
    case Call(V, A)
}


func withTrampoline2<V,A>(f:(V,A)->Result2<V,A>) -> ((V,A)->A){
    return { (value:V,accumulator:A)->A in
        var res = f(value,accumulator)
        
        while true {
            switch res {
            case let .Done(accu):
                return accu
            case let .Call(num, accu):
                res = f(num,accu)
            }
        }
    }
}

let f2 = withTrampoline2 { (n:Int, a:Int) -> Result2<Int, Int> in
    if n<1 {
        return .Done(a)
    }
    return .Call(n-1,a+n)
}


f(30,0)




