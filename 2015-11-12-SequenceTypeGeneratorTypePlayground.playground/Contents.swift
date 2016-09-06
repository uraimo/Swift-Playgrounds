
//: ### Experimenting with Swift Sequences and Generators
//: ---
//:
//: Read the original post at [http://www.uraimo.com/2015/11/12/experimenting-with-swift-2-sequencetype-generatortype/](http://www.uraimo.com/2015/11/12/experimenting-with-swift-2-sequencetype-generatortype/)



//:Let's build a simple generator that produces numbers from the well known Fibonacci sequence:
class FibonacciIterator : IteratorProtocol {
    var last = (0,1)
    var endAt:Int
    var lastIteration = 0
    
    init(end:Int){
        endAt = end
    }
    
    func next() -> Int?{
        guard lastIteration<endAt else {
            return nil
        }
        lastIteration += 1
        
        let next = last.0
        last = (last.1,last.0+last.1)
        return next
    }
}

//: To return a finite sequence we need an additional constructor that we'll use to specify the sequence length and return *nil* instead of a new element when we reach it. There is not much else to see here other than the tuple swap trick that save us a few lines, but let's see how to use this generator: 

var fg = FibonacciIterator(end:10)

while let fib = fg.next() {
    print(fib)
}


// :This way we'll iterate on the generator elements until *nil* is returned.
    
//: Implementing a **SequenceType** for this generator is straightforward:

class FibonacciSequence : Sequence {
    var endAt:Int
    
    init(end:Int){
        endAt = end
    }
    
    func makeIterator() -> FibonacciIterator{
        return FibonacciIterator(end: endAt)
    }
}

let arr = Array(FibonacciSequence(end:10))

for f in FibonacciSequence(end: 10) {
    print(f)
}


//: But there is no need to declare the generator as a separated entity, we can use the **anyGenerator** utility method with the **AnyGenerator<T>** class to make this example more compact: 

class CompactFibonacciSequence : Sequence {
    var endAt:Int
    
    init(end:Int){
        endAt = end
    }
    
    func makeIterator() -> AnyIterator<Int> {
        var last = (0,1)
        var lastIteration = 0
        
        return AnyIterator{
            guard lastIteration<self.endAt else {
                return nil
            }
            lastIteration += 1
            
            let next = last.0
            last = (last.1,last.0+last.1)
            return next
        }
    }
}

for f in CompactFibonacciSequence(end: 10) {
    print(f)
}

//: In some circumstances, a simple sequence generated with **anyGenerator()** could be more than enough for what we want to do.
//: Let's create a sequence with the first 10 numbers of the [Lucas sequence](https://en.wikipedia.org/wiki/Lucas_number) (clearly not *that* Lucas), a numeric series similar to Fibonacci sequence that starts with *2,1* instead of *0,1*, using a generator and initialize an array with it:   

var last = (2,1)
var c = 0

let lucas = AnyIterator{
    ()->Int? in
    guard c<10 else {
        return nil
    }
    
    c += 1
    let next = last.0
    last = (last.1,last.0+last.1)
    return next
}

let a = Array(lucas) //[2, 1, 3, 4, 7, 11, 18, 29, 47, 76]


//: Definitely not bad, we removed a lot of boilerplate, but since we can improve our algorithm further with a formula involving the [golden ratio](https://en.wikipedia.org/wiki/Golden_ratio), let's do it:

import Darwin

let Phi = (sqrt(5)+1.0)/2
let phi = 1/Phi

func luc(n:Int)->Int {
    return Int(pow(Phi, Double(n))+pow(-phi,Double(n)))
}

c = 0
var compactLucas = AnyIterator{ c<10 ? luc(n: c+1): nil }

let a2 = Array(compactLucas) //[2, 1, 3, 4, 7, 11, 18, 29, 47, 76]

//: To try out some of the functional(ish) facilities that **SequenceType** provide, we'll now build a derived sequence that will only return *even* numbers from the Lucas sequence:

c = 0
var evenCompactLucas = AnyIterator{ c<10 ? luc(n: c+1): nil }.filter({$0 % 2 == 0})

let a3 = Array(evenCompactLucas) //[2, 4, 18, 76]

//: But now, what it we remove the nil termination requirement described above to build an infinite sequence of all the possible Lucas numbers?

c = 0
var infiniteLucas = AnyIterator{luc(n: c+1)}


let a4 = Array(infiniteLucas.prefix(10)) //[2, 1, 3, 4, 7, 11, 18, 29, 47, 76]

for var f in infiniteLucas.prefix(10){
    print(f)
}

//: But let's go a step further and again apply a *filter* to our sequence, to obtain a sequence of even Lucas numbers:
//:
//: Remove ".lazy" and grab a coffee...
var onlyEvenLucas = infiniteLucas.lazy.filter({$0 % 2 == 0})
for var f in onlyEvenLucas.prefix(10){
    print(f)
}


//: Let's see visually what's happening if we remove *.lazy* using a more verbose infinite sequence of integers that will print some text every time a value is requested from the generator:
class InfiniteSequence :Sequence {
    func makeIterator() -> AnyIterator<Int> {
        var i = 0
        return AnyIterator{
            print("# Returning "+String(i))
            i += 1
            return i
        }
    }
}

//: Again, remove ".lazy" and grab a coffee...
var fs = InfiniteSequence().lazy.filter({$0 % 2 == 0}).makeIterator()

for i in 1...5 {
    print(fs.next())
}






